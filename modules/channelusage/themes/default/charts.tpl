<div class="iss-form">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-chart-line"></i> {$CHART_TITLE}</header>
    <div class="iss-card__body">
      <div class="iss-field iss-field--full">
        <span class="iss-field__control">
          <div class="iss-chart iss-chart--tall">
            <canvas id="myChart"></canvas>
          </div>
        </span>
      </div>
      <div class="iss-form__toolbar">
        <div class="iss-form__buttons">
          <button type="button" class="button" id="download-pdf2" onclick="printChart();">
            <i class="ti ti-printer"></i> {$PRINT}
          </button>
        </div>
      </div>
    </div>
  </section>
</div>
<script type="application/json" id="issabelChannelUsage">{$CHART_DATA}</script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/moment.min.js"></script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/chart.umd.min.js"></script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/chartjs-adapter-moment.min.js"></script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/issabel-charts.js"></script>
