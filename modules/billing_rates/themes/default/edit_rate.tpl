<form method="POST" action="?menu={$module_name}">
<div class="iss-form">
  <div class="iss-form__toolbar">
    <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="submit_apply_changes" value="{$APPLY_CHANGES}" >
      <input class="button" type="submit" name="cancel" value="{$CANCEL}" >
    </div>
  </div>

  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field iss-field--full">
        <span class="iss-field__control"><span style="font-weight:bold; font-style: italic; color:#E35332; font-size: 14px;">&nbsp;{$checkUpdate.LABEL}</span>{$checkUpdate.INPUT}&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-style: italic; font-size: 12px;">{$text_info}</span></span>
      </div>
      {if $name eq 'Default'}
      <div class="iss-field">
        <span class="iss-field__label">{$Prefix.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">*</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate.LABEL} {$by_min}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control"><a href="index.php?menu=currency" style="text-decoration:none;">{$currency}</a>&nbsp;{$Rate.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Hidden_Digits.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Hidden_Digits.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Name.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$name}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate_offset.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control"><a href="index.php?menu=currency" style="text-decoration:none;">{$currency}</a>&nbsp;{$Rate_offset.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Trunk.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">*</span>
      </div>
      {else}
      <div class="iss-field">
        <span class="iss-field__label">{$Prefix.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$prefix}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate.LABEL} {$by_min}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control"><a style="text-decoration:none;" href="index.php?menu=currency">{$currency}</a>&nbsp;{$Rate.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Hidden_Digits.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Hidden_Digits.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Name.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Name.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate_offset.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control"><a href="index.php?menu=currency" style="text-decoration:none;">{$currency}</a>&nbsp;{$Rate_offset.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Trunk.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Trunk.INPUT}</span>
      </div>
      {/if}
    </div>
  </section>

  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-history"></i> {$History}</header>
    <div class="iss-card__body">
      <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="table_data">
          <tr class="table_title_row">
              <td class="table_title_row" align="center">{$Name.LABEL}</td>
              <td class="table_title_row" align="center">{$Prefix.LABEL}</td>
              <td class="table_title_row" align="center">{$Rate.LABEL} {$by_min}</td>
              <td class="table_title_row" align="center">{$Rate_offset.LABEL}</td>
              <td class="table_title_row" align="center">{$Creation_Date}</td>
              <td class="table_title_row" align="center">{$Date_close}</td>
              <td class="table_title_row" align="center">{$Trunk.LABEL}</td>
              <td class="table_title_row" align="center">{$Hidden_Digits.LABEL}</td>
              <td class="table_title_row" align="center">{$Status}</td>
          </tr>
          {foreach from=$arrRates key=id item=rate name=rates}
               <tr onmouseout="this.style.backgroundColor='var(--iss-surface)';" onmouseover="this.style.backgroundColor='var(--iss-surface-2)';" style="background-color: var(--iss-surface);">
              {if $smarty.foreach.rates.first}
                  {foreach from=$rate key=id2 item=rate2 name=rates2}
                  {if $id2 neq 'id'}
                      {if $id2 eq 'estado'}
                          {if $rate2 eq 'activo'}
                          <td class="table_data" align="center" style="color: green;">{$Current}</td>
                          {else}
                          <td class="table_data" align="center" style="color: green;">{$Obsolete}</td>
                          {/if}
                      {else}
                          <td class="table_data" align="center" style="color: green;">{$rate2}</td>
                      {/if}
                  {/if}
                  {/foreach}
              </tr>
              {else}
                  {foreach from=$rate key=id2 item=rate2 name=rates2}
                  {if $id2 neq 'id'}
                      {if $id2 eq 'estado'}
                          {if $rate2 eq 'activo'}
                          <td align="center" class="table_data">{$Current}</td>
                          {else}
                          <td align="center" class="table_data">{$Obsolete}</td>
                          {/if}
                      {else}
                          <td align="center" class="table_data">{$rate2}</td>
                      {/if}
                  {/if}
                  {/foreach}
              </tr>
              {/if}
          {/foreach}
      </table>
    </div>
  </section>
</div>

<input type="hidden" name="id_rate" value="{$id_rate}">
</form>