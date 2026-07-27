<?php

/**
 * Crea una sesión de pago de Stripe Checkout para una cuota de socio.
 *
 * POST JSON: { "planId": "<id del pack en membership_plans>" }
 * Respuesta: { "url": "https://checkout.stripe.com/..." }
 *
 * El importe se lee SIEMPRE del pack en Firestore (nunca del cliente) y el
 * cobro se confirma en stripe_webhook.php, que es quien marca la cuota como
 * pagada y da de alta al socio. Aquí solo se prepara la sesión.
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

apply_cors();

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_error(405, 'Método no permitido');
}
if (!config()['stripe_enabled']
    || (string) (config()['stripe_secret_key'] ?? '') === ''
) {
    json_error(503, 'Los pagos online aún no están activados');
}

$claims = require_auth();
$uid = (string) $claims['sub'];

$input = json_decode((string) file_get_contents('php://input'), true) ?? [];
$planId = trim((string) ($input['planId'] ?? ''));
if ($planId === '' || preg_match('/[^A-Za-z0-9_-]/', $planId)) {
    json_error(400, 'Falta el pack de socio (planId)');
}

$plan = firestore_get('membership_plans/' . rawurlencode($planId));
if ($plan === null || fs_field($plan, 'active') !== true) {
    json_error(404, 'Ese pack de socio no está disponible');
}

$name = (string) (fs_field($plan, 'name') ?? 'Cuota de socio');
$period = (string) (fs_field($plan, 'period') ?? 'anual');
$price = (float) (fs_field($plan, 'price') ?? 0);
$cents = (int) round($price * 100);
if ($cents < 50) {
    // Stripe no admite cargos por debajo de ~0,50 €.
    json_error(400, 'El pack tiene un precio no válido');
}

// Identificador de la cuota que cubre este pago: año (anual/única) o mes.
$feeId = $period === 'mensual' ? date('Y-m') : date('Y');

// Evita cobrar dos veces la misma cuota ya pagada.
$fee = firestore_get('members/' . rawurlencode($uid) . '/fees/' . $feeId);
if ($fee !== null && fs_field($fee, 'status') === 'paid') {
    json_error(409, 'Ya tienes pagada la cuota de ' . $feeId);
}

$base = rtrim((string) (config()['app_base_url'] ?? 'https://cineluzdelmar.com'), '/');
$concept = 'Cuota de socio · ' . $name . ' · ' . $feeId;

$email = (string) ($claims['email'] ?? '');

[$status, $session] = http_post_form(
    'https://api.stripe.com/v1/checkout/sessions',
    [
        'mode' => 'payment',
        'locale' => 'es',
        // Algunas cuentas (p. ej. teléfono) no tienen email en el token:
        // en ese caso Stripe lo pedirá en el propio Checkout.
        ...($email === '' ? [] : ['customer_email' => $email]),
        'client_reference_id' => $uid,
        'line_items' => [[
            'quantity' => 1,
            'price_data' => [
                'currency' => 'eur',
                'unit_amount' => $cents,
                'product_data' => ['name' => $concept],
            ],
        ]],
        'metadata' => [
            'uid' => $uid,
            'planId' => $planId,
            'planName' => $name,
            'period' => $period,
            'feeId' => $feeId,
        ],
        'success_url' => $base
            . '/#/socio/pago-ok?session_id={CHECKOUT_SESSION_ID}',
        'cancel_url' => $base . '/#/socio/pago-cancelado',
    ],
    ['Authorization: Bearer ' . config()['stripe_secret_key']]
);

if ($status !== 200 || empty($session['url'])) {
    $detail = $session['error']['message'] ?? 'sin respuesta de Stripe';
    json_error(502, 'No se pudo iniciar el pago (' . $detail . ')');
}

json_response(200, ['url' => $session['url']]);
