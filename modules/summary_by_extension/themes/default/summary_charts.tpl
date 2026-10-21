<!DOCTYPE html>
<html lang="{$LANG|default:'en'}" data-bs-theme="light">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{$CHART_TITLE}</title>
<link rel="stylesheet" href="{$WEBPATH}themes/{$THEMENAME}/css/tabler.min.css">
<link rel="stylesheet" href="{$WEBPATH}themes/{$THEMENAME}/css/modern.css">
<script>
(function () {
    try {
        var mode = localStorage.getItem('issabel-theme') || 'auto';
        var dark = mode === 'auto'
            ? window.matchMedia('(prefers-color-scheme: dark)').matches
            : mode === 'dark';
        document.documentElement.setAttribute('data-bs-theme', dark ? 'dark' : 'light');
    } catch (e) {}
})();
</script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/chart.umd.min.js"></script>
<script src="{$WEBPATH}themes/{$THEMENAME}/js/issabel-charts.js"></script>
</head>
<body class="iss-body">
<div class="container-fluid py-3">
    <div class="row g-3">
        <div class="col-12">
            <section class="iss-card">
                <div class="iss-card__body">
                    <div class="iss-chart"><canvas id="chartIncoming"></canvas></div>
                </div>
            </section>
        </div>
        <div class="col-12">
            <section class="iss-card">
                <div class="iss-card__body">
                    <div class="iss-chart"><canvas id="chartOutgoing"></canvas></div>
                </div>
            </section>
        </div>
    </div>
</div>
<script type="application/json" id="issabelSummaryCharts">{$CHART_DATA}</script>
{literal}
<script>
(function () {
    'use strict';

    function readData() {
        var el = document.getElementById('issabelSummaryCharts');
        if (!el) return null;
        try {
            return JSON.parse(el.textContent);
        } catch (e) {
            return null;
        }
    }

    function buildChart(canvasId, series, text) {
        var canvas = document.getElementById(canvasId);
        if (!canvas || typeof window.Chart === 'undefined') return;

        if (!series || !series.labels || series.labels.length === 0) {
            var note = document.createElement('p');
            note.className = 'text-center';
            note.textContent = text.noData;
            canvas.parentNode.appendChild(note);
            return;
        }

        var palette = (window.IssabelCharts && window.IssabelCharts.palette)
            ? window.IssabelCharts.palette(series.labels.length)
            : [];

        new window.Chart(canvas.getContext('2d'), {
            type: 'pie',
            data: {
                labels: series.labels,
                datasets: [{
                    data: series.values,
                    backgroundColor: palette,
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'right' },
                    title: { display: true, text: series.title },
                    tooltip: {
                        callbacks: {
                            label: function (ctx) {
                                var value = ctx.parsed;
                                return ' ' + ctx.label + ': ' + value + ' ' + (value === 1 ? text.unitOne : text.unitMany);
                            }
                        }
                    }
                }
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        var data = readData();
        if (!data) return;
        buildChart('chartIncoming', data.incoming, data.text);
        buildChart('chartOutgoing', data.outgoing, data.text);
    });
})();
</script>
{/literal}
</body>
</html>
