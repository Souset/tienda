<?php

/**
 * Envío de notificaciones push (FCM HTTP v1) + buzón in-app.
 *
 * POST application/json:
 *   - Authorization: Bearer <ID token de Firebase> (rol coordinador o superior)
 *   - body: {
 *       "title": "...", "body": "...", "route": "/agenda" (opcional),
 *       "uids": ["uid1", ...]   → destinatarios concretos
 *       | "audience": "all"     → todos los usuarios con token registrado
 *     }
 *
 * Respuesta: { "sent": n, "inbox": n }
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

apply_cors();

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_error(405, 'Método no permitido');
}

$claims = require_auth();
if (user_rank((string) $claims['sub']) < 3) {
    json_error(403, 'Solo los coordinadores pueden enviar notificaciones');
}

$input = json_decode((string) file_get_contents('php://input'), true) ?? [];
$title = trim((string) ($input['title'] ?? ''));
$body = trim((string) ($input['body'] ?? ''));
$route = trim((string) ($input['route'] ?? ''));
if ($title === '' || $body === '') {
    json_error(400, 'Faltan el título o el cuerpo de la notificación');
}

// Destinatarios: lista de uids o toda la base de usuarios (paginada).
$targets = [];
if (isset($input['uids']) && is_array($input['uids'])) {
    foreach (array_slice($input['uids'], 0, 500) as $uid) {
        $doc = firestore_get('users/' . rawurlencode((string) $uid));
        if ($doc !== null) {
            $targets[(string) $uid] = (array) (fs_field($doc, 'fcmTokens') ?? []);
        }
    }
} elseif (($input['audience'] ?? '') === 'all') {
    $rows = firestore_query([
        'from' => [['collectionId' => 'users']],
        'select' => ['fields' => [['fieldPath' => 'fcmTokens']]],
        'limit' => 2000,
    ]);
    foreach ($rows as $row) {
        $doc = $row['document'];
        $uid = basename((string) $doc['name']);
        $targets[$uid] = (array) (fs_field($doc, 'fcmTokens') ?? []);
    }
} else {
    json_error(400, 'Indica "uids" o "audience": "all"');
}

$sent = 0;
$inbox = 0;
foreach ($targets as $uid => $tokens) {
    inbox_add($uid, $title, $body, $route);
    $inbox++;
    foreach (array_slice($tokens, 0, 10) as $token) {
        if (fcm_send((string) $token, $title, $body, ['route' => $route])) {
            $sent++;
        }
    }
}

json_response(200, ['sent' => $sent, 'inbox' => $inbox]);
