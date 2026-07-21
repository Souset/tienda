<?php

/**
 * Utilidades comunes de la mini-API: configuración, CORS, respuestas JSON,
 * verificación de ID tokens de Firebase y acceso a Firestore/FCM vía REST.
 *
 * Sin dependencias de Composer: solo openssl, curl y json (disponibles en
 * cualquier hosting compartido con PHP 8).
 */

declare(strict_types=1);

function config(): array
{
    static $config = null;
    if ($config === null) {
        $path = __DIR__ . '/config.php';
        if (!is_file($path)) {
            json_error(500, 'Falta lib/config.php (copia config.sample.php)');
        }
        $config = require $path;
    }
    return $config;
}

function json_response(int $status, array $data): never
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function json_error(int $status, string $message): never
{
    json_response($status, ['error' => $message]);
}

/** Cabeceras CORS para las llamadas desde la app web (y preflight). */
function apply_cors(): void
{
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    if ($origin !== '' && in_array($origin, config()['allowed_origins'], true)) {
        header('Access-Control-Allow-Origin: ' . $origin);
        header('Vary: Origin');
        header('Access-Control-Allow-Headers: Authorization, Content-Type');
        header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
        header('Access-Control-Max-Age: 3600');
    }
    if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
        http_response_code(204);
        exit;
    }
}

function http_get(string $url, array $headers = []): array
{
    return http_request('GET', $url, null, $headers);
}

function http_post_json(string $url, array $body, array $headers = []): array
{
    $headers[] = 'Content-Type: application/json';
    return http_request('POST', $url, json_encode($body), $headers);
}

/** POST con cuerpo application/x-www-form-urlencoded (API de Stripe). */
function http_post_form(string $url, array $body, array $headers = []): array
{
    $headers[] = 'Content-Type: application/x-www-form-urlencoded';
    return http_request('POST', $url, http_build_query($body), $headers);
}

function http_request(string $method, string $url, ?string $body, array $headers): array
{
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CUSTOMREQUEST => $method,
        CURLOPT_HTTPHEADER => $headers,
        CURLOPT_TIMEOUT => 30,
    ]);
    if ($body !== null) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
    }
    $response = curl_exec($ch);
    $status = (int) curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
    curl_close($ch);
    if ($response === false) {
        return [0, []];
    }
    return [$status, json_decode($response, true) ?? []];
}

function b64url_decode(string $data): string
{
    return base64_decode(strtr($data, '-_', '+/')) ?: '';
}

function b64url_encode(string $data): string
{
    return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
}

/**
 * Verifica un ID token de Firebase Authentication (RS256) y devuelve sus
 * claims. Comprueba firma contra los certificados públicos de Google
 * (cacheados en disco 1 hora), expiración, emisor y audiencia.
 */
function verify_firebase_token(string $jwt): array
{
    $parts = explode('.', $jwt);
    if (count($parts) !== 3) {
        json_error(401, 'Token mal formado');
    }
    [$h64, $p64, $s64] = $parts;
    $header = json_decode(b64url_decode($h64), true) ?? [];
    $claims = json_decode(b64url_decode($p64), true) ?? [];
    $kid = $header['kid'] ?? '';
    if (($header['alg'] ?? '') !== 'RS256' || $kid === '') {
        json_error(401, 'Algoritmo de token no soportado');
    }

    $certs = google_public_certs();
    if (!isset($certs[$kid])) {
        json_error(401, 'Certificado de firma desconocido');
    }
    $publicKey = openssl_pkey_get_public($certs[$kid]);
    $verified = openssl_verify(
        "$h64.$p64",
        b64url_decode($s64),
        $publicKey,
        OPENSSL_ALGO_SHA256
    );
    if ($verified !== 1) {
        json_error(401, 'Firma de token inválida');
    }

    $projectId = config()['firebase_project_id'];
    $now = time();
    if (($claims['exp'] ?? 0) < $now - 60) {
        json_error(401, 'Token caducado');
    }
    if (($claims['aud'] ?? '') !== $projectId
        || ($claims['iss'] ?? '') !== "https://securetoken.google.com/$projectId"
        || ($claims['sub'] ?? '') === ''
    ) {
        json_error(401, 'Token de otro proyecto');
    }
    return $claims;
}

