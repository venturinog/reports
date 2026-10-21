<!DOCTYPE html>
<html lang="{$LANG|default:'en'}" data-bs-theme="light">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8" />
    <title>Issabel</title>

    <link rel="stylesheet" href="{$WEBPATH}themes/{$THEMENAME}/css/tabler.min.css">
    <link rel="stylesheet" href="{$WEBPATH}themes/{$THEMENAME}/css/tabler-icons.min.css">
    <link rel="stylesheet" href="{$WEBPATH}themes/{$THEMENAME}/css/inter.css">
    <link rel="stylesheet" href="{$WEBPATH}themes/{$THEMENAME}/css/modern.css">
    <link rel="stylesheet" href="{$WEBPATH}themes/{$THEMENAME}/css/modern-compat.css">

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

    <style>
    .neo-table-header-row { display:none !important; }
    </style>
    {$HEADER_LIBS_JQUERY}
    <script type='text/javascript' src="{$WEBPATH}libs/js/base.js"></script>
    <script type='text/javascript' src="{$WEBPATH}libs/js/sticky_note/sticky_note.js"></script>
    <script type='text/javascript' src="{$WEBPATH}libs/js/iframe.js"></script>

    {$HEADER}
    {$HEADER_MODULES}
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="mainBody page-body" {$BODYPARAMS}>
