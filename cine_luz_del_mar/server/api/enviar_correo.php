<?php

/**
 * Envío de correos de cuenta con la plantilla premium de la marca.
 *
 * POST application/json:
 *   { "tipo": "verificacion" }             (requiere Bearer ID token)
 *   { "tipo": "recuperar", "email": "…" }  (sin sesión; no revela si la
 *                                           cuenta existe y va limitado
 *                                           por IP para evitar abusos)
 *
 * Firebase solo genera el ENLACE de acción; el correo lo envía este
 * servidor desde el dominio propio (SPF/DKIM del hosting) con diseño
 * acorde a la app. Respuesta: { "enviado": true }
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';
require __DIR__ . '/../lib/email.php';

apply_cors();

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_error(405, 'Método no permitido');
}
if ((string) (config()['mail_from'] ?? '') === '') {
    json_error(503, 'El correo del servidor no está configurado');
}

/** Límite sencillo por IP: máx. 8 envíos por hora. */
function rate_limit(string $bucket): void
{
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'desconocida';
    $file = sys_get_temp_dir() . '/clm_mail_' . md5($bucket . '|' . $ip);
    $hits = [];
    if (is_file($file)) {
        $hits = array_filter(
            json_decode((string) file_get_contents($file), true) ?? [],
            fn ($t) => $t > time() - 3600
        );
    }
    if (count($hits) >= 8) {
        json_error(429, 'Demasiados envíos: inténtalo de nuevo en un rato');
    }
    $hits[] = time();
    file_put_contents($file, json_encode(array_values($hits)));
}

$input = json_decode((string) file_get_contents('php://input'), true) ?? [];
$tipo = (string) ($input['tipo'] ?? '');

if ($tipo === 'verificacion') {
    $claims = require_auth();
    $email = (string) ($claims['email'] ?? '');
    if ($email === '') {
        json_error(400, 'Tu cuenta no tiene correo asociado');
    }
    if (($claims['email_verified'] ?? false) === true) {
        json_error(409, 'Tu correo ya está verificado');
    }
    rate_limit('verificacion');

    $link = firebase_action_link('VERIFY_EMAIL', $email);
    if ($link === '') {
        json_error(502, 'No se pudo generar el enlace de verificación');
    }
    $ok = send_branded_email(
        $email,
        'Verifica tu correo · Cine Luz del Mar',
        'Confirma tu correo electrónico',
        'Ya casi está. Pulsa el botón para confirmar que este correo es '
            . 'tuyo y desbloquear todo: reservas, comunidad, valoraciones '
            . 'y tu carné de socio.',
        'Confirma tu correo para activar tu cuenta de Cine Luz del Mar.',
        'Verificar mi correo',
        $link
    );
    if (!$ok) {
        json_error(502, 'No se pudo enviar el correo');
    }
    json_response(200, ['enviado' => true]);
}

if ($tipo === 'recuperar') {
    $email = trim((string) ($input['email'] ?? ''));
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        json_error(400, 'Indica un correo válido');
    }
    rate_limit('recuperar');

    // Si la cuenta no existe, respondemos igual que si existiera: no se
    // debe poder averiguar qué correos están registrados.
    $link = firebase_action_link('PASSWORD_RESET', $email);
    if ($link !== '') {
        send_branded_email(
            $email,
            'Restablece tu contraseña · Cine Luz del Mar',
            'Restablece tu contraseña',
            'Hemos recibido una petición para cambiar tu contraseña. '
                . 'Pulsa el botón y elige una nueva. El enlace caduca '
                . 'pronto por seguridad.',
            'Restablece tu contraseña de Cine Luz del Mar con este enlace.',
            'Elegir nueva contraseña',
            $link
        );
    }
    json_response(200, ['enviado' => true]);
}

json_error(400, 'Tipo de correo no válido');
