/*
 * Filtro del reporte de facturacion: el criterio decide si se busca por un
 * valor de texto o por una duracion (horas, minutos y segundos).
 *
 * El cambio de criterio lo aplica el servidor cuando se envia el formulario;
 * aqui solo se alterna lo que se ve, sin decidir nada.
 */
$(document).ready(function () {
    var campo = $('#filter_field');
    if (campo.length === 0) return;

    function alternar() {
        var esDuracion = campo.val() === 'duration';
        $('#billing_filter_value').toggleClass('neo-display-none', esDuracion);
        $('#billing_filter_duration').toggleClass('neo-display-none', !esDuracion);
    }

    campo.on('change', alternar);
    alternar();
});
