<div class="iss-form">
  <section class="iss-card">
    <div class="iss-card__body">
      <form method="POST" style="margin-bottom:0;" action="?menu={$menu}">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" >
              <tr class="letra12">{$contentFilter}</tr>
          </table>
      </form>
      <br>
      <div class="iss-field iss-field--full">
        <span class="iss-field__control">
          <p align='center'><img alt="Graphic" src="{$URL_GRAPHIC}" /></p>
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