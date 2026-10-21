<form method="POST" action="?menu={$module_name}">
<div class="iss-form">
  <div class="iss-form__toolbar">
    <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="submit_save_rate" value="{$SAVE}" >
      <input class="button" type="submit" name="cancel" value="{$CANCEL}">
    </div>
  </div>

  <div class="iss-reveal">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-currency-dollar"></i> {$CARD_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$Prefix.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Prefix.INPUT}</span>
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
    </div>
  </section>
  </div>
</div>
</form>