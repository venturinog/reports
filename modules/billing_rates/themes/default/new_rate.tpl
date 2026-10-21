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
        {if $ERRORS.Prefix}<div class="invalid-feedback d-block">{$ERRORS.Prefix}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate.LABEL} {$by_min}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control"><a href="index.php?menu=currency">{$currency}</a>&nbsp;{$Rate.INPUT}</span>
        {if $ERRORS.Rate}<div class="invalid-feedback d-block">{$ERRORS.Rate}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Hidden_Digits.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Hidden_Digits.INPUT}</span>
        {if $ERRORS.Hidden_Digits}<div class="invalid-feedback d-block">{$ERRORS.Hidden_Digits}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Name.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Name.INPUT}</span>
        {if $ERRORS.Name}<div class="invalid-feedback d-block">{$ERRORS.Name}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate_offset.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control"><a href="index.php?menu=currency">{$currency}</a>&nbsp;{$Rate_offset.INPUT}</span>
        {if $ERRORS.Rate_offset}<div class="invalid-feedback d-block">{$ERRORS.Rate_offset}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Trunk.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$Trunk.INPUT}</span>
        {if $ERRORS.Trunk}<div class="invalid-feedback d-block">{$ERRORS.Trunk}</div>{/if}
      </div>
    </div>
  </section>
  </div>
</div>
{literal}
<script>
/* Validacion en vivo del formulario de tarifa. El servidor sigue siendo la
 * fuente de verdad: esto solo da la respuesta inmediata. */
(function () {
    'use strict';

    var NUMERICOS = ['Rate', 'Rate_offset', 'Hidden_Digits'];

    function marcar(el, ok) {
        if (!el) return;
        el.classList.remove('is-valid', 'is-invalid');
        el.classList.add(ok ? 'is-valid' : 'is-invalid');
    }

    function camposNumericos() {
        return NUMERICOS.map(function (nombre) {
            return { el: document.getElementById(nombre), numerico: true };
        }).concat([
            { el: document.getElementById('Prefix'), numerico: false },
            { el: document.getElementById('Name'), numerico: false },
            { el: document.getElementById('Trunk'), numerico: false }
        ]);
    }

    function comprobar(tocados) {
        var ok = true;
        camposNumericos().forEach(function (campo) {
            if (!campo.el) return;
            var valor = campo.el.value.trim();
            var bueno;
            if (valor === '') {
                bueno = false;
            } else if (campo.numerico) {
                bueno = !isNaN(parseFloat(valor)) && isFinite(valor);
            } else {
                bueno = true;
            }
            if (tocados || valor !== '') marcar(campo.el, bueno);
            if (!bueno) ok = false;
        });
        return ok;
    }

    var campos = camposNumericos();
    campos.forEach(function (campo) {
        if (!campo.el) return;
        campo.el.addEventListener('input', function () { comprobar(true); });
        campo.el.addEventListener('blur', function () { comprobar(true); });
    });

    var boton = document.querySelector('input[name=submit_save_rate], input[name=submit_apply_changes]');
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
</form>