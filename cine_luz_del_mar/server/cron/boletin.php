<?php

/**
 * Cron semanal (lunes): boletín con la agenda de la semana y las últimas
 * noticias, enviado al buzón in-app y por push a toda la comunidad.
 *
 * Programación recomendada en cPanel (lunes a las 10:00):
 *   0 10 * * 1 /usr/local/bin/php /ruta/a/cine-api/cron/boletin.php
 *
 * También por HTTP: GET /cron/boletin.php?key=<cron_secret>
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

if (PHP_SAPI !== 'cli') {
    $key = $_GET['key'] ?? '';
    if (!hash_equals((string) config()['cron_secret'], (string) $key)) {
        json_error(403, 'Clave de cron incorrecta');
    }
}

$now = gmdate('Y-m-d\TH:i:s\Z');
$weekEnd = gmdate('Y-m-d\TH:i:s\Z', time() + 7 * 24 * 3600);

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
                ['fieldFilter' => [
                    'field' => ['fieldPath' => 'start'],
                    'op' => 'LESS_THAN_OR_EQUAL',
                    'value' => ['timestampValue' => $weekEnd],
                ]],
            ],
        ],
    ],
    'orderBy' => [['field' => ['fieldPath' => 'start']]],
    'limit' => 6,
]);

if ($events === []) {
    $result = ['sent' => 0, 'reason' => 'sin eventos esta semana'];
    PHP_SAPI === 'cli'
        ? print(json_encode($result, JSON_UNESCAPED_UNICODE) . PHP_EOL)
        : json_response(200, $result);
    exit;
}

$titles = [];
foreach ($events as $row) {
    $titles[] = (string) (fs_field($row['document'], 'title') ?? '');
}
$title = 'Esta semana en Cine Luz del Mar';
$body = count($titles) === 1
    ? $titles[0]
    : implode(' · ', array_slice($titles, 0, 3))
        . (count($titles) > 3 ? '…' : '');

// Toda la base de usuarios (paginación simple hasta 2000).
$users = firestore_query([
    'from' => [['collectionId' => 'users']],
    'select' => ['fields' => [['fieldPath' => 'fcmTokens']]],
    'limit' => 2000,
]);

$sent = 0;
$inbox = 0;
foreach ($users as $row) {
    $uid = basename((string) $row['document']['name']);
    inbox_add($uid, $title, $body, '/agenda');
    $inbox++;
    foreach ((array) (fs_field($row['document'], 'fcmTokens') ?? []) as $token) {
        if (fcm_send((string) $token, $title, $body, ['route' => '/agenda'])) {
            $sent++;
        }
    }
}

$result = ['events' => count($events), 'inbox' => $inbox, 'push' => $sent];
PHP_SAPI === 'cli'
    ? print(json_encode($result, JSON_UNESCAPED_UNICODE) . PHP_EOL)
    : json_response(200, $result);
