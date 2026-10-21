<?php
  /* vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4:
  Codificación: UTF-8
  +----------------------------------------------------------------------+
  | Issabel version 1.4-1                                                |
  | http://www.issabel.org                                               |
  +----------------------------------------------------------------------+
  | Copyright (c) 2006 Palosanto Solutions S. A.                         |
  +----------------------------------------------------------------------+
  | The contents of this file are subject to the General Public License  |
  | (GPL) Version 2 (the "License"); you may not use this file except in |
  | compliance with the License. You may obtain a copy of the License at |
  | http://www.opensource.org/licenses/gpl-license.php                   |
  |                                                                      |
  | Software distributed under the License is distributed on an "AS IS"  |
  | basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  |
  | the License for the specific language governing rights and           |
  | limitations under the License.                                       |
  +----------------------------------------------------------------------+
  | The Initial Developer of the Original Code is PaloSanto Solutions    |
  +----------------------------------------------------------------------+
  $Id: index.php,v 1.1 2009-01-06 09:01:38 bmacias bmacias@palosanto.com Exp $ */
//include issabel framework
include_once "libs/paloSantoGrid.class.php";
include_once "libs/paloSantoForm.class.php";
include_once "libs/misc.lib.php";
include_once "libs/issabelReportForm.class.php";

function _moduleContent(&$smarty, $module_name)
{
    //include module files
    include_once "modules/$module_name/configs/default.conf.php";
    include_once "modules/$module_name/libs/paloSantoReportCall.class.php";
    include_once "libs/paloSantoConfig.class.php";

    $base_dir=dirname($_SERVER['SCRIPT_FILENAME']);

    load_language_module($module_name);

    //global variables
    global $arrConf;
    global $arrConfModule;
    $arrConf = array_merge($arrConf,$arrConfModule);

    //folder path for custom templates
    $templates_dir=(isset($arrConf['templates_dir']))?$arrConf['templates_dir']:'themes';
    $local_templates_dir="$base_dir/modules/$module_name/".$templates_dir.'/'.$arrConf['theme'];

    //conexion resource
    $pConfig = new paloConfig("/etc", "amportal.conf", "=", "[[:space:]]*=[[:space:]]*");
    $arrConfig = $pConfig->leer_configuracion(false);
    $dsnAsteriskCdr = $arrConfig['AMPDBENGINE']['valor']."://".
                      $arrConfig['AMPDBUSER']['valor']. ":".
                      $arrConfig['AMPDBPASS']['valor']. "@".
                      $arrConfig['AMPDBHOST']['valor']."/asteriskcdrdb";

    $pDB_cdr = new paloDB($dsnAsteriskCdr);//asteriskcdrdb -> CDR
    $pDB_billing = new paloDB("sqlite3:///$arrConf[issabel_dbdir]/rate.db"); //sqlite3 -> rate.db

    //actions
    $accion = getAction();
    $content = "";

    switch($accion){
        case 'graph':
            $content = graphPage($smarty, $module_name, $local_templates_dir, $pDB_cdr);
            break;
        default:
            $content = reportReportCall($smarty, $module_name, $local_templates_dir, $pDB_cdr, $pDB_billing, $arrConf);
            break;
    }
    return $content;
}

