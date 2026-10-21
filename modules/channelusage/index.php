<?php
/* vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4:
  Codificación: UTF-8
  +----------------------------------------------------------------------+
  | Issabel version 0.5                                                  |
  | http://www.issabel.org                                               |
  +----------------------------------------------------------------------+
  | Copyright (c) 2021 Issabel Foundation                                |
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
  $Id: index.php, Thu 13 May 2021 06:40:42 PM EDT, nicolas@issabel.com
*/

// La grafica de este modulo se dibuja en el cliente con Chart.js, asi que no
// hace falta ninguna libreria de graficas en el servidor. El include que
// existia aqui (libs/paloSantoGraphImage.lib.php) arrastraba jpgraph, que no
// existe en Rocky Linux 10, y hacia fallar la pagina entera con HTTP 500.
function _moduleContent(&$smarty, $module_name) {

    function getData($id, $getTime=0) {
        $chUsage = new paloSantoChannelUsage;
        $hours = array();
        $channels = array();
        $data = $chUsage->channelsUsage($id);
        $times = $data['DATA']['DAT_1']['VALUES'];
        foreach ($times as $index => $value) {
            //echo $index.' - '.$value.'</br>';
            //echo date('d-M H:m:s',$value). '</br>';
            array_push($hours,$index*1000);
            array_push($channels,$value);
        }
        if ($getTime==1) {
           return $hours;
        } else {
           return $channels;
        }
    }

    //include module files
    include_once "modules/$module_name/configs/default.conf.php";
    include_once "modules/$module_name/libs/paloSantoChannelUsage.class.php";

    load_language_module($module_name);

    //global variables
    global $arrConf;
    global $arrConfModule;
    $arrConf = array_merge($arrConf,$arrConfModule);

    //folder path for custom templates
    $base_dir=dirname($_SERVER['SCRIPT_FILENAME']);
    $templates_dir=(isset($arrConf['templates_dir']))?$arrConf['templates_dir']:'themes';
    $local_templates_dir="$base_dir/modules/$module_name/".$templates_dir.'/'.$arrConf['theme'];

    $smarty->assign("title",_tr("Channels Usage Report"));
    $smarty->assign("icon","modules/$module_name/images/reports_channel_usage.png");
    if (date_default_timezone_get()) {
       $timezone = date_default_timezone_get();
    }
    $chUsage = new paloSantoChannelUsage;
    //2 - total 3 - dahdi 4 - SIP 5 - IAX 6 - H323 7 - Local
    $arrHours = getData(2,1);
    $arrTotal = getData(2);
    $arrDahdi = getData(3);
    $arrSIP   = getData(4);
    $arrIAX   = getData(5);
    $arrH323  = getData(6);
    $arrLocal = getData(7);
    $smarty->assign("timezone", $timezone);
    $smarty->assign("CHART_TITLE", _tr("Channels Usage Report"));
    $smarty->assign("PRINT", _tr("Print"));
    // Los datos de la grafica van en un bloque JSON: asi el navegador los
    // recibe como datos y no como codigo.
    $smarty->assign("CHART_DATA", json_encode(array(
        'timezone' => $timezone,
        'hours'    => $arrHours,
        'series'   => array(
            'total' => array('label' => _tr('Total Channels'),    'data' => $arrTotal),
            'dahdi' => array('label' => _tr('Zap Channels'),     'data' => $arrDahdi),
            'sip'   => array('label' => _tr('SIP Channels'),     'data' => $arrSIP),
            'iax'   => array('label' => _tr('IAX Channels'),     'data' => $arrIAX),
            'h323'  => array('label' => _tr('H323 Channels'),    'data' => $arrH323),
            'local' => array('label' => _tr('Local Channels'),   'data' => $arrLocal),
        ),
    ), JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP));
    return $smarty->fetch("$local_templates_dir/charts.tpl");
}
?>
