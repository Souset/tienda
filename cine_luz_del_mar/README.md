# Cine Luz del Mar

Plataforma de la asociación cultural **Cine Luz del Mar**: agenda de
proyecciones, talleres y festivales con reserva de plaza, comunidad
cinéfila, biblioteca de recursos, gestión de socios con carné digital,
chat, mapa de actividades, asistente de IA y panel de administración.

Apps para **Android, iOS y Web** construidas con Flutter y Firebase, con
coste de infraestructura cero (plan Spark + hosting propio en Nicalia).

## Estructura

| Carpeta | Contenido |
|---|---|
| `app/` | Aplicación Flutter (Clean Architecture + Riverpod) |
| `server/` | Mini-API PHP para el hosting de Nicalia (subidas, push, cron) |
| `firebase/` | Reglas de seguridad, índices y tests contra el emulador |
| `scripts/` | Bootstrap del primer admin y datos de ejemplo |
| `assets_brand/` | Logotipo vectorial, icono y splash |
| `docs/` | Guía de puesta en marcha (SETUP.md) y marca |

## Desarrollo rápido

```bash
cd app
flutter pub get
flutter run -d chrome --dart-define=USE_EMULATORS=true
```

Con la Firebase Emulator Suite levantada desde `firebase/`:

```bash
cd firebase
npx firebase emulators:start --project demo-cine-luz-del-mar
```

## Puesta en producción

Sigue `docs/SETUP.md`: configuración de Firebase (plan Spark, sin
tarjeta), despliegue de la mini-API en Nicalia y alta del primer
administrador.

## Tema

Identidad monocroma blanco y negro heredada del logotipo caligráfico:
modo oscuro por defecto (sala de cine) y modo claro invertido.