function google_public_certs(): array
{
    $cacheFile = sys_get_temp_dir() . '/clm_google_certs.json';
    if (is_file($cacheFile) && filemtime($cacheFile) > time() - 3600) {
        return json_decode((string) file_get_contents($cacheFile), true) ?? [];
    }
    [$status, $certs] = http_get(
        'https://www.googleapis.com/robot/v1/metadata/x509/'
        . 'securetoken@system.gserviceaccount.com'
    );
    if ($status !== 200 || $certs === []) {
        json_error(503, 'No se pudieron obtener los certificados de Google');
    }
    file_put_contents($cacheFile, json_encode($certs));
    return $certs;
}

/** Extrae y verifica el Bearer token de la petición actual. */
function require_auth(): array
{
    $auth = $_SERVER['HTTP_AUTHORIZATION']
        ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? '';
    if (!preg_match('/^Bearer\s+(.+)$/i', $auth, $m)) {
        json_error(401, 'Falta el token de autenticación');
    }
    return verify_firebase_token(trim($m[1]));
}

// ---------------------------------------------------------------------------
// Service account: token OAuth para Firestore y FCM.
// ---------------------------------------------------------------------------

function service_account(): array
{
    static $sa = null;
    if ($sa === null) {
        $path = config()['service_account_path'];
        if (!is_file($path)) {
            json_error(500, 'Service account no encontrada');
        }
        $sa = json_decode((string) file_get_contents($path), true) ?? [];
    }
    return $sa;
}

/** Access token OAuth2 firmado con la service account (cacheado ~50 min). */
function google_access_token(): string
{
    // v2: el nombre de la caché cambió al ampliar el scope a cloud-platform
    // (necesario para crear índices); así no se reutiliza un token antiguo.
    $cacheFile = sys_get_temp_dir() . '/clm_access_token_v2.json';
    if (is_file($cacheFile)) {
        $cached = json_decode((string) file_get_contents($cacheFile), true);
        if (($cached['exp'] ?? 0) > time() + 60) {
            return $cached['token'];
        }
    }

    $sa = service_account();
    $now = time();
    $header = b64url_encode((string) json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
    $payload = b64url_encode((string) json_encode([
        'iss' => $sa['client_email'],
        // cloud-platform cubre Firestore (datos y administración, incluida
        // la creación de índices); messaging es para las push FCM.
        'scope' => 'https://www.googleapis.com/auth/cloud-platform '
            . 'https://www.googleapis.com/auth/firebase.messaging',
        'aud' => 'https://oauth2.googleapis.com/token',
        'iat' => $now,
        'exp' => $now + 3600,
    ]));
    openssl_sign("$header.$payload", $signature, $sa['private_key'], OPENSSL_ALGO_SHA256);
    $assertion = "$header.$payload." . b64url_encode($signature);

    $ch = curl_init('https://oauth2.googleapis.com/token');
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => http_build_query([
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion' => $assertion,
        ]),
        CURLOPT_TIMEOUT => 30,
    ]);
    $response = json_decode((string) curl_exec($ch), true) ?? [];
    curl_close($ch);
    $token = $response['access_token'] ?? '';
    if ($token === '') {
        json_error(503, 'No se pudo obtener el token de Google');
    }
    file_put_contents($cacheFile, json_encode([
        'token' => $token,
        'exp' => time() + (int) ($response['expires_in'] ?? 3600) - 300,
    ]));
    chmod($cacheFile, 0600);
    return $token;
}

// ---------------------------------------------------------------------------
// Firestore REST.
// ---------------------------------------------------------------------------

function firestore_base(): string
{
    $project = config()['firebase_project_id'];
    return "https://firestore.googleapis.com/v1/projects/$project"
        . '/databases/(default)/documents';
}

function firestore_get(string $path): ?array
{
    [$status, $doc] = http_get(
        firestore_base() . '/' . $path,
        ['Authorization: Bearer ' . google_access_token()]
    );
    return $status === 200 ? $doc : null;
}

