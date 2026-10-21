<div class="iss-form">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-filter"></i> {$FILTER_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$filter.LABEL}</span>
        <span class="iss-field__control">{$filter.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$busqueda.LABEL}</span>
        <span class="iss-field__control">{$busqueda.INPUT}</span>
      </div>
    </div>
    <div class="iss-form__toolbar">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="show" value="{$SHOW}">
        <input class="button" type="submit" name="searchnext" value="{$SEARCHNEXT}">
      </div>
    </div>
  </section>
</div>
{$ultima_busqueda.INPUT}
{$ultimo_offset.INPUT}
{$offset.INPUT}
