<form method="POST">
<div class="iss-form">
  <div class="iss-form__toolbar">
    {if $mode eq 'input'}
    <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="save_default" value="{$SAVE}">
      <input class="button" type="submit" name="cancel" value="{$CANCEL}">
    </div>
    {else}
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="edit_default" value="{$EDIT}">
    </div>
    {/if}
  </div>

  {if $mode eq 'input'}
  <div class="iss-reveal">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-currency-dollar"></i> {$CARD_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$default_rate.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$default_rate.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$default_rate_offset.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$default_rate_offset.INPUT}</span>
      </div>
    </div>
  </section>
  </div>
  {else}
  <section class="iss-card">
    <div class="iss-card__body iss-formgrid iss-formgrid--3col iss-formgrid--readonly">
      <div class="iss-field">
        <span class="iss-field__label">{$default_rate.LABEL}</span>
        <span class="iss-field__control iss-field__value{if $VIEW.default_rate eq ''} iss-field__value--empty{/if}">{if $VIEW.default_rate eq ''}&mdash;{else}{$VIEW.default_rate|escape}{/if}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$default_rate_offset.LABEL}</span>
        <span class="iss-field__control iss-field__value{if $VIEW.default_rate_offset eq ''} iss-field__value--empty{/if}">{if $VIEW.default_rate_offset eq ''}&mdash;{else}{$VIEW.default_rate_offset|escape}{/if}</span>
      </div>
    </div>
  </section>
  {/if}
</div>
</form>
