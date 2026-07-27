// Asigna el rol de administrador al primer usuario (se ejecuta UNA vez).
//
// Uso contra el proyecto real (necesita la service account descargada):
//   GOOGLE_APPLICATION_CREDENTIALS=/ruta/service-account.json \
//     node bootstrap_admin.mjs correo@delusuario.com
//
// Uso contra la Emulator Suite (desarrollo):
//   FIRESTORE_EMULATOR_HOST=localhost:8080 \
//   FIREBASE_AUTH_EMULATOR_HOST=localhost:9099 \
//   GCLOUD_PROJECT=demo-cine-luz-del-mar \
//     node bootstrap_admin.mjs correo@delusuario.com
//
// El usuario debe haberse registrado antes en la app.

import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';

const email = process.argv[2];
if (!email) {
  console.error('Uso: node bootstrap_admin.mjs <email-del-usuario>');
  process.exit(1);
}

const usingEmulator = Boolean(process.env.FIRESTORE_EMULATOR_HOST);
initializeApp(
  usingEmulator
    ? { projectId: process.env.GCLOUD_PROJECT ?? 'demo-cine-luz-del-mar' }
    : { credential: applicationDefault() },
);

const auth = getAuth();
const db = getFirestore();

try {
  const user = await auth.getUserByEmail(email);
  await db.doc(`users/${user.uid}`).set(
    {
      role: 'admin',
      updatedAt: FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
  console.log(`✔ ${email} (${user.uid}) ahora es administrador.`);
} catch (error) {
  console.error(`✘ No se pudo asignar el rol: ${error.message}`);
  console.error('¿Se ha registrado ya este usuario en la app?');
  process.exit(1);
}
