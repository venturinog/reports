{$contentFilter}

<div class="iss-form">
  <section class="iss-card">
    <div class="iss-card__body">
      <div class="iss-field iss-field--full">
        <span class="iss-field__control">
          {if $mostrarSumario}
          <div class="iss-chart">
            <canvas id="myChart"></canvas>
          </div>
          {else}
          <p align="center">{$NO_DATA}</p>
          {/if}
        </span>
      </div>
      {if $mostrarSumario}
      <div class="iss-field iss-field--full">
        <span class="iss-field__control">
          <table class="table table-hover align-middle iss-table" width="100%">
            <thead>
              <tr>
                <th align="center">{$Rate_Name}</th>
                <th align="center">{$Title_Criteria}</th>
                <th align="center">%</th>
              </tr>
            </thead>
            <tbody>
            {foreach name=outer item=fila from=$results}
              <tr>
                {foreach key=key item=item from=fila name=data}
                <td align="right">{$item}</td>
                {/foreach}
              </tr>
            {/foreach}
            </tbody>
          </table>
        </span>
      </div>
      {/if}
    </div>
  </section>
</div>
{if $mostrarSumario}
<script src="{$WEBPATH}themes/{$THEMENAME}/js/chart.umd.min.js"></script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/issabel-charts.js"></script>
<script type="application/json" id="issabelDestDistributionChart">{$CHART_DATA}</script>
{/if}
