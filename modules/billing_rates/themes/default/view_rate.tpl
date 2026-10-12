<form method="POST" action="?menu={$module_name}">
<div class="iss-form">
  <div class="iss-form__toolbar">
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="edit" value="{$EDIT}">
      {if $name neq 'Default'}
      <input class="button" type="submit" name="delete" value="{$DELETE}"  onClick="return confirmSubmit('{$CONFIRM_CONTINUE}')">
      {/if}
      <input class="button" type="submit" name="cancel" value="{$CANCEL}">
    </div>
  </div>

  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$Prefix.LABEL}</span>
        <span class="iss-field__control">{$prefix}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate.LABEL} {$by_min}</span>
        <span class="iss-field__control"><a href="index.php?menu=currency" style="text-decoration:none;">{$currency}</a>&nbsp;{$rate}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Creation_Date.LABEL}</span>
        <span class="iss-field__control">{$creation_date}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Name.LABEL}</span>
        <span class="iss-field__control">{$name}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate_offset.LABEL}</span>
        <span class="iss-field__control"><a href="index.php?menu=currency" style="text-decoration:none;">{$currency}</a>&nbsp;{$rate_offset}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Trunk.LABEL}</span>
        <span class="iss-field__control">{$trunk}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Hidden_Digits.LABEL}</span>
        <span class="iss-field__control">{$hidden_digits}</span>
      </div>
    </div>
  </section>
</div>

<input type="hidden" name="id_rate" value="{$id_rate}">
</form>