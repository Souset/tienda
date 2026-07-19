# Puesta en marcha de Cine Luz del Mar

Guía completa para dejar la plataforma funcionando en producción con
**coste 0**: Firebase en plan Spark (sin tarjeta), archivos y tareas
programadas en tu hosting de Nicalia, y web en Firebase Hosting.

Tiempo estimado: 45–60 minutos. Necesitas: cuenta de Google, acceso al
cPanel de Nicalia y un ordenador con [Flutter](https://docs.flutter.dev/get-started/install)
y [Node.js](https://nodejs.org) instalados.

---

## 1. Crear el proyecto de Firebase (plan Spark)

1. Entra en [console.firebase.google.com](https://console.firebase.google.com)
   y pulsa **Añadir proyecto**. Nombre sugerido: `cine-luz-del-mar`.
2. Desactiva Google Analytics si no lo quieres (opcional).
3. El proyecto nace en plan **Spark (gratuito)**. **No actives Blaze**:
   nada de esta plataforma lo necesita.

### 1.1 Activar Authentication

En **Compilación → Authentication → Métodos de acceso** activa:

- **Correo electrónico/contraseña**.
- **Google** (elige el correo de soporte).
- *(Apple queda pendiente: requiere cuenta Apple Developer de pago;
  la app ya lo trae preparado tras un flag.)*

En **Configuración → Dominios autorizados** añade tu dominio de Nicalia si
vas a servir la web también desde allí.

### 1.2 Activar Firestore

En **Compilación → Firestore Database → Crear base de datos**, modo
**producción**, región `eur3 (europe-west)`.

### 1.3 Descargar la service account

En **Configuración del proyecto → Cuentas de servicio → Generar nueva
clave privada**. Guarda el JSON: lo usarás en Nicalia (paso 3) y para el
bootstrap del admin (paso 5). **Nunca lo subas al repositorio.**

## 2. Conectar la app Flutter al proyecto

Desde la raíz del repo:

```bash
dart pub global activate flutterfire_cli
cd cine_luz_del_mar/app
flutterfire configure --project=cine-luz-del-mar
```

Esto sustituye `lib/firebase_options.dart` (que trae valores demo para el
emulador) por el real, y coloca `google-services.json` (Android) y
`GoogleService-Info.plist` (iOS).

Ajusta la URL de tu API de Nicalia al compilar:

```bash
flutter build web --release --dart-define=API_BASE_URL=https://TU_DOMINIO/cine-api/api
flutter build apk --release --dart-define=API_BASE_URL=https://TU_DOMINIO/cine-api/api
```

### 2.1 Push en la web (opcional)

Para notificaciones push en el navegador: **Configuración del proyecto →
Cloud Messaging → Certificados push web → Generar par de claves**, y pasa
la clave pública con `--dart-define=FCM_VAPID_KEY=...`.

## 3. Desplegar la mini-API en Nicalia

1. Abre el **Administrador de archivos** del cPanel (o usa FTP) y crea la
   carpeta `cine-api` dentro de `public_html`.
2. Sube TODO el contenido de `cine_luz_del_mar/server/` a
   `public_html/cine-api/`.
3. Crea la carpeta de secretos FUERA del docroot: `/home/TU_USUARIO/secrets/`
   y sube ahí el JSON de la service account como `service-account.json`.
4. En `cine-api/lib/`, copia `config.sample.php` como `config.php` y edita:
   - `firebase_project_id`: el id real del proyecto.
   - `service_account_path`: `/home/TU_USUARIO/secrets/service-account.json`.
   - `allowed_origins`: añade `https://cine-luz-del-mar.web.app` y tu dominio.
   - `uploads_base_url`: `https://TU_DOMINIO/cine-api/uploads`.
   - `cron_secret`: una clave larga aleatoria.
5. Comprueba que `https://TU_DOMINIO/cine-api/api/upload.php` responde
   `{"error":"Falta el token de autenticación"}` → todo correcto.
6. Verifica que `https://TU_DOMINIO/cine-api/lib/config.php` devuelve
   **403 prohibido** (lo bloquea el `.htaccess`).

### 3.1 Cron de cPanel

En **cPanel → Trabajos de cron** añade (ajusta la ruta de PHP si tu
hosting usa otra, p. ej. `/usr/local/bin/php`):

```
0 9 * * *  /usr/local/bin/php /home/TU_USUARIO/public_html/cine-api/cron/recordatorios.php
0 6 1 1 *  /usr/local/bin/php /home/TU_USUARIO/public_html/cine-api/cron/generar_cuotas.php
```

## 4. Desplegar reglas, índices y web

```bash
npm install -g firebase-tools
firebase login
cd cine_luz_del_mar/firebase
firebase use --add        # elige cine-luz-del-mar
firebase deploy --only firestore:rules,firestore:indexes

cd ../app
flutter build web --release --dart-define=API_BASE_URL=https://TU_DOMINIO/cine-api/api
cd ../firebase
firebase deploy --only hosting
```

La web queda en `https://cine-luz-del-mar.web.app`.

## 5. Primer administrador

1. Abre la app y **regístrate** con tu correo (verifícalo desde el email
   que te llega).
2. En tu ordenador:

```bash
cd cine_luz_del_mar/scripts
npm install
GOOGLE_APPLICATION_CREDENTIALS=/ruta/al/service-account.json \
  node bootstrap_admin.mjs tu-correo@ejemplo.com
```

3. Cierra sesión y vuelve a entrar: ya verás el panel de administración.
   Desde ahí puedes dar roles al resto (presidente, junta, coordinador,
   socio) sin volver a usar scripts.

## 6. Asistente de IA (Gemini, capa gratuita)

En la consola de Firebase: **Compilación → AI Logic** y sigue el asistente
para habilitar la **Gemini Developer API** (capa gratuita, sin tarjeta).
No hay que copiar claves: el SDK `firebase_ai` de la app la usa
automáticamente al estar configurado el proyecto.

## 7. Android en Google Play (cuando quieras publicar)

- La cuenta de desarrollador de Google Play cuesta 25 $ una única vez
  (es el único coste opcional de toda la plataforma junto a Apple).
- Mientras tanto puedes distribuir el APK directamente:
  `flutter build apk --release` y comparte el archivo.

## 8. iOS (pendiente de cuenta Apple)

El proyecto compila para iOS, pero firmar y distribuir (y "Sign in with
Apple") requieren Apple Developer Program (99 $/año). Cuando la tengáis:
activa el flag `APPLE_SIGNIN_ENABLED=true` al compilar y añade la
capability en Xcode.

## 9. Stripe (futuro, cuando haya suscripciones)

1. Crea la cuenta en stripe.com (sin coste fijo).
2. En `config.php` de Nicalia: `stripe_enabled => true` y el
   `stripe_webhook_secret` del panel de Stripe.
3. Configura el webhook de Stripe apuntando a
   `https://TU_DOMINIO/cine-api/api/stripe_webhook.php`.
4. Completa los `case` marcados en ese archivo (cobro de cuotas).

## 10. Desarrollo local (emuladores, sin tocar producción)

```bash
cd cine_luz_del_mar/firebase/rules-tests && npm install
npx firebase emulators:start --project demo-cine-luz-del-mar
# En otra terminal, datos de ejemplo:
cd ../scripts && npm install
FIRESTORE_EMULATOR_HOST=localhost:8080 FIREBASE_AUTH_EMULATOR_HOST=localhost:9099 node seed.mjs
# Y la app contra los emuladores:
cd ../app && flutter run -d chrome --dart-define=USE_EMULATORS=true
```

Usuarios de ejemplo: `admin@cineluzdelmar.es`, `socia@cineluzdelmar.es`,
etc. (contraseña `CineLuz2026`).

---

## Resumen de costes

| Concepto | Coste |
|---|---|
| Firebase (Auth, Firestore, Hosting, FCM, AI Logic) | 0 € (plan Spark) |
| Archivos, push y cron | 0 € (tu hosting Nicalia ya pagado) |
| Mapas (OpenStreetMap) | 0 € |
| Web pública | 0 € |
| Google Play (opcional, único pago) | 25 $ |
| Apple Developer (opcional, anual) | 99 $ |
