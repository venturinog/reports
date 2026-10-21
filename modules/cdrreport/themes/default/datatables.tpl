<script>
var cdrs = {$CDR};
var lang = "{$LANG}";
var DELMSG = "{$DELMSG}";
var module = "{$module_name}";
var TITLE_COLUMNS = {$TITLE_COLUMNS};
var TITLE_SELECT_ALL = {$TITLE_SELECT_ALL};
var TITLE_SELECT_NONE = {$TITLE_SELECT_NONE};
</script>

<script>
{$customJS}
</script>

<style>
/* Cargador de la tabla. Los colores salen de los tokens del tema, para que
   siga al modo claro y oscuro. */
#loader {
    border: 8px solid var(--iss-border);
    border-radius: 50%;
    border-top-color: var(--iss-primary);
    width: 30px;
    height: 30px;
    animation: iss-cdr-spin 1s linear infinite;
}

@keyframes iss-cdr-spin {
    100% {
        transform: rotate(360deg);
    }
}

.center {
    position: relative;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;
}
</style>


</br>
<span id="msgFilter">
    {$FILTER_MSG}
</span>
</br>
</br>
<table id='CDRreport' class="table table-striped table-hover iss-table" style="width:100%">
  <thead>
    <tr>
      <th>{$COLUMNS[0]}</th>
      <th>{$COLUMNS[1]}</th>
      <th>{$COLUMNS[2]}</th>
      <th>{$COLUMNS[3]}</th>
      <th>{$COLUMNS[4]}</th>
      <th>{$COLUMNS[5]}</th>
      <th>{$COLUMNS[6]}</th>
      <th>{$COLUMNS[7]}</th>
      <th>{$COLUMNS[8]}</th>
      <th>{$COLUMNS[9]}</th>
      <th>{$COLUMNS[15]}</th>
      <th>{$COLUMNS[14]}</th>
      <th>CEL</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
<div id="loader" class="center"></div>

<div class="iss-chart iss-chart--short">
  <canvas id="myChart"></canvas>
</div>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/chart.umd.min.js"></script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/issabel-charts.js"></script>

<div class="iss-form__toolbar">
  <div class="iss-form__buttons">
    <button type="button" class="button" id="download-pdf2" onclick="downloadPDF2();">
      <i class="ti ti-file-type-pdf"></i> {$PRINT}
    </button>
  </div>
</div>

<div class="modal fade" id="gridModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog {$modalClass}" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">{#modalTitle#}</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="gridModalContent">
        {$modalContent}
      </div>
    </div>
  </div>
</div>
