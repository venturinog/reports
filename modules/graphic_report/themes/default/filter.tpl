<div class="iss-form">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-filter"></i> {$FILTER_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$date_from.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$date_from.INPUT}</span>
        {if $ERRORS.date_from}<div class="invalid-feedback d-block">{$ERRORS.date_from}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_to.LABEL}</span>
        <span class="iss-field__control">{$date_to.INPUT}</span>
        {if $ERRORS.date_to}<div class="invalid-feedback d-block">{$ERRORS.date_to}</div>{/if}
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$classify_by.LABEL}</span>
        <span class="iss-field__control">{$classify_by.INPUT}</span>
        {if $ERRORS.classify_by}<div class="invalid-feedback d-block">{$ERRORS.classify_by}</div>{/if}
      </div>
      <div class="iss-field{$class_number}" id="graphic_field_number">
        <span class="iss-field__label">{$call_to.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">
          {$call_to.INPUT}
          <a class="btn btn-sm btn-outline-secondary" href='javascript: popup_phone_number("?menu=calendar&action=phone_numbers&rawmode=yes");'>{$HERE}</a>
        </span>
        {if $ERRORS.call_to}<div class="invalid-feedback d-block">{$ERRORS.call_to}</div>{/if}
      </div>
      <div class="iss-field{$class_trunk}" id="graphic_field_trunk">
        <span class="iss-field__label">{$trunks.LABEL}</span>
        <span class="iss-field__control">{$trunks.INPUT}</span>
      </div>
    </div>
    <div class="iss-form__toolbar">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="show" value="{$SHOW}">
      </div>
    </div>
  </section>
</div>
<!--// solo para que pase el error llamado del popup -->
<input type="hidden" name="phone_type" id="phone_type"  value="" />
<input type="hidden" name="phone_id" id="phone_id" value="" />

{literal}
<script type="text/javascript">
    /* Validacion en vivo del filtro. El servidor sigue siendo la fuente de
     * verdad: esto solo da la respuesta inmediata. */
    (function () {
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

        var campos = [
            { el: document.getElementById('date_from'), validar: esFecha },
            { el: document.getElementById('date_to'), validar: esFecha }
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

    function popup_phone_number(url_popup)
    {
        var ancho = 600;
        var alto = 400;
        var winiz = (screen.width-ancho)/2;
        var winal = (screen.height-alto)/2;
        my_window = window.open(url_popup,"my_window","width="+ancho+",height="+alto+",top="+winal+",left="+winiz+",location=yes,status=yes,resizable=yes,scrollbars=yes,fullscreen=no,toolbar=yes");
        my_window.document.close();
    }

    /* Segun el criterio elegido se muestra el campo de la extension o el de
     * la troncal. Que campo se ve lo decide el servidor al pintar el
     * formulario; aqui solo se alterna al cambiar el criterio. */
    function show_elements()
    {
        var criterio = document.getElementById('classify_by');
        if (!criterio) return;

        var esNumero = criterio.value === 'Number';
        var esTroncal = criterio.value === 'Trunk';

        document.getElementById('graphic_field_number').classList.toggle('neo-display-none', !esNumero);
        document.getElementById('graphic_field_trunk').classList.toggle('neo-display-none', !esTroncal);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', show_elements);
    } else {
        show_elements();
    }
</script>
{/literal}
