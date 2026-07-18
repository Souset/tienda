<?php

/**
 * Cron diario: envía recordatorio push e in-app a quienes tienen reserva
 * activa en eventos que empiezan en las próximas 24 horas.
 *
 * Programación recomendada en cPanel (todos los días a las 09:00):
 *   0 9 * * * /usr/bin/php /ruta/a/cine-api/cron/recordatorios.php
 *
 * También por HTTP: GET /cron/recordatorios.php?key=<cron_secret>
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
$limit = gmdate('Y-m-d\TH:i:s\Z', time() + 24 * 3600);

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
                    'value' => ['timestampValue' => $limit],
                ]],
            ],
        ],
    ],
    'limit' => 100,
]);

$notified = 0;
foreach ($events as $row) {
    $event = $row['document'];
    $eventId = basename((string) $event['name']);
    $title = (string) (fs_field($event, 'title') ?? 'Actividad');

    // Evitar duplicados: marca en el propio evento cuándo se recordó.
    if (fs_field($event, 'reminderSentAt') !== null) {
        continue;
    }

    // runQuery de subcolección requiere el documento padre en la URL.
    [$status, $rows] = http_post_json(
        firestore_base() . '/events/' . rawurlencode($eventId) . ':runQuery',
        ['structuredQuery' => [
            'from' => [['collectionId' => 'reservations']],
            'where' => [
                'fieldFilter' => [
                    'field' => ['fieldPath' => 'status'],
                    'op' => 'EQUAL',
                    'value' => ['stringValue' => 'active'],
                ],
            ],
            'limit' => 1000,
        ]],
        ['Authorization: Bearer ' . google_access_token()]
    );
    $reservations = $status === 200
        ? array_values(array_filter($rows, fn ($r) => isset($r['document'])))
        : [];

    foreach ($reservations as $res) {
        $uid = basename((string) $res['document']['name']);
        $user = firestore_get('users/' . rawurlencode($uid));
        if ($user === null) {
            continue;
        }
        $message = 'Mañana: "' . $title . '". ¡Te esperamos!';
        inbox_add($uid, 'Recordatorio de actividad', $message, '/agenda');
        foreach ((array) (fs_field($user, 'fcmTokens') ?? []) as $token) {
            fcm_send((string) $token, 'Recordatorio de actividad', $message, [
                'route' => '/agenda',
            ]);
        }
        $notified++;
    }

    firestore_patch(
        'events/' . rawurlencode($eventId),
        ['reminderSentAt' => ['timestampValue' => $now]],
        ['reminderSentAt']
    );
}

$result = ['events' => count($events), 'notified' => $notified];
if (PHP_SAPI === 'cli') {
    echo json_encode($result, JSON_UNESCAPED_UNICODE) . PHP_EOL;
} else {
    json_response(200, $result);
}
