<?php
  /* vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4:
  Codificación: UTF-8
  +----------------------------------------------------------------------+
  | Issabel version 1.2-3                                               |
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
  $Id: default.conf.php,v 1.1 2008-09-01 10:09:57 jjvega Exp $ 
  $Id: default.conf.php,v 1.1 2015-02-23 11:05:27 achuto, dpanchana Exp $ */
require_once "libs/paloSantoDB.class.php";
require_once "libs/paloSantoSampler.class.php";
require_once "libs/paloSantoTrunk.class.php";

function _moduleContent(&$smarty, $module_name)
{
    //include issabel framework
    include_once "libs/paloSantoGrid.class.php";
    include_once "libs/paloSantoForm.class.php";
    include_once "libs/paloSantoConfig.class.php";
    include_once "libs/paloSantoQueue.class.php";

    //include module files
    include_once "modules/$module_name/configs/default.conf.php";
    include_once "modules/$module_name/libs/paloSantoExtention.class.php";
    
    load_language_module($module_name);

    //global variables
    global $arrConf;
    global $arrConfModule;
    $arrConf = array_merge($arrConf,$arrConfModule);

    //folder path for custom templates
    $base_dir=dirname($_SERVER['SCRIPT_FILENAME']);
    $templates_dir=(isset($arrConf['templates_dir']))?$arrConf['templates_dir']:'themes';
    $local_templates_dir="$base_dir/modules/$module_name/".$templates_dir.'/'.$arrConf['theme'];

    
    $pConfig = new paloConfig("/etc", "amportal.conf", "=", "[[:space:]]*=[[:space:]]*");
    $arrConfig = $pConfig->leer_configuracion(false);

    //solo para obtener los devices (extensiones) creadas.
    $dsnAsteriskCdr = $arrConfig['AMPDBENGINE']['valor']."://".
                      $arrConfig['AMPDBUSER']['valor']. ":".
                      $arrConfig['AMPDBPASS']['valor']. "@".
                      $arrConfig['AMPDBHOST']['valor']."/asteriskcdrdb";

    $pDB_cdr = new paloDB($dsnAsteriskCdr);//asteriskcdrdb -> CDR

    $dsnAsteriskDev = $arrConfig['AMPDBENGINE']['valor']."://".
                      $arrConfig['AMPDBUSER']['valor']. ":".
                      $arrConfig['AMPDBPASS']['valor']. "@".
                      $arrConfig['AMPDBHOST']['valor']."/asterisk";

    $pDB_ext = new paloDB($dsnAsteriskDev);//asterisk -> devices
    $accion = getAction();

    $content = "";
    switch($accion)
    {
        case "show":
            $_POST['nav'] = null; $_POST['start'] = null;
            $content = report_Extention($smarty, $module_name, $local_templates_dir, $pDB_cdr, $pDB_ext);
            break;
        default:
            $content = report_Extention($smarty, $module_name, $local_templates_dir, $pDB_cdr, $pDB_ext);
            break;
    }

    return $content;
}

