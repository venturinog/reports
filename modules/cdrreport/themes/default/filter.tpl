
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
        {if $ERRORS.date_start}<div class="invalid-feedback d-block">{$ERRORS.date_start}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$field_pattern.LABEL}</span>
        <span class="iss-field__control">
          <span class="iss-inline-field">{$field_name.INPUT}{$field_pattern.INPUT}</span>
        </span>
        {if $ERRORS.field_name}<div class="invalid-feedback d-block">{$ERRORS.field_name}</div>{/if}
        {if $ERRORS.field_pattern}<div class="invalid-feedback d-block">{$ERRORS.field_pattern}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_end.LABEL}</span>
        <span class="iss-field__control">{$date_end.INPUT}</span>
        {if $ERRORS.date_end}<div class="invalid-feedback d-block">{$ERRORS.date_end}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$status.LABEL}</span>
        <span class="iss-field__control">{$status.INPUT}</span>
        {if $ERRORS.status}<div class="invalid-feedback d-block">{$ERRORS.status}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$limit.LABEL}</span>
        <span class="iss-field__control">{$limit.INPUT}</span>
        {if $ERRORS.limit}<div class="invalid-feedback d-block">{$ERRORS.limit}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$ringgroup.LABEL}</span>
        <span class="iss-field__control">{$ringgroup.INPUT}</span>
        {if $ERRORS.ringgroup}<div class="invalid-feedback d-block">{$ERRORS.ringgroup}</div>{/if}
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
    var PATRON_FECHA = /^(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})$/;

    function esFecha(valor) {
        var m = PATRON_FECHA.exec((valor || '').trim());
        if (!m) return false;
        var meses = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
        if (meses.indexOf(m[2].toLowerCase()) === -1) return false;
        var dia = parseInt(m[1], 10);
        var anio = parseInt(m[3], 10);
        return dia >= 1 && dia <= 31 && anio >= 1970 && anio <= 2999;
    }

    function marcar(el, ok) {
        if (!el) return;
        el.classList.remove('is-valid', 'is-invalid');
        el.classList.add(ok ? 'is-valid' : 'is-invalid');
    }

    var fechas = [document.getElementById('date_start'), document.getElementById('date_end')];

    function comprobarFechas(tocados) {
        var ok = true;
        fechas.forEach(function (el) {
            if (!el) return;
            var valor = el.value.trim();
            var bueno = valor !== '' && esFecha(valor);
            if (tocados || valor !== '') marcar(el, bueno);
            if (!bueno) ok = false;
        });
        return ok;
    }

    fechas.forEach(function (el) {
        if (!el) return;
        el.addEventListener('input', function () { comprobarFechas(true); });
        el.addEventListener('blur', function () { comprobarFechas(true); });
    });

    var botonFiltro = document.querySelector('input[name=filter]');
    if (botonFiltro && botonFiltro.form) {
        botonFiltro.form.addEventListener('submit', function (e) {
            if (e.submitter && e.submitter.name === 'cancel') return;
            if (!comprobarFechas(true)) { e.preventDefault(); return false; }
        });
    }

    comprobarFechas(false);

    var botonToggle = $('#cdr_filter_toggle');
    var fila = $('#filters');
    if (botonToggle.length === 0) return;

    botonToggle.on('click', function (e) {
        e.preventDefault();
        var oculto = fila.hasClass('neo-display-none');
        fila.toggleClass('neo-display-none', !oculto);
        botonToggle.attr('aria-expanded', oculto ? 'true' : 'false');
        botonToggle.find('i.ti-chevron-down').toggleClass('ti-chevron-down ti-chevron-up', oculto);
    });
});
</script>
{/literal}
