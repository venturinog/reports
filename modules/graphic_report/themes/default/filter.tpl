<div class="iss-form">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-filter"></i> {$FILTER_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$date_from.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$date_from.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_to.LABEL}</span>
        <span class="iss-field__control">{$date_to.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$classify_by.LABEL}</span>
        <span class="iss-field__control">{$classify_by.INPUT}</span>
      </div>
      <div class="iss-field{$class_number}" id="graphic_field_number">
        <span class="iss-field__label">{$call_to.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">
          {$call_to.INPUT}
          <a class="btn btn-sm btn-outline-secondary" href='javascript: popup_phone_number("?menu=calendar&action=phone_numbers&rawmode=yes");'>{$HERE}</a>
        </span>
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
<input type="hidden" name="nav" value="{$nav_value}" />
<input type="hidden" name="start" value="{$start_value}" />
<input type="hidden" name="date_1" value="{$date_1}" />
<input type="hidden" name="date_2" value="{$date_2}" />

<!--// solo para que pase el error llamado del popup -->
<input type="hidden" name="phone_type" id="phone_type"  value="" />
<input type="hidden" name="phone_id" id="phone_id" value="" />

{literal}
<script type="text/javascript">
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
