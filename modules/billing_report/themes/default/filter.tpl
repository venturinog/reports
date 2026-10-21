<div class="iss-form">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-filter"></i> {$FILTER_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$date_start.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$date_start.INPUT}</span>
        {if $ERRORS.date_start}<div class="invalid-feedback d-block">{$ERRORS.date_start}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_end.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$date_end.INPUT}</span>
        {if $ERRORS.date_end}<div class="invalid-feedback d-block">{$ERRORS.date_end}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$filter_field.LABEL}</span>
        <span class="iss-field__control">{$filter_field.INPUT}</span>
        {if $ERRORS.filter_field}<div class="invalid-feedback d-block">{$ERRORS.filter_field}</div>{/if}
      </div>
      <div class="iss-field{$value_class}" id="billing_filter_value">
        <span class="iss-field__label">{$filter_value.LABEL}</span>
        <span class="iss-field__control">{$filter_value.INPUT}</span>
        {if $ERRORS.filter_value}<div class="invalid-feedback d-block">{$ERRORS.filter_value}</div>{/if}
      </div>
      <div class="iss-field iss-field--full{$duration_class}" id="billing_filter_duration">
        <span class="iss-field__label">{$filter_value.LABEL}</span>
        <span class="iss-field__control iss-inline-field">
          <span class="iss-inline-field">{$horas.INPUT}&nbsp;{$UNIT_HOURS}</span>
          <span class="iss-inline-field">{$minutos.INPUT}&nbsp;{$UNIT_MINUTES}</span>
          <span class="iss-inline-field">{$segundos.INPUT}&nbsp;{$UNIT_SECONDS}</span>
        </span>
        {if $ERRORS.horas}<div class="invalid-feedback d-block">{$ERRORS.horas}</div>{/if}
        {if $ERRORS.minutos}<div class="invalid-feedback d-block">{$ERRORS.minutos}</div>{/if}
        {if $ERRORS.segundos}<div class="invalid-feedback d-block">{$ERRORS.segundos}</div>{/if}
      </div>
    </div>
    <div class="iss-form__toolbar">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="show" value="{$SHOW}">
      </div>
    </div>
  </section>
</div>
{literal}
<script>
/* Validacion en vivo del filtro. El servidor sigue siendo la fuente de
 * verdad: esto solo da la respuesta inmediata. */
(function () {
    'use strict';

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

    function esNumero(valor) {
        return /^\d{1,2}$/.test((valor || '').trim());
    }

    function marcar(el, ok) {
        if (!el) return;
        el.classList.remove('is-valid', 'is-invalid');
        el.classList.add(ok ? 'is-valid' : 'is-invalid');
    }

    var campos = [
        { el: document.getElementById('date_start'), validar: esFecha },
        { el: document.getElementById('date_end'), validar: esFecha },
        { el: document.getElementById('horas'), validar: esNumero },
        { el: document.getElementById('minutos'), validar: esNumero },
        { el: document.getElementById('segundos'), validar: esNumero }
    ];

    function comprobar(tocados) {
        var ok = true;
        campos.forEach(function (campo) {
            if (!campo.el) return;
            var valor = campo.el.value.trim();
            var bueno = valor === '' || campo.validar(valor);
            if (tocados || valor !== '') marcar(campo.el, bueno);
            if (!bueno) ok = false;
        });
        return ok;
    }

    campos.forEach(function (campo) {
        if (!campo.el) return;
        campo.el.addEventListener('input', function () { comprobar(true); });
        campo.el.addEventListener('blur', function () { comprobar(true); });
    });

    var boton = document.querySelector('input[name=show]');
    if (boton && boton.form) {
        boton.form.addEventListener('submit', function (e) {
            if (e.submitter && e.submitter.name === 'cancel') return;
            if (!comprobar(true)) { e.preventDefault(); return false; }
        });
    }

    comprobar(false);
})();
</script>
{/literal}
