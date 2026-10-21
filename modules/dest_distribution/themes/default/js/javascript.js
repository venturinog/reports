/*
 * Distribucion de destinos: grafica de torta con Chart.js del tema.
 *
 * La libreria y el wrapper de color se cargan desde la plantilla (solo en la
 * vista que tiene grafica); este fichero solo dibuja.
 */
(function () {
    'use strict';

    function readData() {
        var el = document.getElementById('issabelDestDistributionChart');
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
            ? window.IssabelCharts.palette(data.labels.length)
            : [];

        window.destDistributionChart = new window.Chart(canvas.getContext('2d'), {
            type: 'pie',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.values,
                    backgroundColor: palette,
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'right' },
                    title: { display: true, text: data.title }
                }
            }
        });
    }

    $(document).ready(function () {
        var data = readData();
        if (data) buildChart(data);
    });
})();
