<div class="iss-form">
  <section class="iss-card">
    <div class="iss-card__body">
      <form method="POST" style="margin-bottom:0;" action="?menu={$menu}">
          {$ISSABEL_CSRF_FIELD}
          <table width="100%" border="0" cellspacing="0" cellpadding="0" >
              <tr class="letra12">{$contentFilter}</tr>
          </table>
      </form>
      <br>
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
          <table class="table_data" align="center" cellspacing="0" cellpadding="0">
          <tr class="table_title_row">
              <td align='center' class="table_title_row borderLeft" style="background:none;">{$Rate_Name}</td>
              <td align='center' class="table_title_row">{$Title_Criteria}</td>
              <td align='center' class="table_title_row borderRight">%</td>
          </tr>
          {foreach name=outer item=fila from=$results}
          <tr>
              {foreach key=key item=item from=$fila name=data}
              <td class="table_data" align="right">{$item}</td>
              {/foreach}
          </tr>
          {/foreach}
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