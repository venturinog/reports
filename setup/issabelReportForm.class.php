<?php
/**
 * issabelReportForm.class.php — utilidades compartidas por las paginas de los
 * modulos de reportes (Issabel 6).
 *
 * Los modulos de reportes validan sus filtros y sus formularios con el mismo
 * patron (STYLE.md §5): el servidor devuelve un arreglo de errores por campo,
 * la pagina se vuelve a pintar sin redirigir y el campo que falla se marca
 * con la clase is-invalid conservando la que ya tenia.
 *
 * Licencia: GPLv2+
 */

/**
 * Anade la clase is-invalid a los campos con error.
 *
 * Los textos llevan form-control y las listas form-select: la clase se anade
 * a la que ya traia el campo, no se sustituye, porque si no el recuadro rojo
 * no lo pinta el tema.
 *
 * @param array $arrForm  definicion del formulario, por referencia
 * @param array $errors   errores por campo
 * @return void
 */
function issabelReportMarkInvalid(&$arrForm, $errors)
{
    if (!is_array($errors) || count($errors) == 0) return;
    foreach ($errors as $field => $message) {
        if (!isset($arrForm[$field]) || !is_array($arrForm[$field])) continue;
        $tipo = isset($arrForm[$field]['INPUT_TYPE']) ? strtoupper($arrForm[$field]['INPUT_TYPE']) : '';
        if ($tipo === 'SELECT') {
            $cls = (isset($arrForm[$field]['CLASS']) && $arrForm[$field]['CLASS'] !== '')
                ? $arrForm[$field]['CLASS'].' ' : '';
            $arrForm[$field]['CLASS'] = $cls.'is-invalid';
        } else {
            if (!isset($arrForm[$field]['INPUT_EXTRA_PARAM']) ||
                !is_array($arrForm[$field]['INPUT_EXTRA_PARAM'])) {
                $arrForm[$field]['INPUT_EXTRA_PARAM'] = array();
            }
            $params = $arrForm[$field]['INPUT_EXTRA_PARAM'];
            $cls = (isset($params['class']) && $params['class'] !== '')
                ? $params['class'].' ' : 'form-control ';
            $params['class'] = $cls.'is-invalid';
            $arrForm[$field]['INPUT_EXTRA_PARAM'] = $params;
        }
    }
}

/**
 * Prepara los errores para la plantilla: todas las claves del formulario,
 * con su mensaje o vacias. Asi la plantilla puede preguntar por cada campo
 * sin comprobar antes que exista.
 *
 * @param array $arrForm  definicion del formulario
 * @param array $errors   errores por campo
 * @return array
 */
function issabelReportErrorMap($arrForm, $errors)
{
    $map = array();
    if (is_array($arrForm)) {
        foreach (array_keys($arrForm) as $field) $map[$field] = '';
    }
    if (is_array($errors)) {
        foreach ($errors as $field => $message) $map[$field] = $message;
    }
    return $map;
}

/**
 * Mensaje de error de un campo, con el texto que ya esta traducido.
 *
 * @param string $label    etiqueta del campo, ya traducida
 * @param bool   $required true si el campo es obligatorio
 * @param bool   $valid    false si el valor no cumple la regla
 * @return string
 */
function issabelReportError($label, $required = false, $valid = true)
{
    if ($required) return sprintf(_tr('%s is required'), $label);
    if (!$valid) return sprintf(_tr('%s is invalid'), $label);
    return '';
}

/**
 * Valida una fecha con el formato "d M Y", por ejemplo "21 Oct 2026".
 *
 * @param string $value
 * @return bool
 */
function issabelReportValidDate($value)
{
    return preg_match('/^[[:digit:]]{1,2}[[:space:]]+[[:alnum:]]{3}[[:space:]]+[[:digit:]]{4}$/', (string)$value) === 1;
}

/**
 * Valida una fecha con hora, con el formato "d M Y H:i", por ejemplo
 * "21 Oct 2026 09:45".
 *
 * @param string $value
 * @return bool
 */
function issabelReportValidDateTime($value)
{
    return preg_match('/^[[:digit:]]{1,2}[[:space:]]+[[:alnum:]]{3}[[:space:]]+[[:digit:]]{4}[[:space:]]+[[:digit:]]{1,2}:[[:digit:]]{1,2}$/', (string)$value) === 1;
}
