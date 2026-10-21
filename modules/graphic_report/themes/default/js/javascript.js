/*
 * Graficas del reporte grafico: Chart.js del tema (STYLE.md §10).
 *
 * Tres graficas segun el criterio elegido: extension (torta), cola (barras) y
 * troncal (dos tortas). La libreria, el plugin de etiquetas y el wrapper de
 * color los carga la plantilla.
 */
(function () {
    'use strict';

    function readData() {
        var el = document.getElementById('issabelGraphicReport');
        if (!el) return null;
        try {
            return JSON.parse(el.textContent);
        } catch (e) {
            return null;
        }
    }

    function palette(count) {
        return (window.IssabelCharts && window.IssabelCharts.palette)
            ? window.IssabelCharts.palette(count)
            : [];
    }

    /* Etiqueta de datos: el valor y su porcentaje sobre el total. */
    function percentFormatter(value, context) {
        var sum = context.dataset.data.reduce(function (a, b) {
            return Number(a) + Number(b);
        }, 0);
        if (!sum) return String(value);
        return value + '\n (' + (value / sum * 100).toFixed(2) + '%)';
    }

    /* Las horas se muestran como hh:mm:ss en las graficas de la troncal. */
    function formatMinutes(value) {
        var hours = Math.floor(value / 3600);
        var minutes = Math.floor((value % 3600) / 60);
        var seconds = value % 60;
        function two(n) { return (n < 10 ? '0' : '') + n; }
        return two(hours) + ':' + two(minutes) + ':' + two(seconds);
    }

    function baseOptions(title, legend, datalabels) {
        var options = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: legend !== false, position: 'right' },
                title: { display: true, text: title }
            }
        };
        if (datalabels) options.plugins.datalabels = datalabels;
        return options;
    }

    function datalabelOptions(formatter) {
        return {
            formatter: formatter,
            anchor: 'end',
            align: 'start',
            clamp: true
        };
    }

    function showNoData(canvasId, message) {
        var canvas = document.getElementById(canvasId);
        if (!canvas) return;
        var note = document.createElement('p');
        note.className = 'text-center';
        note.textContent = message;
        canvas.parentNode.appendChild(note);
    }

    function buildChart(data) {
        if (typeof window.Chart === 'undefined') return;

        var canvas = document.getElementById('myChart');
        var canvas2 = document.getElementById('myChart2');
        if (!canvas) return;

        if (data.noData) {
            showNoData('myChart', data.noData);
            return;
        }

        if (data.type === 'queue') {
            window.graphicReportChart = new window.Chart(canvas.getContext('2d'), {
                type: 'bar',
                data: {
                    labels: data.labels,
                    datasets: [{
                        data: data.values,
                        backgroundColor: palette(1),
                        borderWidth: 0
                    }]
                },
                options: baseOptions(data.title, false)
            });
            return;
        }

        if (data.type === 'trunk') {
            var colors = palette(2);
            window.graphicReportChart = new window.Chart(canvas.getContext('2d'), {
                plugins: window.ChartDataLabels ? [window.ChartDataLabels] : [],
                type: 'pie',
                data: {
                    labels: data.labels,
                    datasets: [{
                        data: data.values,
                        backgroundColor: colors,
                        borderWidth: 0
                    }]
                },
                options: baseOptions(data.title, true, datalabelOptions(percentFormatter))
            });
            if (canvas2) {
                window.graphicReportChart2 = new window.Chart(canvas2.getContext('2d'), {
                    plugins: window.ChartDataLabels ? [window.ChartDataLabels] : [],
                    type: 'pie',
                    data: {
                        labels: data.labels,
                        datasets: [{
                            data: data.values2,
                            backgroundColor: colors,
                            borderWidth: 0
                        }]
                    },
                    options: baseOptions(data.title2, true, datalabelOptions(percentFormatter))
                });
            }
            return;
        }

        // extension
        var colors2 = palette(2);
        window.graphicReportChart = new window.Chart(canvas.getContext('2d'), {
            plugins: window.ChartDataLabels ? [window.ChartDataLabels] : [],
            type: 'pie',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.values,
                    backgroundColor: colors2,
                    borderWidth: 0
                }]
            },
            options: baseOptions(data.title, true, datalabelOptions(percentFormatter))
        });
    }

    $(document).ready(function () {
        var data = readData();
        if (data) buildChart(data);
    });

    /* La exportacion a PDF la hace el propio navegador: el tema imprime la
     * pagina y las graficas salen con el resto. */
    window.printGraphic = function () {
        window.print();
    };
})();
