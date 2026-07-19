<?php

/**
 * Web pública de Cine Luz del Mar (SEO) para el hosting de Nicalia.
 *
 * Página estática renderizada en servidor con la agenda y las noticias
 * publicadas, indexable por Google. Se cachea en disco 10 minutos para no
 * consumir cuota de Firestore.
 *
 * Instalación: se sube junto al resto de cine-api/ y se sirve en
 * https://TU_DOMINIO/cine-api/web/ (o mapea un subdominio a esta carpeta).
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

// ---------- Caché ----------
$cacheFile = sys_get_temp_dir() . '/clm_web_cache.html';
if (is_file($cacheFile) && filemtime($cacheFile) > time() - 600) {
    header('Content-Type: text/html; charset=utf-8');
    readfile($cacheFile);
    exit;
}

// ---------- Datos ----------
$now = gmdate('Y-m-d\TH:i:s\Z');

$events = firestore_query([
    'from' => [['collectionId' => 'events']],
    'where' => [
        'compositeFilter' => [
            'op' => 'AND',
            'filters' => [
                ['fieldFilter' => [
                    'field' => ['fieldPath' => 'status'],
                    'op' => 'EQUAL',
                    'value' => ['stringValue' => 'published'],
                ]],
                ['fieldFilter' => [
                    'field' => ['fieldPath' => 'start'],
                    'op' => 'GREATER_THAN_OR_EQUAL',
                    'value' => ['timestampValue' => $now],
                ]],
            ],
        ],
    ],
    'orderBy' => [['field' => ['fieldPath' => 'start']]],
    'limit' => 12,
]);

$news = firestore_query([
    'from' => [['collectionId' => 'news']],
    'where' => [
        'fieldFilter' => [
            'field' => ['fieldPath' => 'status'],
            'op' => 'EQUAL',
            'value' => ['stringValue' => 'published'],
        ],
    ],
    'orderBy' => [[
        'field' => ['fieldPath' => 'publishedAt'],
        'direction' => 'DESCENDING',
    ]],
    'limit' => 6,
]);

function e(?string $s): string
{
    return htmlspecialchars((string) $s, ENT_QUOTES, 'UTF-8');
}

function fecha(?string $iso): string
{
    if (!$iso) {
        return 'Fecha por confirmar';
    }
    $meses = ['', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    $t = strtotime($iso);
    return date('j', $t) . ' de ' . $meses[(int) date('n', $t)]
        . ' · ' . date('H:i', $t);
}

$tipos = [
    'proyeccion' => 'Proyección',
    'taller' => 'Taller',
    'charla' => 'Charla',
    'festival' => 'Festival',
];

// ---------- Render ----------
ob_start();
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Cine Luz del Mar · Asociación cultural de cine</title>
<meta name="description" content="Agenda de proyecciones, talleres, charlas y festivales de la asociación cultural Cine Luz del Mar. Cine, cultura y educación audiovisual.">
<style>
  :root { color-scheme: dark; }
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { background: #0a0a0a; color: #f2f2f2; font: 16px/1.6 Georgia, 'Times New Roman', serif; }
  .wrap { max-width: 860px; margin: 0 auto; padding: 48px 20px 80px; }
  header { text-align: center; margin-bottom: 56px; }
  h1 { font-family: 'Pinyon Script', cursive; font-weight: 400; font-size: clamp(42px, 8vw, 72px); }
  header p { color: #a6a6a6; letter-spacing: 3px; text-transform: uppercase; font-size: 12px; margin-top: 6px; }
  h2 { font-size: 26px; margin: 48px 0 20px; border-bottom: 1px solid #2a2a2a; padding-bottom: 10px; }
  .evento { display: flex; gap: 18px; padding: 16px 0; border-bottom: 1px solid #1e1e1e; }
  .fecha { min-width: 130px; color: #a6a6a6; font-size: 14px; }
  .evento h3 { font-size: 18px; font-weight: 600; font-family: Helvetica, Arial, sans-serif; }
  .tipo { display: inline-block; border: 1px solid #4d4d4d; border-radius: 6px; padding: 1px 8px; font-size: 11px; letter-spacing: 1px; text-transform: uppercase; color: #d9d9d9; margin-bottom: 6px; font-family: Helvetica, sans-serif; }
  .lugar, .noticia p { color: #a6a6a6; font-size: 14px; }
  .noticia { padding: 16px 0; border-bottom: 1px solid #1e1e1e; }
  .noticia h3 { font-size: 18px; font-family: Helvetica, Arial, sans-serif; margin-bottom: 4px; }
  footer { margin-top: 64px; text-align: center; color: #4d4d4d; font-size: 13px; font-family: Helvetica, sans-serif; }
  .vacio { color: #a6a6a6; padding: 12px 0; }
  @media (max-width: 600px) { .evento { flex-direction: column; gap: 4px; } }
</style>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Pinyon+Script&display=swap" rel="stylesheet">
</head>
<body>
<div class="wrap">
  <header>
    <h1>Cine Luz del Mar</h1>
    <p>Asociación cultural · cine, cultura y educación audiovisual</p>
  </header>

  <h2>Próximas actividades</h2>
  <?php if ($events === []): ?>
    <p class="vacio">Muy pronto anunciaremos nuevas actividades.</p>
  <?php endif; ?>
  <?php foreach ($events as $row): $d = $row['document']; ?>
    <article class="evento">
      <div class="fecha"><?= e(fecha(fs_field($d, 'start'))) ?></div>
      <div>
        <span class="tipo"><?= e($tipos[fs_field($d, 'type')] ?? 'Actividad') ?></span>
        <h3><?= e(fs_field($d, 'title')) ?></h3>
        <?php $venue = fs_field($d, 'venue'); ?>
        <?php if (is_array($venue) && ($venue['name'] ?? '') !== ''): ?>
          <div class="lugar"><?= e($venue['name']) ?><?= ($venue['address'] ?? '') !== '' ? ' · ' . e($venue['address']) : '' ?></div>
        <?php endif; ?>
      </div>
    </article>
  <?php endforeach; ?>

  <h2>Noticias</h2>
  <?php if ($news === []): ?>
    <p class="vacio">Sin noticias por ahora.</p>
  <?php endif; ?>
  <?php foreach ($news as $row): $d = $row['document']; ?>
    <article class="noticia">
      <h3><?= e(fs_field($d, 'title')) ?></h3>
      <p><?= e(mb_strimwidth((string) fs_field($d, 'body'), 0, 220, '…', 'UTF-8')) ?></p>
    </article>
  <?php endforeach; ?>

  <footer>
    Cine Luz del Mar · Toda la actividad, reservas y comunidad en nuestra app.
  </footer>
</div>
</body>
</html>
<?php
$html = (string) ob_get_clean();
file_put_contents($cacheFile, $html);
header('Content-Type: text/html; charset=utf-8');
echo $html;