function firestore_patch(string $path, array $fields, array $updateMask = []): bool
{
    $url = firestore_base() . '/' . $path;
    if ($updateMask !== []) {
        $params = array_map(
            fn ($f) => 'updateMask.fieldPaths=' . urlencode($f),
            $updateMask
        );
        $url .= '?' . implode('&', $params);
    }
    [$status] = http_request(
        'PATCH',
        $url,
        json_encode(['fields' => $fields]),
        [
            'Authorization: Bearer ' . google_access_token(),
            'Content-Type: application/json',
        ]
    );
    return $status === 200;
}

/** Nombre completo de un documento para las escrituras de :commit. */
function fs_doc_name(string $path): string
{
    $project = config()['firebase_project_id'];
    return "projects/$project/databases/(default)/documents/$path";
}

/**
 * Commit atómico de varias escrituras (con precondiciones opcionales).
 * Devuelve [status, respuesta]; status 200 = todas aplicadas.
 */
function firestore_commit(array $writes): array
{
    $project = config()['firebase_project_id'];
    return http_post_json(
        "https://firestore.googleapis.com/v1/projects/$project"
            . '/databases/(default)/documents:commit',
        ['writes' => $writes],
        ['Authorization: Bearer ' . google_access_token()]
    );
}

function firestore_query(array $structuredQuery): array
{
    [$status, $rows] = http_post_json(
        firestore_base() . ':runQuery',
        ['structuredQuery' => $structuredQuery],
        ['Authorization: Bearer ' . google_access_token()]
    );
    if ($status !== 200) {
        return [];
    }
    return array_values(array_filter(
        $rows,
        fn ($r) => isset($r['document'])
    ));
}

/** Convierte un value de Firestore REST a un valor PHP plano. */
function fs_value(array $value): mixed
{
    return match (true) {
        isset($value['stringValue']) => $value['stringValue'],
        isset($value['integerValue']) => (int) $value['integerValue'],
        isset($value['doubleValue']) => (float) $value['doubleValue'],
        isset($value['booleanValue']) => $value['booleanValue'],
        isset($value['timestampValue']) => $value['timestampValue'],
        isset($value['arrayValue']) => array_map(
            fn ($v) => fs_value($v),
            $value['arrayValue']['values'] ?? []
        ),
        isset($value['mapValue']) => array_map(
            fn ($v) => fs_value($v),
            $value['mapValue']['fields'] ?? []
        ),
        default => null,
    };
}

function fs_field(array $doc, string $field): mixed
{
    $value = $doc['fields'][$field] ?? null;
    return $value === null ? null : fs_value($value);
}

/** Rango numérico del rol de un usuario (0 si no existe). */
function user_rank(string $uid): int
{
    $doc = firestore_get('users/' . rawurlencode($uid));
    if ($doc === null) {
        return 0;
    }
    $role = (string) (fs_field($doc, 'role') ?? 'invitado');
    return match ($role) {
        'admin' => 6,
        'presidente' => 5,
        'junta' => 4,
        'coordinador' => 3,
        'socio' => 2,
        default => 1,
    };
}

// ---------------------------------------------------------------------------
// FCM HTTP v1.
// ---------------------------------------------------------------------------

/** Envía una notificación push a un token. Devuelve false si es inválido. */
function fcm_send(string $token, string $title, string $body, array $data = []): bool
{
    $project = config()['firebase_project_id'];
    [$status] = http_post_json(
        "https://fcm.googleapis.com/v1/projects/$project/messages:send",
        [
            'message' => [
                'token' => $token,
                'notification' => ['title' => $title, 'body' => $body],
                'data' => array_map('strval', $data),
            ],
        ],
        ['Authorization: Bearer ' . google_access_token()]
    );
    return $status === 200;
}

/** Guarda una notificación en el buzón in-app del usuario. */
function inbox_add(string $uid, string $title, string $body, string $route = ''): void
{
    $id = bin2hex(random_bytes(10));
    firestore_patch(
        'notifications/' . rawurlencode($uid) . '/items/' . $id,
        [
            'title' => ['stringValue' => $title],
            'body' => ['stringValue' => $body],
            'type' => ['stringValue' => 'push'],
            'route' => ['stringValue' => $route],
            'read' => ['booleanValue' => false],
            'createdAt' => ['timestampValue' => gmdate('Y-m-d\TH:i:s\Z')],
        ]
    );
}
