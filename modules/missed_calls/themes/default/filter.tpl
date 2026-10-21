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
      <div class="iss-field">
        <span class="iss-field__label">{$filter_value.LABEL}</span>
        <span class="iss-field__control">{$filter_value.INPUT}</span>
        {if $ERRORS.filter_value}<div class="invalid-feedback d-block">{$ERRORS.filter_value}</div>{/if}
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

    var PATRON_FECHA = /^(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})\s+(\d{1,2}):(\d{2})$/;

    function esFechaConHora(valor) {
        var m = PATRON_FECHA.exec((valor || '').trim());
        if (!m) return false;
        var dia = parseInt(m[1], 10);
        var mes = m[2].toLowerCase();
        var anio = parseInt(m[3], 10);
        var hora = parseInt(m[4], 10);
        var minuto = parseInt(m[5], 10);
        var meses = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
        if (meses.indexOf(mes) === -1) return false;
        if (dia < 1 || dia > 31) return false;
        if (anio < 1970 || anio > 2999) return false;
        if (hora > 23 || minuto > 59) return false;
        return true;
    }

    function marcar(el, ok) {
        if (!el) return;
        el.classList.remove('is-valid', 'is-invalid');
        el.classList.add(ok ? 'is-valid' : 'is-invalid');
    }

    var campos = [
        { el: document.getElementById('date_start'), validar: esFechaConHora },
        { el: document.getElementById('date_end'), validar: esFechaConHora }
    ];

    function comprobar(tocados) {
        var ok = true;
        campos.forEach(function (campo) {
            if (!campo.el) return;
            var valor = campo.el.value.trim();
            var bueno = valor !== '' && campo.validar(valor);
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
