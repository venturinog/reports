
<a class="btn btn-primary" id="cdr_filter_toggle" href="#filters" role="button" aria-expanded="false" aria-controls="filters">
<i class="ti ti-filter"></i> {$FILTER_SHOW}
<i class="ti ti-chevron-down"></i>
</a>

<div class="neo-display-none" id="filters">
<form id=formFilter method="POST" action="">
<div class="iss-form" style="margin-bottom:1.25rem;">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-filter"></i> {$FILTER_SHOW}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$date_start.LABEL}</span>
        <span class="iss-field__control">{$date_start.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$field_pattern.LABEL}</span>
        <span class="iss-field__control">
          <span class="iss-inline-field">{$field_name.INPUT}{$field_pattern.INPUT}</span>
        </span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_end.LABEL}</span>
        <span class="iss-field__control">{$date_end.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$status.LABEL}</span>
        <span class="iss-field__control">{$status.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$limit.LABEL}</span>
        <span class="iss-field__control">{$limit.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$ringgroup.LABEL}</span>
        <span class="iss-field__control">{$ringgroup.INPUT}</span>
      </div>
      <div class="iss-field iss-field--full">
        <span class="iss-field__control">
          <span class="iss-inline-field">{$timeInSecs.LABEL}&nbsp;{$timeInSecs.INPUT}</span>
        </span>
      </div>
    </div>
    <div class="iss-form__toolbar" style="border-top:1px solid var(--iss-border); margin:0; padding:12px 18px; border-bottom:0;">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="filter" value="{$Filter}" />
      </div>
    </div>
  </section>
</div>
</form>
</div>
{literal}
<script>
/* El tema Modern no trae el JavaScript de Bootstrap, asi que el desplegable
 * del filtro se abre y se cierra a mano. */
$(document).ready(function () {
    var boton = $('#cdr_filter_toggle');
    var fila = $('#filters');
    if (boton.length === 0) return;

    boton.on('click', function (e) {
        e.preventDefault();
        var oculto = fila.hasClass('neo-display-none');
        fila.toggleClass('neo-display-none', !oculto);
        boton.attr('aria-expanded', oculto ? 'true' : 'false');
        boton.find('i.ti-chevron-down').toggleClass('ti-chevron-down ti-chevron-up', oculto);
    });
});
</script>
{/literal}
