<?php
/*
  Reemplazo de jpgraph por GD para el modulo graphic_report.

  jpgraph 4.x cambio su API y su licencia, y no hay paquete en Rocky Linux 10.
  Este modulo es su unico consumidor y solo necesita tres tipos de grafico
  (pastel 3D, lineas y estado "sin datos"), asi que se reimplementan con GD
  (php8.4-gd), que ya es dependencia de issabel-framework.

  Cada funcion envia un PNG al navegador (equivale al antiguo $graph->Stroke()).
*/

/** Devuelve una ruta a fuente TrueType; null si no hay ninguna. */
function gdchart_font_path($bold = false)
{
    $candidates = $bold ? array(
        '/usr/share/fonts/liberation-sans/LiberationSans-Bold.ttf',
        '/usr/share/fonts/liberation/LiberationSans-Bold.ttf',
        '/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf',
    ) : array(
        '/usr/share/fonts/liberation-sans/LiberationSans-Regular.ttf',
        '/usr/share/fonts/liberation/LiberationSans-Regular.ttf',
        '/usr/share/fonts/dejavu/DejaVuSans.ttf',
    );
    foreach ($candidates as $f) {
        if (is_readable($f)) return $f;
    }
    return null;
}

/** Escribe texto UTF-8 centrado horizontalmente en $x, linea base en $y. */
function gdchart_text($img, $size, $x, $y, $color, $text, $align = 'center', $bold = false)
{
    $font = gdchart_font_path($bold);
    if ($font !== null) {
        $box = imagettfbbox($size, 0, $font, $text);
        $w   = abs($box[2] - $box[0]);
        if ($align === 'center')      $x -= $w / 2;
        elseif ($align === 'right')   $x -= $w;
        imagettftext($img, $size, 0, (int)$x, (int)$y, $color, $font, $text);
        return $w;
    }
    // Ultimo recurso: fuente bitmap de GD (ASCII).
    $w = imagefontwidth(3) * strlen($text);
    if ($align === 'center')    $x -= $w / 2;
    elseif ($align === 'right') $x -= $w;
    imagestring($img, 3, (int)$x, (int)$y - imagefontheight(3), $text, $color);
    return $w;
}

function gdchart_color($img, $hex)
{
    $hex = ltrim($hex, '#');
    return imagecolorallocate($img,
        hexdec(substr($hex, 0, 2)), hexdec(substr($hex, 2, 2)), hexdec(substr($hex, 4, 2)));
}

/** Crea el lienzo con el marco y el fondo que usaba la implementacion previa. */
function gdchart_canvas($width, $height)
{
    $img   = imagecreatetruecolor($width, $height);
    $bg    = imagecolorallocate($img, 250, 250, 250);   // #fafafa
    $frame = imagecolorallocate($img, 153, 153, 153);   // #999999
    imagefilledrectangle($img, 0, 0, $width - 1, $height - 1, $bg);
    imagerectangle($img, 0, 0, $width - 1, $height - 1, $frame);
    imagealphablending($img, true);
    return $img;
}

function gdchart_flush($img)
{
    header('Content-Type: image/png');
    imagepng($img);
    imagedestroy($img);
}

/**
 * Pie 3D con leyenda. $values y $legends deben tener el mismo tamaño; $colors
 * es la paleta (hex). $cxFrac es la posicion horizontal del centro (0..1).
 */
function gdchart_pie($width, $height, $title, array $values, array $legends, $cxFrac = 0.4, $diameter = 160, $depth = 16)
{
    $img = gdchart_canvas($width, $height);

    $titleColor = gdchart_color($img, '#444444');
    gdchart_text($img, 11, $width / 2, 22, $titleColor, $title, 'center', true);

    $palette = array('#3333cc', '#9999cc', '#CC3333', '#72394a', '#aa3424');
    $colors  = array();
    foreach ($values as $i => $v) {
        $colors[$i] = gdchart_color($img, $palette[$i % count($palette)]);
    }

    $total = array_sum($values);
    if ($total <= 0) $total = 1;

    $cx = (int)($width * $cxFrac);
    $cy = (int)($height / 2 + $depth / 2);
    $edge = imagecolorallocate($img, 0, 0, 0);

    $draw = function ($offset) use ($img, $cx, $cy, $depth, $diameter, $values, $total, $colors) {
        $start = 45.0;
        foreach ($values as $i => $v) {
            $end = $start + 360.0 * $v / $total;
            imagefilledarc($img, $cx, $cy + $offset, $diameter, (int)($diameter * 0.72),
                (int)round($start), (int)round($end), $colors[$i], IMG_ARC_PIE);
            $start = $end;
        }
    };

    // Capa inferior desplazada: da el efecto de profundidad del 3D.
    $dark = array();
    foreach ($values as $i => $v) {
        $hex = $palette[$i % count($palette)];
        $r = (int)(hexdec(substr($hex, 1, 2)) * 0.6);
        $g = (int)(hexdec(substr($hex, 3, 2)) * 0.6);
        $b = (int)(hexdec(substr($hex, 5, 2)) * 0.6);
        $dark[$i] = imagecolorallocate($img, $r, $g, $b);
    }
    $colorsOrig = $colors;
    $drawDepth = function () use ($img, $cx, $cy, $depth, $diameter, $values, $total, $dark) {
        $start = 45.0;
        foreach ($values as $i => $v) {
            $end = $start + 360.0 * $v / $total;
            imagefilledarc($img, $cx, $cy + $depth, $diameter, (int)($diameter * 0.72),
                (int)round($start), (int)round($end), $dark[$i], IMG_ARC_PIE);
            $start = $end;
        }
    };
    $drawDepth();
    $draw(0);

    // Borde de cada porcion: contorno de la elipse superior.
    imageellipse($img, $cx, $cy, $diameter, (int)($diameter * 0.72), $edge);

    // Leyenda a la derecha del grafico.
    $lx = (int)($width * 0.72);
    $ly = (int)($height / 2 - (count($legends) * 22) / 2);
    $textColor = gdchart_color($img, '#444444');
    foreach ($legends as $i => $label) {
        $y = $ly + $i * 22;
        imagefilledrectangle($img, $lx, $y, $lx + 14, $y + 14, $colorsOrig[$i]);
        imagerectangle($img, $lx, $y, $lx + 14, $y + 14, $edge);
        gdchart_text($img, 9, $lx + 20, $y + 13, $textColor, $label, 'left');
    }

    gdchart_flush($img);
}