function report_Extention($smarty, $module_name, $local_templates_dir, $pDB_cdr, $pDB_ext)
{
    $arrFormElements = array(
        "date_from"         => array(
            "LABEL"                  => _tr("Start date"),
            "REQUIRED"               => "yes",
            "INPUT_TYPE"             => "DATE",
            "INPUT_EXTRA_PARAM"      => "",
            "VALIDATION_TYPE"        => "text",
            "VALIDATION_EXTRA_PARAM" => ""),
        "date_to"           => array(
            "LABEL"                  => _tr("End date"),
            "REQUIRED"               => "no",
            "INPUT_TYPE"             => "DATE",
            "INPUT_EXTRA_PARAM"      => "",
            "VALIDATION_TYPE"        => "text",
            "VALIDATION_EXTRA_PARAM" => ""),
        "extensions"        => array(
            "LABEL"                  => _tr("Number"),
            "REQUIRED"               => "no",
            "INPUT_TYPE"             => "SELECT",
            "INPUT_EXTRA_PARAM"      => loadExtentions($pDB_ext),
            "VALIDATION_TYPE"        => "text",
            "EDITABLE"               => "yes",
            "VALIDATION_EXTRA_PARAM" => ""),
        "classify_by"       => array(
            "LABEL"                  => _tr("Classify by"),
            "REQUIRED"               => "no",
            "INPUT_TYPE"             => "SELECT",
            "INPUT_EXTRA_PARAM"      => array("Number"=>_tr('Extension (Number)'),"Queue"=>_tr('Queue'),"Trunk"=>_tr('Trunk')),
            "VALIDATION_TYPE"        => "text",
            "EDITABLE"               => "yes",
            "VALIDATION_EXTRA_PARAM" => "",
            'ONCHANGE'               => 'show_elements();'),
        "call_to"           => array(
            "LABEL"                  => _tr("Number"),
            "REQUIRED"               => "yes",
            "INPUT_TYPE"             => "TEXT",
            "INPUT_EXTRA_PARAM"      => array("id" => 'call_to'),
            "VALIDATION_TYPE"        => "text",
            "EDITABLE"               => "yes",
            "VALIDATION_EXTRA_PARAM" => ""),
        "trunks"            => array(
            "LABEL"                  => _tr("Trunk"),
            "REQUIRED"               => "no",
            "INPUT_TYPE"             => "SELECT",
            "INPUT_EXTRA_PARAM"      => loadTrunks($pDB_ext),
            "VALIDATION_TYPE"        => "text",
            "EDITABLE"               => "yes",
            "VALIDATION_EXTRA_PARAM" => ""),
    );

    $oFilterForm = new paloForm($smarty, $arrFormElements);
    $smarty->assign("SHOW", _tr("Show"));
    $smarty->assign("HERE", _tr("Here"));
    $smarty->assign("FILTER_TITLE", _tr("Show Filter"));
    $smarty->assign("PRINT", _tr("Print"));

    $date_ini = getParameter("date_from");
    $date_fin = getParameter("date_to");
    $ext = getParameter("call_to");

    $date_ini2 = translateDate($date_ini);
    $date_fin2 = translateDate($date_fin);
    $ext2 = $ext;

    $option = "";
    if( isset($_POST["classify_by"]) ){
        $option = $_POST["classify_by"];
    } elseif (isset($_GET["classify_by"])) {
        $option = $_GET["classify_by"];
    }
    if (!in_array($option, array("Number", "Queue", "Trunk"), true)) $option = "";
    // El formulario se pinta con el criterio elegido; si todavia no hay ninguno
    // se muestra el primero, que es el que el navegador deja seleccionado.
    $optionVisible = $option !== '' ? $option : "Number";
    $smarty->assign("class_number", $optionVisible === "Number" ? '' : ' neo-display-none');
    $smarty->assign("class_trunk", $optionVisible === "Trunk" ? '' : ' neo-display-none');

    if( getAction() == "show" ){
        $smarty->assign("date_from", $date_ini);
        $smarty->assign("date_1", $date_ini);

        $smarty->assign("date_to", $date_fin);
        $smarty->assign("date_2", $date_fin);

        $date_ini2 = translateDate($date_ini);
        $date_fin2 = translateDate($date_fin);
    }
    else{
        $_POST["date_from"] = date("d M Y");
        $_POST["date_to"] = date("d M Y");
        $date_ini = date("d M Y");
        $date_fin = date("d M Y");
        $date_ini2 = translateDate($date_ini);
        $date_fin2 = translateDate($date_fin);
    }

    $_POST["extensions"] = $ext;

    $smarty->assign("value_2", $date_ini);
    $smarty->assign("module_name", $module_name);

    $pExtention = new paloSantoExtention($pDB_cdr);

    $error = false;
    $chartType = "";
    $chartTitle = "";
    $chartTitle2 = "";
    $chartLabels = array();
    $chartData = array();
    $chartData2 = array();
    $noData = _tr("There are no data to present");
    if ($option == "Number") {
    	if (!preg_match("/^[1-9]{1}[[:digit:]]*$/",$ext) && isset($ext)) {
    	    $error = true;
    	    $smarty->assign("mb_title",_tr("Validation Error"));
    	    $smarty->assign("mb_message",_tr("The extension must be numeric and can not start with zero"));
    	}
        $smarty->assign("SELECTED_1","selected");
        $smarty->assign("SELECTED_2","");
        $smarty->assign("SELECTED_3","");

        $numIn = 0; $numOut = 0; $numTot = 0;
        $result = $pExtention->countCallsByExtension($date_ini2, $date_fin2, $ext);
        if (is_array($result)) {
        	$numIn = $result['num_incoming_call'];
            $numOut = $result['num_outgoing_call'];
            $numTot = $numIn + $numOut;
        }
        $noData = ($numTot != 0) ? "" : _tr("There are no data to present");

        $chartLabels = array(_tr("Incoming Calls"), _tr("Outcoming Calls"));
        $chartData = array($numIn, $numOut);
        $chartTitle = _tr("Number of calls extension").' '.$ext2;
        $chartType = "extension";
        $tpl = "extension.tpl";

    } else if($option == "Queue") {
        $smarty->assign("SELECTED_1","");
        $smarty->assign("SELECTED_2","selected");
        $smarty->assign("SELECTED_3","");
        $dti   = isset($_GET['dti'])?$_GET['dti']:"";//fecha inicio
        $dtf   = isset($_GET['dtf'])?$_GET['dtf']:"";//fecha fin
        $objPalo_AST_CDR = new paloSantoExtention($pDB_cdr);
        $paloQueue = new paloQueue($pDB_ext);
        $arrQueues = $paloQueue->getQueue();
        foreach($arrQueues as $k => $arrMuestra){
        //    $arrTimestamp[$k] = $k; /* X */

            //$arr = $objPalo_AST_CDR->countQueue( $arrMuestra['id'], $dti, $dtf);
            $arrQueueName[$k] = $arrMuestra[1];
            $arr = $objPalo_AST_CDR->countQueue( $arrMuestra[0], $date_ini2, $date_fin2);
            $arrValue[$k] = $arr[0]; /* Y */
        }
        $chartTitle = _tr("Number Calls vs Queues");
        $chartLabels = array_values($arrQueueName);
        $chartData = array_values($arrValue);
        $chartType = "queue";
        $noData = "";

    } else if($option == "Trunk") {
        $smarty->assign("SELECTED_1","");
        $smarty->assign("SELECTED_2","");
        $smarty->assign("SELECTED_3","selected");
        $trunkT = getParameter("trunks");
        $smarty->assign("trunks", $trunkT);
        
        $regs = NULL;
        if (preg_match('!^DAHDI/(g|r)(\d+)$!i', $trunkT, $regs)) {
             $iGrupoTrunk = (int)$regs[2];
             $gruposTrunk = getTrunkGroupsDAHDI();
             if (is_array($gruposTrunk) && isset($gruposTrunk[$iGrupoTrunk])) {
                 $trunkT = $gruposTrunk[$iGrupoTrunk];
             }
        }
        $objPalo_AST_CDR_Trunk = new paloSantoExtention($pDB_cdr);

        //total minutos de llamadas in y out
        $chartTitle = $trunkT.': '._tr("Total Time");
        $chartLabels = _tr("Incoming Calls").", "._tr("Outcoming Calls");
        $arrayTemp = $objPalo_AST_CDR_Trunk->loadTrunks($trunkT, "min", $date_ini2, $date_fin2);
        $arrTrunkMin = $arrayTemp[0];
        //total llamadas in y out
        $chartTitle2 = $trunkT.': '._tr("Number of Calls");
        $arrayTemp = $objPalo_AST_CDR_Trunk->loadTrunks($trunkT, "numcall", $date_ini2, $date_fin2);
        $arrTrunkNum = $arrayTemp[0];

        $numTot = $arrTrunkNum[0] + $arrTrunkNum[1];
        $noData = ($numTot != 0) ? "" : _tr("There are no data to present");
        

        $chartLabels = array(_tr("Incoming Calls"), _tr("Outcoming Calls"));
        $chartData = array_values($arrTrunkMin);
        $chartData2 = array_values($arrTrunkNum);
        $chartType = "trunk";

    }
    $smarty->assign("icon","modules/$module_name/images/reports_graphic_reports.png");
    $htmlForm = $oFilterForm->fetchForm("$local_templates_dir/filter.tpl", _tr("Graphic Report"), $_POST);

    // El <form> vive en la plantilla, no aqui: si el envoltorio de PHP monta el
    // formulario, paloForm no encuentra ninguna etiqueta <form> donde inyectar
    // el token CSRF y la pagina se guarda sin token.
    $contenidoModulo = $htmlForm;

    // Los datos de la grafica viajan en un bloque JSON: asi el navegador los
    // recibe como datos y no como codigo.
    $smarty->assign("CHART_DATA", json_encode(array(
        'type'    => $chartType,
        'title'   => $chartTitle,
        'title2'  => $chartTitle2,
        'labels'  => $chartLabels,
        'values'  => $chartData,
        'values2' => $chartData2,
        'noData'  => $noData,
    ), JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP));

    $contenidoModulo .= $smarty->fetch("$local_templates_dir/extension.tpl");

    return $contenidoModulo;
}

function loadExtentions($pDB_ext)
{
    $pExtention = new paloSantoExtention($pDB_ext);
    $arrayExt = $pExtention->loadExtentions();

    $arrayR = array();
    foreach($arrayExt as $key => $value){
        $arrayR[$value['id']] = $value['id'];
    }

    return $arrayR; 
}

function loadTrunks($pDB_ext)
{
    include_once "libs/paloSantoTrunk.class.php";

    $arrTrunksTemp = getTrunks($pDB_ext);
    $arrTrunk = array();
    foreach($arrTrunksTemp as $key => $arr){
        $arrTrunk[ $arr[1] ] = $arr[1]; 
    }

    return $arrTrunk;
}

function getAction()
{
    foreach (array('show', 'new') as $key)
        if (getParameter($key)) return $key;
    $action = getParameter('action');
    if ($action == 'show') return $action;
    return 'report';
}
?>
