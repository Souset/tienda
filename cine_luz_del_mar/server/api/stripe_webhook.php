<?php

/**
 * Webhook de Stripe: confirma los pagos de cuotas de socio.
 *
 * Configurar en el dashboard de Stripe un webhook apuntando aquí con el
 * evento `checkout.session.completed` y copiar su signing secret en
 * lib/config.php ('stripe_webhook_secret').
 *
 * Al confirmarse un pago:
 *   1. Da de alta al socio si aún no lo es (número correlativo atómico).
 *   2. Guarda el pack elegido y sus ventajas en members/{uid}.
 *   3. Marca la cuota del periodo como pagada (método 'stripe').
 *   4. Asciende al usuario a rol 'socio' si era invitado.
 *   5. Notifica al socio (buzón in-app + push).
 *
 * Es idempotente: cada sesión de Checkout se procesa una sola vez
 * (marcador en stripe_payments/{sessionId}, colección solo de servidor).
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

if (!config()['stripe_enabled']) {
    json_error(503, 'Los pagos no están activados');
}

$payload = (string) file_get_contents('php://input');
$signature = $_SERVER['HTTP_STRIPE_SIGNATURE'] ?? '';

// Verificación de firma del webhook (esquema v1 de Stripe).
$secret = (string) config()['stripe_webhook_secret'];
$valid = false;
if (preg_match('/t=(\d+),v1=([a-f0-9]+)/', $signature, $m)) {
    $expected = hash_hmac('sha256', $m[1] . '.' . $payload, $secret);
    $valid = hash_equals($expected, $m[2])
        && abs(time() - (int) $m[1]) < 300;
}
if (!$valid) {
    json_error(400, 'Firma de webhook inválida');
}

$event = json_decode($payload, true) ?? [];
if (($event['type'] ?? '') !== 'checkout.session.completed') {
    json_response(200, ['received' => true, 'ignored' => $event['type'] ?? '']);
}

$session = $event['data']['object'] ?? [];
if (($session['payment_status'] ?? '') !== 'paid') {
    json_response(200, ['received' => true, 'ignored' => 'no pagada']);
}

$sessionId = (string) ($session['id'] ?? '');
$meta = $session['metadata'] ?? [];
$uid = (string) ($meta['uid'] ?? $session['client_reference_id'] ?? '');
$planId = (string) ($meta['planId'] ?? '');
$planName = (string) ($meta['planName'] ?? 'Cuota de socio');
$planPeriod = (string) ($meta['period'] ?? 'anual');
$feeId = (string) ($meta['feeId'] ?? date('Y'));
$amount = ((int) ($session['amount_total'] ?? 0)) / 100;

if ($sessionId === '' || $uid === '') {
    json_error(400, 'Sesión sin uid: no procede de crear_pago.php');
}

// Idempotencia: si esta sesión ya se procesó, responder OK sin repetir nada.
if (firestore_get('stripe_payments/' . rawurlencode($sessionId)) !== null) {
    json_response(200, ['received' => true, 'duplicated' => true]);
}

$now = gmdate('Y-m-d\TH:i:s\Z');

// Ventajas del pack (para reflejarlas en el carné del socio).
$benefits = [];
if ($planId !== '') {
    $plan = firestore_get('membership_plans/' . rawurlencode($planId));
    if ($plan !== null) {
        $benefits = array_values(array_filter(array_map(
            fn ($b) => (string) $b,
            (array) (fs_field($plan, 'benefits') ?? [])
        )));
    }
}
$benefitValues = ['arrayValue' => ['values' => array_map(
    fn ($b) => ['stringValue' => $b],
    $benefits
)]];

// 1) Alta de socio si no existe, con número correlativo (commit atómico con
//    precondiciones y reintentos ante escrituras concurrentes del contador).
$memberPath = 'members/' . rawurlencode($uid);
$member = firestore_get($memberPath);
if ($member === null) {
    $alta = false;
    for ($try = 0; $try < 5 && !$alta; $try++) {
        $counter = firestore_get('counters/members');
        $next = ($counter === null ? 0 : (int) (fs_field($counter, 'value') ?? 0)) + 1;
        $counterWrite = [
            'update' => [
                'name' => fs_doc_name('counters/members'),
                'fields' => ['value' => ['integerValue' => (string) $next]],
            ],
            'currentDocument' => $counter === null
                ? ['exists' => false]
                : ['updateTime' => $counter['updateTime']],
        ];
        $memberWrite = [
            'update' => [
                'name' => fs_doc_name($memberPath),
                'fields' => [
                    'memberNumber' => ['integerValue' => (string) $next],
                    'status' => ['stringValue' => 'active'],
                    'planId' => ['stringValue' => $planId],
                    'planName' => ['stringValue' => $planName],
                    'planPeriod' => ['stringValue' => $planPeriod],
                    'benefits' => $benefitValues,
                    'joinedAt' => ['timestampValue' => $now],
                    'createdAt' => ['timestampValue' => $now],
                    'updatedAt' => ['timestampValue' => $now],
                ],
            ],
            'currentDocument' => ['exists' => false],
        ];
        [$status] = firestore_commit([$counterWrite, $memberWrite]);
        $alta = $status === 200;
        if (!$alta && firestore_get($memberPath) !== null) {
            break; // Otro proceso lo dio de alta a la vez: continuar.
        }
    }
    if (!$alta && firestore_get($memberPath) === null) {
        // Stripe reintentará el webhook al recibir un error.
        json_error(500, 'No se pudo dar de alta al socio');
    }
} else {
    // Renovación o cambio de pack: reactivar y actualizar el pack. Si la
    // escritura falla se responde error para que Stripe reintente.
    $ok = firestore_patch($memberPath, [
        'status' => ['stringValue' => 'active'],
        'planId' => ['stringValue' => $planId],
        'planName' => ['stringValue' => $planName],
        'planPeriod' => ['stringValue' => $planPeriod],
        'benefits' => $benefitValues,
        'updatedAt' => ['timestampValue' => $now],
    ], ['status', 'planId', 'planName', 'planPeriod', 'benefits', 'updatedAt']);
    if (!$ok) {
        json_error(500, 'No se pudo actualizar la ficha del socio');
    }
}

// 2) Cuota del periodo pagada (crítico: si falla, Stripe reintentará).
$ok = firestore_patch($memberPath . '/fees/' . rawurlencode($feeId), [
    'amount' => ['doubleValue' => $amount],
    'status' => ['stringValue' => 'paid'],
    'method' => ['stringValue' => 'stripe'],
    'planId' => ['stringValue' => $planId],
    'planName' => ['stringValue' => $planName],
    'stripeSessionId' => ['stringValue' => $sessionId],
    'paidAt' => ['timestampValue' => $now],
]);
if (!$ok) {
    json_error(500, 'No se pudo registrar la cuota pagada');
}

// 3) Ascenso a socio (solo desde invitado: nunca degradar roles superiores).
$user = firestore_get('users/' . rawurlencode($uid));
if ($user !== null && (fs_field($user, 'role') ?? 'invitado') === 'invitado') {
    firestore_patch(
        'users/' . rawurlencode($uid),
        ['role' => ['stringValue' => 'socio']],
        ['role']
    );
}

// 4) Marcador de idempotencia (colección accesible solo desde el servidor).
firestore_patch('stripe_payments/' . rawurlencode($sessionId), [
    'uid' => ['stringValue' => $uid],
    'planId' => ['stringValue' => $planId],
    'feeId' => ['stringValue' => $feeId],
    'amount' => ['doubleValue' => $amount],
    'createdAt' => ['timestampValue' => $now],
]);

// 5) Aviso al socio: buzón in-app + push a sus dispositivos.
$title = '¡Bienvenido/a, socio/a!';
$body = 'Pago recibido: ' . $planName . ' ('
    . number_format($amount, 2, ',', '.') . ' €). Tu carné ya está listo.';
inbox_add($uid, $title, $body, '/carne');
if ($user !== null) {
    foreach ((array) (fs_field($user, 'fcmTokens') ?? []) as $token) {
        fcm_send((string) $token, $title, $body, ['route' => '/carne']);
    }
}

json_response(200, ['received' => true, 'uid' => $uid, 'fee' => $feeId]);
