<div class="iss-form">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-filter"></i> {$FILTER_TITLE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$date_from.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$date_from.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_to.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$date_to.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$option_fil.LABEL}</span>
        <span class="iss-field__control">{$option_fil.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$value_fil.LABEL}</span>
        <span class="iss-field__control">{$value_fil.INPUT}</span>
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
<script type="text/javascript">
function popup_ventana(url_popup)
{
    var ancho = 750;
    var alto = 580;
    var winiz = (screen.width-ancho)/2;
    var winal = (screen.height-alto)/2;
    my_window = window.open(url_popup,"my_window","width="+ancho+",height="+alto+",top="+winal+",left="+winiz+",location=yes,status=yes,resizable=yes,scrollbars=yes,fullscreen=no,toolbar=yes");
    my_window.document.close();
}
</script>
{/literal}