/** Grafico de lineas con marcas por clave numerica (respeta la separacion X). */
function gdchart_line($width, $height, $title, array $values, array $labels)
{
    $img = gdchart_canvas($width, $height);

    $titleColor = gdchart_color($img, '#444444');
    $axisColor  = gdchart_color($img, '#666666');
    $lineColor  = gdchart_color($img, '#00cc00');

    gdchart_text($img, 11, $width / 2, 22, $titleColor, $title, 'center', true);

    $left = 50; $right = 100; $top = 40; $bottom = 40;
    $plotW = $width - $left - $right;
    $plotH = $height - $top - $bottom;

    // Ejes.
    imageline($img, $left, $top, $left, $top + $plotH, $axisColor);
    imageline($img, $left, $top + $plotH, $left + $plotW, $top + $plotH, $axisColor);

    $keys = array_keys($values);
    $xmin = min($keys); $xmax = max($keys);
    if ($xmax <= $xmin) $xmax = $xmin + 1;

    $ymax = max($values);
    if ($ymax <= 0) $ymax = 1;

    $px = function ($key) use ($left, $plotW, $xmin, $xmax) {
        return $left + ($key - $xmin) / ($xmax - $xmin) * $plotW;
    };
    $py = function ($val) use ($top, $plotH, $ymax) {
        return $top + $plotH - ($val / $ymax) * $plotH;
    };

    $pts = array();
    foreach ($values as $k => $v) $pts[] = array($px($k), $py($v));

    // Linea con estilo "step" (escalonado), como el SetStepStyle anterior.
    for ($i = 1; $i < count($pts); $i++) {
        $x0 = $pts[$i - 1][0]; $y0 = $pts[$i - 1][1];
        $x1 = $pts[$i][0];     $y1 = $pts[$i][1];
        imageline($img, (int)$x0, (int)$y0, (int)$x1, (int)$y0, $lineColor);
        imageline($img, (int)$x1, (int)$y0, (int)$x1, (int)$y1, $lineColor);
    }

    // Etiquetas del eje X rotadas 90 grados, solo donde hay texto.
    $labelColor = gdchart_color($img, '#444444');
    $font = gdchart_font_path(false);
    foreach ($values as $k => $v) {
        if (!isset($labels[$k]) || $labels[$k] === '') continue;
        $x = $px($k);
        if ($font !== null) {
            imagettftext($img, 8, 90, (int)$x, $top + $plotH + 60, $labelColor, $font, $labels[$k]);
        } else {
            imagestringup($img, 2, (int)$x, $top + $plotH + 60, $labels[$k], $labelColor);
        }
    }

    gdchart_flush($img);
}

/** Estado "sin datos": titulo arriba y mensaje enmarcado, como el CanvasGraph. */
function gdchart_nodata($width, $height, $title, $subtitle)
{
    $img = gdchart_canvas($width, $height);
    $textColor = gdchart_color($img, '#444444');
    $navy      = gdchart_color($img, '#000080');
    $black     = imagecolorallocate($img, 0, 0, 0);
    $white     = imagecolorallocate($img, 255, 255, 255);

    gdchart_text($img, 11, $width / 2, 55, $textColor, $title, 'center', true);

    // Caja del mensaje.
    $boxW = (int)($width * 0.8);
    $boxX = (int)(($width - $boxW) / 2);
    $boxY = 80;
    imagefilledrectangle($img, $boxX, $boxY, $boxX + $boxW, $boxY + 28, $white);
    imagerectangle($img, $boxX, $boxY, $boxX + $boxW, $boxY + 28, $black);
    gdchart_text($img, 10, $width / 2, $boxY + 20, $black, $subtitle, 'center');

    // Marco interior navy, como el Rectangle() anterior.
    imagerectangle($img, 1, 1, $width - 2, $height - 2, $navy);

    gdchart_flush($img);
}
