/*
 * Grafica de uso de canales: Chart.js del tema (STYLE.md §10).
 *
 * La libreria y el wrapper de color los carga la plantilla; este fichero
 * solo lee los datos y dibuja.
 */
(function () {
    'use strict';

    function readData() {
        var el = document.getElementById('issabelChannelUsage');
        if (!el) return null;
        try {
            return JSON.parse(el.textContent);
        } catch (e) {
            return null;
        }
    }

    function buildChart(data) {
        var canvas = document.getElementById('myChart');
        if (!canvas || typeof window.Chart === 'undefined') return;

        var palette = (window.IssabelCharts && window.IssabelCharts.palette)
            ? window.IssabelCharts.palette(Object.keys(data.series).length)
            : [];

        var datasets = [];
        var i = 0;
        Object.keys(data.series).forEach(function (key) {
            var serie = data.series[key];
            var color = palette.length ? palette[i % palette.length] : undefined;
            datasets.push({
                label: serie.label,
                data: serie.data,
                borderColor: color,
                backgroundColor: color,
                fill: false
            });
            i++;
        });

        window.channelUsageChart = new window.Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: data.hours,
                datasets: datasets
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        type: 'time',
                        time: {
                            timezone: data.timezone,
                            unit: 'minute',
                            tooltipFormat: 'lll'
                        }
                    },
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    $(document).ready(function () {
        var data = readData();
        if (data) buildChart(data);
    });

    /* La exportacion a PDF la hace el propio navegador: el tema imprime la
     * pagina y la grafica sale con el resto. */
    window.printChart = function () {
        window.print();
    };
})();
