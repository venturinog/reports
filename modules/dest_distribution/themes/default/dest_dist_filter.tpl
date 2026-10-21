<form method="POST" action="?menu={$menu}">
<div class="iss-form">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-filter"></i> {$FILTER_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$date_start.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$date_start.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_end.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$date_end.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$criteria.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$criteria.INPUT}</span>
      </div>
    </div>
    <div class="iss-form__toolbar">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="filter" value="{$Filter}">
      </div>
    </div>
  </section>
</div>
</form>
