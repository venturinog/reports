<form method="POST" action="?menu={$module_name}">
<div class="iss-form">
  <div class="iss-form__toolbar">
    <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="submit_apply_changes" value="{$APPLY_CHANGES}" >
      <input class="button" type="submit" name="cancel" value="{$CANCEL}" >
    </div>
  </div>

  <div class="iss-reveal">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-currency-dollar"></i> {$CARD_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field iss-field--full">
        <span class="iss-field__control"><span class="iss-sev-warning">{$checkUpdate.LABEL}</span>&nbsp;{$checkUpdate.INPUT}&nbsp;&nbsp;&nbsp;&nbsp;<span class="iss-field__help">{$text_info}</span></span>
      </div>
      {if $name eq 'Default'}
      <div class="iss-field">
        <span class="iss-field__label">{$Prefix.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">*</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate.LABEL} {$by_min}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control"><a href="index.php?menu=currency">{$currency}</a>&nbsp;{$Rate.INPUT}</span>
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
        <span class="iss-field__control"><a href="index.php?menu=currency">{$currency}</a>&nbsp;{$Rate_offset.INPUT}</span>
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
        <span class="iss-field__control"><a href="index.php?menu=currency">{$currency}</a>&nbsp;{$Rate.INPUT}</span>
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
        <span class="iss-field__control"><a href="index.php?menu=currency">{$currency}</a>&nbsp;{$Rate_offset.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Trunk.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Trunk.INPUT}</span>
      </div>
      {/if}
    </div>
  </section>
  </div>

  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-history"></i> {$History}</header>
    <div class="iss-card__body">
      <table class="table table-hover align-middle iss-table" width="100%">
          <thead>
          <tr>
              <th align="center">{$Name.LABEL}</th>
              <th align="center">{$Prefix.LABEL}</th>
              <th align="center">{$Rate.LABEL} {$by_min}</th>
              <th align="center">{$Rate_offset.LABEL}</th>
              <th align="center">{$Creation_Date}</th>
              <th align="center">{$Date_close}</th>
              <th align="center">{$Trunk.LABEL}</th>
              <th align="center">{$Hidden_Digits.LABEL}</th>
              <th align="center">{$Status}</th>
          </tr>
          </thead>
          <tbody>
          {foreach from=$arrRates key=id item=rate name=rates}
              <tr>
              {if $smarty.foreach.rates.first}
                  {foreach from=$rate key=id2 item=rate2 name=rates2}
                  {if $id2 neq 'id'}
                      {if $id2 eq 'estado'}
                          {if $rate2 eq 'activo'}
                          <td align="center" class="iss-sev-ok">{$Current}</td>
                          {else}
                          <td align="center" class="iss-sev-unknown">{$Obsolete}</td>
                          {/if}
                      {else}
                          <td align="center">{$rate2}</td>
                      {/if}
                  {/if}
                  {/foreach}
              {else}
                  {foreach from=$rate key=id2 item=rate2 name=rates2}
                  {if $id2 neq 'id'}
                      {if $id2 eq 'estado'}
                          {if $rate2 eq 'activo'}
                          <td align="center" class="iss-sev-ok">{$Current}</td>
                          {else}
                          <td align="center" class="iss-sev-unknown">{$Obsolete}</td>
                          {/if}
                      {else}
                          <td align="center">{$rate2}</td>
                      {/if}
                  {/if}
                  {/foreach}
              {/if}
              </tr>
          {/foreach}
          </tbody>
      </table>
    </div>
  </section>
</div>

<input type="hidden" name="id" value="{$rate_id}">
<input type="hidden" name="namerate" value="{$namerate}">
</form>