function reportReportCall($smarty, $module_name, $local_templates_dir, &$pDB_cdr, &$pDB_billing , $arrConf)
{
    $pReportCall = new paloSantoReportCall($pDB_cdr, $pDB_billing);

    //PARAMETERS
    $type          = getParameter("option_fil");
    $value_tmp     = getParameter("value_fil");
    $date_ini_tmp  = getParameter("date_from");
    $date_end_tmp  = getParameter("date_to");
    $order_by_tmp  = getParameter("order_by");
    $order_type_tmp= getParameter("order_type");
    $action = getParameter("nav");
    $start  = getParameter("start");

    $value     = isset($value_tmp)   ?$value_tmp:"";
    $order_by  = isset($order_by_tmp)?$order_by_tmp:1;
    $order_type= isset($order_type_tmp)?$order_type_tmp:"asc";
    $date_from = isset($date_ini_tmp)?$date_ini_tmp:date("d M Y");
    $date_to   = isset($date_end_tmp)?$date_end_tmp:date("d M Y");

    $date_ini  = translateDate($date_from)." 00:00:00";
    $date_end  = translateDate($date_to)." 23:59:59";

    //**********************************

    //begin grid parameters
    $oGrid  = new paloSantoGrid($smarty);

    $limit  = 40;
    $total  = $pReportCall->ObtainNumberDevices($type,$value);
    $oGrid->setLimit($limit);
    $oGrid->setTotal($total);

    $oGrid->calculatePagination($action,$start);
    $offset = $oGrid->getOffsetValue();
    $end    = $oGrid->getEnd();
    $urlFields = array(
        'menu'          =>  $module_name,
        'option_fil'    =>  $type,
        'value_fil'     =>  $value,
        'date_from'     =>  $date_from,
        'date_to'       =>  $date_to,
    );
    $url = construirUrl($urlFields, array('nav', 'start'));
    $urlFields['order_by'] = $order_by;
    $urlFields['order_type'] = $order_type;

    $smarty->assign("order_by", $order_by);
    $smarty->assign("order_type", $order_type);

    $arrData = null;
    $arrResult = $pReportCall->ObtainReportCall($limit,$offset,$date_ini,$date_end,$type,$value,$order_by,$order_type);
    if ($pReportCall->errMsg != '') {
    	$smarty->assign('mb_message', $pReportCall->errMsg);
    }

    $order_type = ($order_type == "desc")?"asc":"desc";

    if(is_array($arrResult) && $total>0){
        foreach($arrResult as $key => $val){
            $ext = $val['extension'];

            // Los datos vienen de la base de datos y la grilla los pinta como
            // HTML: hay que escaparlos.
            $arrTmp[0] = htmlspecialchars($ext, ENT_COMPAT, 'UTF-8');
            $arrTmp[1] = htmlspecialchars($val['user_name'], ENT_COMPAT, 'UTF-8');
            $arrTmp[2] = htmlspecialchars($val['num_incoming_call'], ENT_COMPAT, 'UTF-8');
            $arrTmp[3] = htmlspecialchars($val['num_outgoing_call'], ENT_COMPAT, 'UTF-8');
            $arrTmp[4] = "<span class='iss-sev-ok' title='".htmlspecialchars($val['duration_incoming_call'], ENT_COMPAT, 'UTF-8')." "._tr('seconds')."'>".$pReportCall->Sec2HHMMSS($val['duration_incoming_call'])."</span>";
            $arrTmp[5] = "<span class='iss-sev-ok' title='".htmlspecialchars($val['duration_outgoing_call'], ENT_COMPAT, 'UTF-8')." "._tr('seconds')."'>".$pReportCall->Sec2HHMMSS($val['duration_outgoing_call'])."</span>";
            $arrTmp[6] = "<a href='javascript: popup_ventana(\"?menu=$module_name&action=graph&rawmode=yes&ext=".urlencode($ext)."&dini=".urlencode($date_ini)."&dfin=".urlencode($date_end)."\");'>".
                    ""._tr('Call Details')."</a>";

            $arrData[] = $arrTmp;
        }
    }
    $img = "<img src='images/flecha_$order_type.png' border='0' align='absmiddle'>";

    $leyend_1 = "<a class='link_summary_off' href='$url&amp;order_by=1&amp;order_type=asc'>"._tr("Extension")."</a>";
    $leyend_2 = "<a class='link_summary_off' href='$url&amp;order_by=2&amp;order_type=asc'>"._tr("User name")."</a>";
    $leyend_3 = "<a class='link_summary_off' href='$url&amp;order_by=3&amp;order_type=asc'>"._tr("Num. Incoming Calls")."</a>";
    $leyend_4 = "<a class='link_summary_off' href='$url&amp;order_by=4&amp;order_type=asc'>"._tr("Num. Outgoing Calls")."</a>";
    $leyend_5 = "<a class='link_summary_off' href='$url&amp;order_by=5&amp;order_type=asc'>"._tr("Sec. Incoming Calls")."</a>";
    $leyend_6 = "<a class='link_summary_off' href='$url&amp;order_by=6&amp;order_type=asc'>"._tr("Sec. Outgoing Calls")."</a>";


    if($order_by == 1)      $leyend_1 = "<a class='link_summary_on' href='$url&amp;order_by=1&amp;order_type=$order_type'>"._tr("Extension")."&nbsp;$img</a>";
    else if($order_by == 2) $leyend_2 = "<a class='link_summary_on' href='$url&amp;order_by=2&amp;order_type=$order_type'>"._tr("User name")."&nbsp;$img</a>";
    else if($order_by == 3) $leyend_3 = "<a class='link_summary_on' href='$url&amp;order_by=3&amp;order_type=$order_type'>"._tr("Num. Incoming Calls")."&nbsp;$img</a>";
    else if($order_by == 4) $leyend_4 = "<a class='link_summary_on' href='$url&amp;order_by=4&amp;order_type=$order_type'>"._tr("Num. Outgoing Calls")."&nbsp;$img</a>";
    else if($order_by == 5) $leyend_5 = "<a class='link_summary_on' href='$url&amp;order_by=5&amp;order_type=$order_type'>"._tr("Sec. Incoming Calls")."&nbsp;$img</a>";
    else if($order_by == 6) $leyend_6 = "<a class='link_summary_on' href='$url&amp;order_by=6&amp;order_type=$order_type'>"._tr("Sec. Outgoing Calls")."&nbsp;$img</a>";

    $arrGrid =
        array("title"    => _tr("Summary by Extension"),
              "icon"     => "images/list.png",
              "width"    => "100%",
              "start"    => ($total==0) ? 0 : $offset + 1,
              "end"      => $end,
              "total"    => $total,
              "url"      => $urlFields,
              "columns"  => array(
		            0 => array("name"      => $leyend_1,
                               "property1" => ""),
		            1 => array("name"      => $leyend_2,
                               "property1" => ""),
		            2 => array("name"      => $leyend_3,
                               "property1" => ""),
                    3 => array("name"      => $leyend_4,
                               "property1" => ""),
                    4 => array("name"      => $leyend_5,
                               "property1" => ""),
                    5 => array("name"      => $leyend_6,
                               "property1" => ""),
                    6 => array("name"      => _tr("Details"),
                               "property1" => ""),
                                        )
                    );

    //begin section filter
    $arrFormFilterReportCall = createFieldForm();
    $oFilterForm = new paloForm($smarty, $arrFormFilterReportCall);

    /* Validacion por campo: el servidor es la fuente de verdad y la pagina se
     * vuelve a pintar con el error bajo el campo que falla, sin redirigir. */
    $errors = array();
    if (trim((string)$date_from) === '') {
        $errors['date_from'] = issabelReportError(_tr('Start date'), true);
    } else if (!issabelReportValidDate($date_from)) {
        $errors['date_from'] = issabelReportError(_tr('Start date'), false, false);
    }
    if (trim((string)$date_to) === '') {
        $errors['date_to'] = issabelReportError(_tr('End date'), true);
    } else if (!issabelReportValidDate($date_to)) {
        $errors['date_to'] = issabelReportError(_tr('End date'), false, false);
    }
    if (trim((string)$value) !== '' && !is_numeric($value)) {
        $errors['value_fil'] = issabelReportError(_tr('Value'), false, false);
    }
    if (count($errors) > 0) {
        issabelReportMarkInvalid($arrFormFilterReportCall, $errors);
        $oFilterForm = new paloForm($smarty, $arrFormFilterReportCall);
    }
    $smarty->assign("ERRORS", issabelReportErrorMap($arrFormFilterReportCall, $errors));
    $_POST['option_fil'] = $type;
    $_POST['value_fil'] = $value;
    $_POST['date_from'] = $date_from;
    $_POST['date_to']   = $date_to;
    $smarty->assign("SHOW", _tr("Show"));
    $smarty->assign("FILTER_TITLE", _tr("Show Filter"));

    if($_POST["date_from"]==="")
        $_POST["date_from"]  = " ";

    if($_POST['date_to']==="")
        $_POST['date_to']  = " ";

    $oGrid->addFilterControl(_tr("Filter applied: ")._tr("Start Date")." = ".$date_from.", "._tr("End Date")." = ".
    $date_to, $_POST, array("date_from" => date("d M Y"),"date_to" => date("d M Y")),true);

    $valueType = "";
    if(!is_null($type)){
        if($type=="Ext")
            $valueType=_tr("Extension");
        else
            $valueType=_tr("User");
    }
    $oGrid->addFilterControl(_tr("Filter applied: ").$valueType." = ".$value, $_POST, array("option_fil" => "Ext","value_fil" => ""));


    $htmlFilter = $oFilterForm->fetchForm("$local_templates_dir/filter.tpl","",$_POST);
    //end section filter

    $oGrid->showFilter(trim($htmlFilter));
    $contenidoModulo = $oGrid->fetchGrid($arrGrid, $arrData);

    return $contenidoModulo;
}

