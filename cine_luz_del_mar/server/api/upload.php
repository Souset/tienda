<?php

/**
 * Subida de archivos (imágenes y PDF) al hosting de Nicalia.
 *
 * POST multipart/form-data:
 *   - Authorization: Bearer <ID token de Firebase>
 *   - file: el archivo
 *   - folder: avatars | posts | covers | library | certificates
 *
 * Respuesta: { "url": "https://.../uploads/<folder>/<nombre>" }
 *
 * El rango mínimo por carpeta se define en config.php (upload_folders).
 */

declare(strict_types=1);

require __DIR__ . '/../lib/common.php';

apply_cors();

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_error(405, 'Método no permitido');
}

$claims = require_auth();
$uid = (string) $claims['sub'];

$config = config();
$folder = (string) ($_POST['folder'] ?? '');
$folders = $config['upload_folders'];
if (!isset($folders[$folder])) {
    json_error(400, 'Carpeta de destino no válida');
}
if (user_rank($uid) < $folders[$folder]) {
    json_error(403, 'No tienes permisos para subir a esta carpeta');
}

$file = $_FILES['file'] ?? null;
if ($file === null || ($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
    json_error(400, 'No se recibió ningún archivo válido');
}
if ($file['size'] > $config['upload_max_bytes']) {
    json_error(413, 'El archivo supera el tamaño máximo permitido');
}

// El tipo se determina por contenido real, nunca por la extensión declarada.
$finfo = new finfo(FILEINFO_MIME_TYPE);
$mime = (string) $finfo->file($file['tmp_name']);
$allowed = $config['upload_allowed_mime'];
if (!isset($allowed[$mime])) {
    json_error(415, 'Tipo de archivo no permitido');
}

$extension = $allowed[$mime];
$name = date('Ymd') . '-' . bin2hex(random_bytes(12)) . '.' . $extension;
$dir = rtrim((string) $config['uploads_dir'], '/') . '/' . $folder;
if (!is_dir($dir) && !mkdir($dir, 0755, true)) {
    json_error(500, 'No se pudo preparar la carpeta de destino');
}
$dest = $dir . '/' . $name;
if (!move_uploaded_file($file['tmp_name'], $dest)) {
    json_error(500, 'No se pudo guardar el archivo');
}
chmod($dest, 0644);

$url = rtrim((string) $config['uploads_base_url'], '/') . "/$folder/$name";
json_response(200, ['url' => $url]);
