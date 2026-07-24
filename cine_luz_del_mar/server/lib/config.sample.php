<?php

/**
 * Configuración de la mini-API de Cine Luz del Mar.
 *
 * INSTALACIÓN (ver docs/SETUP.md):
 *   1. Copia este archivo como config.php en esta misma carpeta (lib/).
 *   2. Sube el JSON de la service account de Firebase FUERA del docroot
 *      (p. ej. /home/TU_USUARIO/secrets/service-account.json) y ajusta la ruta.
 *   3. Ajusta el dominio de la app web para CORS y la URL pública de uploads.
 */

return [
    // Proyecto de Firebase (el id que muestra la consola).
    'firebase_project_id' => 'cine-luz-del-mar',

    // Ruta ABSOLUTA al JSON de la service account (fuera del docroot).
    'service_account_path' => '/home/TU_USUARIO/secrets/service-account.json',

    // Orígenes permitidos para CORS (la web de la app y localhost de desarrollo).
    'allowed_origins' => [
        'https://cine-luz-del-mar.web.app',
        'https://cine-luz-del-mar.firebaseapp.com',
        'http://localhost:5000',
    ],

    // Carpeta física donde se guardan los archivos subidos y su URL pública.
    'uploads_dir' => __DIR__ . '/../uploads',
    'uploads_base_url' => 'https://TU_DOMINIO/cine-api/uploads',

    // Límite de subida en bytes (10 MB) y tipos permitidos.
    'upload_max_bytes' => 10 * 1024 * 1024,
    'upload_allowed_mime' => [
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'image/webp' => 'webp',
        'application/pdf' => 'pdf',
    ],

    // Carpetas de subida y rango mínimo requerido para escribir en cada una.
    // Rangos: admin=6, presidente=5, junta=4, coordinador=3, socio=2, invitado=1.
    'upload_folders' => [
        'avatars' => 1,
        'posts' => 2,
        'covers' => 3,
        'library' => 3,
        'certificates' => 3,
    ],

    // Clave secreta para ejecutar los cron por HTTP además de CLI (opcional).
    // Genera una larga y aleatoria: bin2hex(random_bytes(32)).
    'cron_secret' => 'CAMBIA_ESTA_CLAVE',

    // URL pública de la app (para las redirecciones de vuelta tras el pago).
    'app_base_url' => 'https://TU_DOMINIO',

    // Correos premium desde el propio dominio (verificación, recuperación,
    // bienvenida de socio). Crea la cuenta en cPanel → Cuentas de correo.
    'mail_from' => 'no-responder@TU_DOMINIO',
    'mail_from_name' => 'Cine Luz del Mar',

    // Pagos con Stripe (cuotas de socio).
    //   1. Crea tu cuenta gratuita en https://dashboard.stripe.com/register
    //   2. Copia la clave secreta (sk_live_... o sk_test_...) en
    //      stripe_secret_key.
    //   3. Crea un webhook apuntando a
    //      https://TU_DOMINIO/cine-api/api/stripe_webhook.php con el evento
    //      checkout.session.completed y copia su signing secret (whsec_...).
    //   4. Pon stripe_enabled en true.
    'stripe_enabled' => false,
    'stripe_secret_key' => '',
    'stripe_webhook_secret' => '',
];
