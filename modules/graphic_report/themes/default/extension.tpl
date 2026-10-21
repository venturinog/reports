<div class="iss-form">
  <section class="iss-card">
    <div class="iss-card__body">
      <div class="iss-field iss-field--full">
        <span class="iss-field__control">
          <div class="iss-chart iss-chart--short">
            <canvas id="myChart"></canvas>
          </div>
        </span>
      </div>
      <div class="iss-field iss-field--full">
        <span class="iss-field__control">
          <div class="iss-chart iss-chart--short">
            <canvas id="myChart2"></canvas>
          </div>
        </span>
      </div>
      <div class="iss-form__toolbar">
        <div class="iss-form__buttons">
          <button type="button" class="button" id="download-pdf2" onclick="printGraphic();">
            <i class="ti ti-printer"></i> {$PRINT}
          </button>
        </div>
      </div>
    </div>
  </section>
</div>
<script type="application/json" id="issabelGraphicReport">{$CHART_DATA}</script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/chart.umd.min.js"></script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/chartjs-plugin-datalabels.min.js"></script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/issabel-charts.js"></script>
