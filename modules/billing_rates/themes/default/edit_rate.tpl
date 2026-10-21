<form method="POST" action="?menu={$module_name}">
<div class="iss-form">
  <div class="iss-form__toolbar">
    <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="submit_apply_changes" value="{$APPLY_CHANGES}" >
      <input class="button" type="submit" name="cancel" value="{$CANCEL}" >
    </div>
  </div>

  <div class="iss-reveal">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-currency-dollar"></i> {$CARD_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field iss-field--full">
        <span class="iss-field__control"><span class="iss-sev-warning">{$checkUpdate.LABEL}</span>&nbsp;{$checkUpdate.INPUT}&nbsp;&nbsp;&nbsp;&nbsp;<span class="iss-field__help">{$text_info}</span></span>
      </div>
      {if $name eq 'Default'}
      <div class="iss-field">
        <span class="iss-field__label">{$Prefix.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">*</span>
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
        <span class="iss-field__control">{$name}</span>
        {if $ERRORS.Name}<div class="invalid-feedback d-block">{$ERRORS.Name}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate_offset.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control"><a href="index.php?menu=currency">{$currency}</a>&nbsp;{$Rate_offset.INPUT}</span>
        {if $ERRORS.Rate_offset}<div class="invalid-feedback d-block">{$ERRORS.Rate_offset}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Trunk.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">*</span>
        {if $ERRORS.Trunk}<div class="invalid-feedback d-block">{$ERRORS.Trunk}</div>{/if}
      </div>
      {else}
      <div class="iss-field">
        <span class="iss-field__label">{$Prefix.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$prefix}</span>
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
      {/if}
    </div>
  </section>
  </div>

  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-history"></i> {$History}</header>
    <div class="iss-card__body">
      <table class="table table-hover align-middle iss-table" width="100%">
          <thead>
          <tr>
              <th align="center">{$Name.LABEL}</th>
              <th align="center">{$Prefix.LABEL}</th>
              <th align="center">{$Rate.LABEL} {$by_min}</th>
              <th align="center">{$Rate_offset.LABEL}</th>
              <th align="center">{$Creation_Date}</th>
              <th align="center">{$Date_close}</th>
              <th align="center">{$Trunk.LABEL}</th>
              <th align="center">{$Hidden_Digits.LABEL}</th>
              <th align="center">{$Status}</th>
          </tr>
          </thead>
          <tbody>
          {foreach from=$arrRates key=id item=rate name=rates}
              <tr>
              {if $smarty.foreach.rates.first}
                  {foreach from=$rate key=id2 item=rate2 name=rates2}
                  {if $id2 neq 'id'}
                      {if $id2 eq 'estado'}
                          {if $rate2 eq 'activo'}
                          <td align="center" class="iss-sev-ok">{$Current}</td>
                          {else}
                          <td align="center" class="iss-sev-unknown">{$Obsolete}</td>
                          {/if}
                      {else}
                          <td align="center">{$rate2}</td>
                      {/if}
                  {/if}
                  {/foreach}
              {else}
                  {foreach from=$rate key=id2 item=rate2 name=rates2}
                  {if $id2 neq 'id'}
                      {if $id2 eq 'estado'}
                          {if $rate2 eq 'activo'}
                          <td align="center" class="iss-sev-ok">{$Current}</td>
                          {else}
                          <td align="center" class="iss-sev-unknown">{$Obsolete}</td>
                          {/if}
                      {else}
                          <td align="center">{$rate2}</td>
                      {/if}
                  {/if}
                  {/foreach}
              {/if}
              </tr>
          {/foreach}
          </tbody>
      </table>
    </div>
  </section>
</div>

<input type="hidden" name="id" value="{$rate_id}">
<input type="hidden" name="namerate" value="{$namerate}">
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