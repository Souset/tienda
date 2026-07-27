<?php

/**
 * Cron diario: pide valoración (1-5 estrellas) a quienes asistieron o
 * reservaron eventos que terminaron ayer.
 *
 * Programación recomendada en cPanel (todos los días a las 11:00):
 *   0 11 * * * /usr/local/bin/php /ruta/a/cine-api/cron/valoraciones.php
 *
 * También por HTTP: GET /cron/valoraciones.php?key=<cron_secret>
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

if (PHP_SAPI !== 'cli') {
    $key = $_GET['key'] ?? '';
    if (!hash_equals((string) config()['cron_secret'], (string) $key)) {
        json_error(403, 'Clave de cron incorrecta');
    }
}

$from = gmdate('Y-m-d\TH:i:s\Z', time() - 48 * 3600);
$to = gmdate('Y-m-d\TH:i:s\Z', time() - 4 * 3600);

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
                    'value' => ['timestampValue' => $from],
                ]],
                ['fieldFilter' => [
                    'field' => ['fieldPath' => 'start'],
                    'op' => 'LESS_THAN_OR_EQUAL',
                    'value' => ['timestampValue' => $to],
                ]],
            ],
        ],
    ],
    'limit' => 50,
]);

$notified = 0;
foreach ($events as $row) {
    $event = $row['document'];
    $eventId = basename((string) $event['name']);
    $title = (string) (fs_field($event, 'title') ?? 'la actividad');

    // Marca para no pedir la valoración dos veces.
    if (fs_field($event, 'feedbackAskedAt') !== null) {
        continue;
    }

    [$status, $rows] = http_post_json(
        firestore_base() . '/events/' . rawurlencode($eventId) . ':runQuery',
        ['structuredQuery' => [
            'from' => [['collectionId' => 'reservations']],
            'limit' => 1000,
        ]],
        ['Authorization: Bearer ' . google_access_token()]
    );
    $reservations = $status === 200
        ? array_values(array_filter($rows, fn ($r) => isset($r['document'])))
        : [];

    foreach ($reservations as $res) {
        if ((string) (fs_field($res['document'], 'status') ?? '') === 'cancelled') {
            continue;
        }
        $uid = basename((string) $res['document']['name']);
        $message = "¿Qué te pareció \"$title\"? Valórala en un minuto.";
        inbox_add($uid, 'Tu opinión nos importa', $message, "/agenda/$eventId");
        $user = firestore_get('users/' . rawurlencode($uid));
        foreach ((array) ($user ? fs_field($user, 'fcmTokens') : []) as $token) {
            fcm_send((string) $token, 'Tu opinión nos importa', $message, [
                'route' => "/agenda/$eventId",
            ]);
        }
        $notified++;
    }

    firestore_patch(
        'events/' . rawurlencode($eventId),
        ['feedbackAskedAt' => ['timestampValue' => gmdate('Y-m-d\TH:i:s\Z')]],
        ['feedbackAskedAt']
    );
}

$result = ['events' => count($events), 'notified' => $notified];
PHP_SAPI === 'cli'
    ? print(json_encode($result, JSON_UNESCAPED_UNICODE) . PHP_EOL)
    : json_response(200, $result);