function createFieldForm(){
    $arrFormElements = array(
            "option_fil"=> array( "LABEL"                  => _tr("Filter by"),
                                  "REQUIRED"               => "no",
                                  "INPUT_TYPE"             => "SELECT",
                                  "INPUT_EXTRA_PARAM"      => array("Ext"=>_tr("Extension"),"User"=>_tr("User")),
                                  "VALIDATION_TYPE"        => "text",
                                  "EDITABLE"               => "yes",
                                  "VALIDATION_EXTRA_PARAM" => ""),
            "value_fil" => array( "LABEL"                  => _tr("Value"),
                                  "REQUIRED"               => "no",
                                  "INPUT_TYPE"             => "TEXT",
                                  "INPUT_EXTRA_PARAM"      => "",
                                  "VALIDATION_TYPE"        => "numeric",
                                  "VALIDATION_EXTRA_PARAM" => ""),
            "date_from" => array( "LABEL"                  => _tr("Start date"),
                                  "REQUIRED"               => "yes",
                                  "INPUT_TYPE"             => "DATE",
                                  "INPUT_EXTRA_PARAM"      => array("FORMAT" => "%d %b %Y"),
                                  "VALIDATION_TYPE"        => "ereg",
                                  "VALIDATION_EXTRA_PARAM" => "^[[:digit:]]{1,2}[[:space:]]+[[:alnum:]]{3}[[:space:]]+[[:digit:]]{4}$"),
            "date_to"   => array( "LABEL"                  => _tr("End date"),
                                  "REQUIRED"               => "yes",
                                  "INPUT_TYPE"             => "DATE",
                                  "INPUT_EXTRA_PARAM"      => array("FORMAT" => "%d %b %Y"),
                                  "VALIDATION_TYPE"        => "ereg",
                                  "VALIDATION_EXTRA_PARAM" => "^[[:digit:]]{1,2}[[:space:]]+[[:alnum:]]{3}[[:space:]]+[[:digit:]]{4}$"),
                    );
    return $arrFormElements;
}

