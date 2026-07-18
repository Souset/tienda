<?php

/**
 * Cron anual: genera la cuota pendiente del año en curso para cada socio
 * activo que aún no la tenga.
 *
 * Programación recomendada en cPanel (1 de enero a las 06:00):
 *   0 6 1 1 * /usr/bin/php /ruta/a/cine-api/cron/generar_cuotas.php
 *
 * También se puede invocar por HTTP con la clave del cron:
 *   GET /cron/generar_cuotas.php?key=<cron_secret>
 *
 * El importe se lee de app_config/features.feeAmount (por defecto 20 €).
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

if (PHP_SAPI !== 'cli') {
    $key = $_GET['key'] ?? '';
    if (!hash_equals((string) config()['cron_secret'], (string) $key)) {
        json_error(403, 'Clave de cron incorrecta');
    }
}

$year = (string) (int) date('Y');

$amount = 20.0;
$features = firestore_get('app_config/features');
if ($features !== null && fs_field($features, 'feeAmount') !== null) {
    $amount = (float) fs_field($features, 'feeAmount');
}

$members = firestore_query([
    'from' => [['collectionId' => 'members']],
    'where' => [
        'fieldFilter' => [
            'field' => ['fieldPath' => 'status'],
            'op' => 'EQUAL',
            'value' => ['stringValue' => 'active'],
        ],
    ],
    'limit' => 5000,
]);

$created = 0;
foreach ($members as $row) {
    $uid = basename((string) $row['document']['name']);
    $feePath = 'members/' . rawurlencode($uid) . '/fees/' . $year;
    if (firestore_get($feePath) !== null) {
        continue; // La cuota de este año ya existe.
    }
    $ok = firestore_patch($feePath, [
        'amount' => ['doubleValue' => $amount],
        'status' => ['stringValue' => 'pending'],
    ]);
    if ($ok) {
        $created++;
        inbox_add(
            $uid,
            'Cuota de socio ' . $year,
            'Ya está disponible tu cuota anual ('
                . number_format($amount, 2, ',', '.') . ' €).',
            '/carne'
        );
    }
}

$result = ['year' => $year, 'created' => $created, 'members' => count($members)];
if (PHP_SAPI === 'cli') {
    echo json_encode($result, JSON_UNESCAPED_UNICODE) . PHP_EOL;
} else {
    json_response(200, $result);
}
