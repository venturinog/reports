<form method="POST">
<div class="iss-form">
  <div class="iss-form__toolbar">
    {if $mode eq 'input'}
    <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="save_default" value="{$SAVE}" >
      <input class="button" type="submit" name="cancel" value="{$CANCEL}">
    </div>
    {else}
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="edit_default" value="{$EDIT}">
    </div>
    {/if}
  </div>

  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$default_rate.LABEL}{if $mode eq 'input'}&nbsp;<span class="iss-required">*</span>{/if}</span>
        <span class="iss-field__control">{$default_rate.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$default_rate_offset.LABEL}{if $mode eq 'input'}&nbsp;<span class="iss-required">*</span>{/if}</span>
        <span class="iss-field__control">{$default_rate_offset.INPUT}</span>
      </div>
    </div>
  </section>
</div>
</form>