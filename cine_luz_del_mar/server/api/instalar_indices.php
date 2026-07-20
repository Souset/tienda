<?php

/**
 * Instalador de los índices compuestos de Firestore (un solo uso).
 *
 * Sin estos índices, las consultas de agenda, noticias, comunidad, chat y
 * panel de administración fallan. Se ejecuta visitando UNA vez:
 *
 *   https://TU_DOMINIO/cine-api/api/instalar_indices.php?key=<cron_secret>
 *
 * (la clave es el valor de 'cron_secret' de lib/config.php)
 *
 * Es idempotente: los índices ya existentes se marcan como "ya existía".
 * Los índices tardan unos minutos en construirse tras crearse.
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

$key = $_GET['key'] ?? '';
if (!hash_equals((string) config()['cron_secret'], (string) $key)) {
    json_error(403, 'Clave incorrecta (usa el cron_secret de config.php)');
}

// Debe coincidir con cine_luz_del_mar/firebase/firestore.indexes.json.
$asc = fn (string $f) => ['fieldPath' => $f, 'order' => 'ASCENDING'];
$desc = fn (string $f) => ['fieldPath' => $f, 'order' => 'DESCENDING'];
$arr = fn (string $f) => ['fieldPath' => $f, 'arrayConfig' => 'CONTAINS'];

$indexes = [
    ['events', [$asc('status'), $asc('start')]],
    ['events', [$asc('status'), $desc('featured'), $asc('start')]],
    ['events', [$asc('status'), $arr('searchTokens'), $asc('start')]],
    ['events', [$asc('status'), $asc('venue.geohash')]],
    ['news', [$asc('status'), $desc('publishedAt')]],
    ['news', [$asc('status'), $desc('featured'), $desc('publishedAt')]],
    ['news', [$asc('status'), $arr('searchTokens'), $desc('publishedAt')]],
    ['films', [$arr('searchTokens'), $asc('title')]],
    ['posts', [$asc('visibility'), $desc('createdAt')]],
    ['posts', [$asc('authorUid'), $desc('createdAt')]],
    ['library', [$asc('type'), $desc('createdAt')]],
    ['library', [$asc('category'), $desc('createdAt')]],
    ['library', [$asc('minRole'), $desc('createdAt')]],
    ['library', [$asc('minRole'), $arr('searchTokens')]],
    ['chats', [$arr('memberUids'), $desc('lastMessageAt')]],
    ['friendships', [$arr('uids'), $asc('status')]],
    ['users', [$arr('searchTokens'), $asc('displayName')]],
];

$project = config()['firebase_project_id'];
$token = google_access_token();
$results = [];

foreach ($indexes as [$collection, $fields]) {
    $url = "https://firestore.googleapis.com/v1/projects/$project"
        . "/databases/(default)/collectionGroups/$collection/indexes";
    [$status, $response] = http_post_json(
        $url,
        ['queryScope' => 'COLLECTION', 'fields' => $fields],
        ['Authorization: Bearer ' . $token]
    );
    $label = $collection . ': '
        . implode('+', array_map(fn ($f) => $f['fieldPath'], $fields));
    $results[$label] = match (true) {
        $status === 200 => 'creado (construyéndose)',
        $status === 409 => 'ya existía',
        default => 'ERROR ' . $status . ' '
            . ($response['error']['message'] ?? ''),
    };
}

$errors = count(array_filter($results, fn ($r) => str_starts_with($r, 'ERROR')));
json_response(200, [
    'resultado' => $errors === 0
        ? 'ÍNDICES INSTALADOS: espera 5-10 minutos a que terminen de '
            . 'construirse y la app funcionará al completo'
        : "Completado con $errors errores (revisa el detalle)",
    'detalle' => $results,
]);