/*
 * Ventana de detalle de llamadas: dos graficas de torta (10 principales
 * entrantes y salientes). Antes esta pagina pedia dos imagenes PNG al servidor
 * con jpgraph, que no existe en Rocky Linux 10, y las dos quedaban rotas.
 */
function graphPage($smarty, $module_name, $local_templates_dir, &$pDB_cdr)
{
    $pReportCall = new paloSantoReportCall($pDB_cdr);

    $ext  = (string)getParameter('ext');
    $dini = (string)getParameter('dini');
    $dfin = (string)getParameter('dfin');

    $entrantes = $pReportCall->callbackTop10Entrantes($dini, $dfin, $ext);
    $salientes = $pReportCall->callbackTop10Salientes($dini, $dfin, $ext);

    $smarty->assign("LANG", get_language());
    $smarty->assign("CHART_TITLE", _tr("Call Details"));
    $smarty->assign("CHART_DATA", json_encode(array(
        'incoming' => $entrantes,
        'outgoing' => $salientes,
        'text' => array(
            'noData'   => _tr("No data to display"),
            'unitOne'  => _tr("call"),
            'unitMany' => _tr("calls"),
        ),
    ), JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP));

    return $smarty->fetch("file:$local_templates_dir/summary_charts.tpl");
}

function getAction()
{
    if(getParameter("show")) //Get parameter by POST (submit)
        return "show";
    else if(getParameter("action")=="show") //Get parameter by GET (command pattern, links)
        return "show";
    else if(getParameter("action")=="graph") //Get parameter by GET (command pattern, links)
        return "graph";
    else
        return "report";
}
?>
