<form method="POST" action="?menu={$module_name}" enctype="multipart/form-data">
<div class="iss-form">
  <div class="iss-form__toolbar">
    <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="submit_import_changes" value="{$SAVE}" >
      <input class="button" type="submit" name="cancel" value="{$CANCEL}">
    </div>
  </div>

  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$importcsv.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$importcsv.INPUT}&nbsp;&nbsp;<a class='tooltip' title='{$alert_import}'><img src='modules/{$module_name}/images/img_info.png' width='15' height='15' alt='info' longdesc='Descripcion de Nombre' /></a></span>
      </div>
    </div>
  </section>
</div>
</form>