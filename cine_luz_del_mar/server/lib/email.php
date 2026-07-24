<?php

/**
 * Correos transaccionales premium de Cine Luz del Mar.
 *
 * Genera HTML con la estética de la app (negro, caligrafía de la marca,
 * botón blanco) y envía desde el propio dominio a través del servidor de
 * correo del hosting (exim de cPanel firma DKIM automáticamente), con
 * parte de texto plano alternativa para una entregabilidad máxima.
 *
 * Requiere en config.php:
 *   'mail_from'      => 'no-responder@TU_DOMINIO'
 *   'mail_from_name' => 'Cine Luz del Mar'
 */

declare(strict_types=1);

require_once __DIR__ . '/common.php';

/** HTML completo del correo con la plantilla de la marca. */
function email_html(
    string $title,
    string $bodyHtml,
    string $ctaLabel = '',
    string $ctaUrl = ''
): string {
    $base = rtrim((string) (config()['app_base_url'] ?? 'https://cineluzdelmar.com'), '/');
    $logo = $base . '/assets/assets/brand/logo_wordmark_white.png';
    $year = date('Y');
    $t = htmlspecialchars($title, ENT_QUOTES, 'UTF-8');

    $cta = '';
    if ($ctaLabel !== '' && $ctaUrl !== '') {
        $u = htmlspecialchars($ctaUrl, ENT_QUOTES, 'UTF-8');
        $l = htmlspecialchars($ctaLabel, ENT_QUOTES, 'UTF-8');
        $cta = <<<HTML
        <table role="presentation" cellpadding="0" cellspacing="0" style="margin:32px auto 8px;">
          <tr><td style="border-radius:12px;background:#ffffff;">
            <a href="$u" style="display:inline-block;padding:15px 34px;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;color:#000000;text-decoration:none;border-radius:12px;">$l</a>
          </td></tr>
        </table>
        <p style="margin:16px 0 0;font-family:Helvetica,Arial,sans-serif;font-size:12px;line-height:1.6;color:#8c8c8c;text-align:center;">
          Si el botón no funciona, copia y pega este enlace en tu navegador:<br>
          <a href="$u" style="color:#a6a6a6;word-break:break-all;">$u</a>
        </p>
        HTML;
    }

    return <<<HTML
    <!doctype html>
    <html lang="es">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta name="color-scheme" content="dark">
      <title>$t</title>
    </head>
    <body style="margin:0;padding:0;background:#0a0a0a;">
      <div style="display:none;max-height:0;overflow:hidden;">$t</div>
      <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#0a0a0a;">
        <tr><td align="center" style="padding:40px 16px;">
          <table role="presentation" width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%;background:#000000;border:1px solid #2a2a2a;border-radius:18px;">
            <tr><td align="center" style="padding:44px 40px 8px;">
              <img src="$logo" width="250" alt="Cine Luz del Mar" style="display:block;max-width:250px;width:100%;height:auto;">
              <p style="margin:14px 0 0;font-family:Helvetica,Arial,sans-serif;font-size:11px;letter-spacing:3px;text-transform:uppercase;color:#8c8c8c;">Asociación cultural</p>
            </td></tr>
            <tr><td style="padding:28px 40px 8px;">
              <h1 style="margin:0 0 16px;font-family:Georgia,'Times New Roman',serif;font-weight:normal;font-size:26px;line-height:1.3;color:#ffffff;text-align:center;">$t</h1>
              <div style="font-family:Helvetica,Arial,sans-serif;font-size:15px;line-height:1.7;color:#d9d9d9;text-align:center;">
                $bodyHtml
              </div>
              $cta
            </td></tr>
            <tr><td style="padding:28px 40px 36px;">
              <hr style="border:none;border-top:1px solid #1e1e1e;margin:0 0 18px;">
              <p style="margin:0;font-family:Helvetica,Arial,sans-serif;font-size:12px;line-height:1.7;color:#6f6f6f;text-align:center;">
                Cine Luz del Mar · cine, cultura y educación audiovisual<br>
                Si no has solicitado este correo, puedes ignorarlo sin más.<br>
                © $year Cine Luz del Mar
              </p>
            </td></tr>
          </table>
        </td></tr>
      </table>
    </body>
    </html>
    HTML;
}

/**
 * Envía un correo con la plantilla de la marca (HTML + texto plano).
 * Devuelve false si el correo no está configurado o mail() falla.
 */
function send_branded_email(
    string $to,
    string $subject,
    string $title,
    string $bodyHtml,
    string $bodyText,
    string $ctaLabel = '',
    string $ctaUrl = ''
): bool {
    $from = (string) (config()['mail_from'] ?? '');
    $fromName = (string) (config()['mail_from_name'] ?? 'Cine Luz del Mar');
    if ($from === '' || !filter_var($to, FILTER_VALIDATE_EMAIL)) {
        return false;
    }

    $html = email_html($title, $bodyHtml, $ctaLabel, $ctaUrl);
    $text = $bodyText;
    if ($ctaUrl !== '') {
        $text .= "\n\n$ctaLabel:\n$ctaUrl";
    }
    $text .= "\n\n—\nCine Luz del Mar · Si no has solicitado este correo, ignóralo.";

    $boundary = 'clm-' . bin2hex(random_bytes(12));
    $encodedName = '=?UTF-8?B?' . base64_encode($fromName) . '?=';
    $headers = implode("\r\n", [
        "From: $encodedName <$from>",
        "Reply-To: $from",
        'MIME-Version: 1.0',
        "Content-Type: multipart/alternative; boundary=\"$boundary\"",
        'X-Mailer: CineLuzDelMar',
    ]);
    $body = implode("\r\n", [
        "--$boundary",
        'Content-Type: text/plain; charset=UTF-8',
        'Content-Transfer-Encoding: 8bit',
        '',
        $text,
        '',
        "--$boundary",
        'Content-Type: text/html; charset=UTF-8',
        'Content-Transfer-Encoding: 8bit',
        '',
        $html,
        '',
        "--$boundary--",
    ]);
    $encodedSubject = '=?UTF-8?B?' . base64_encode($subject) . '?=';

    // -f fija el remitente del sobre (Return-Path): clave para SPF/DKIM.
    return mail($to, $encodedSubject, $body, $headers, '-f' . $from);
}

/**
 * Pide a Firebase el enlace de acción (verificación o recuperación) sin
 * que Firebase envíe su propio correo. Devuelve '' si falla.
 *
 * $type: VERIFY_EMAIL | PASSWORD_RESET
 */
function firebase_action_link(string $type, string $email): string
{
    $base = rtrim((string) (config()['app_base_url'] ?? 'https://cineluzdelmar.com'), '/');
    [$status, $response] = http_post_json(
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode',
        [
            'requestType' => $type,
            'email' => $email,
            'returnOobLink' => true,
            'continueUrl' => $base . '/',
        ],
        ['Authorization: Bearer ' . google_access_token()]
    );
    if ($status !== 200) {
        return '';
    }
    return (string) ($response['oobLink'] ?? '');
}
