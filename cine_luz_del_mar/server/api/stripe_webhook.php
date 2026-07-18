<?php

/**
 * Webhook de Stripe para las futuras suscripciones de socios.
 *
 * PREPARADO PERO DESACTIVADO: mientras 'stripe_enabled' sea false en
 * config.php este endpoint responde 503. Cuando la asociación active los
 * pagos: crear la cuenta de Stripe, configurar el webhook apuntando aquí,
 * poner el signing secret en config.php y completar los case del switch.
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
switch ($event['type'] ?? '') {
    case 'checkout.session.completed':
    case 'invoice.paid':
        // Al activar pagos: marcar la cuota del socio como pagada en
        // members/{uid}/fees/{año} a partir de client_reference_id.
        break;
    case 'customer.subscription.deleted':
        // Al activar pagos: registrar la baja de la suscripción.
        break;
}

json_response(200, ['received' => true]);
