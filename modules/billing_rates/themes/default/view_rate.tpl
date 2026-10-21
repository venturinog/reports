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
    <div class="iss-card__body iss-formgrid iss-formgrid--3col iss-formgrid--readonly">
      <div class="iss-field">
        <span class="iss-field__label">{$Prefix.LABEL}</span>
        <span class="iss-field__control iss-field__value{if $prefix eq ''} iss-field__value--empty{/if}">{if $prefix eq ''}&mdash;{else}{$prefix|escape}{/if}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate.LABEL} {$by_min}</span>
        <span class="iss-field__control iss-field__value">{if $rate eq ''}&mdash;{else}{$currency} {$rate|escape}{/if}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Creation_Date.LABEL}</span>
        <span class="iss-field__control iss-field__value{if $creation_date eq ''} iss-field__value--empty{/if}">{if $creation_date eq ''}&mdash;{else}{$creation_date|escape}{/if}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Name.LABEL}</span>
        <span class="iss-field__control iss-field__value{if $name eq ''} iss-field__value--empty{/if}">{if $name eq ''}&mdash;{else}{$name|escape}{/if}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Rate_offset.LABEL}</span>
        <span class="iss-field__control iss-field__value">{if $rate_offset eq ''}&mdash;{else}{$currency} {$rate_offset|escape}{/if}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Trunk.LABEL}</span>
        <span class="iss-field__control iss-field__value{if $trunk eq ''} iss-field__value--empty{/if}">{if $trunk eq ''}&mdash;{else}{$trunk|escape}{/if}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$Hidden_Digits.LABEL}</span>
        <span class="iss-field__control iss-field__value{if $hidden_digits eq ''} iss-field__value--empty{/if}">{if $hidden_digits eq ''}&mdash;{else}{$hidden_digits|escape}{/if}</span>
      </div>
    </div>
  </section>
</div>

<input type="hidden" name="id" value="{$rate_id}">
</form>
