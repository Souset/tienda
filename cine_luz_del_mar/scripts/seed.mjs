// Datos de ejemplo para desarrollo y demos (pensado para la Emulator Suite).
//
// Uso:
//   FIRESTORE_EMULATOR_HOST=localhost:8080 \
//   FIREBASE_AUTH_EMULATOR_HOST=localhost:9099 \
//   GCLOUD_PROJECT=demo-cine-luz-del-mar node seed.mjs
//
// Crea usuarios de cada rol (contraseña: CineLuz2026), noticias, eventos con
// plazas, películas con valoraciones, biblioteca, socios con cuotas, un chat
// y la configuración de la home.

import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';

if (!process.env.FIRESTORE_EMULATOR_HOST) {
  console.error('Este script está pensado para la Emulator Suite.');
  console.error('Define FIRESTORE_EMULATOR_HOST (y FIREBASE_AUTH_EMULATOR_HOST).');
  process.exit(1);
}

initializeApp({ projectId: process.env.GCLOUD_PROJECT ?? 'demo-cine-luz-del-mar' });
const auth = getAuth();
const db = getFirestore();

const PASSWORD = 'CineLuz2026';

// Tokens de búsqueda por prefijos (igual que lib/core/utils/search_tokens.dart).
const tokens = (...fields) => {
  const out = new Set();
  for (const field of fields) {
    const words = field
      .toLowerCase()
      .normalize('NFD')
      .replace(/[̀-ͯ]/g, '')
      .split(/[^a-z0-9]+/)
      .filter((w) => w.length >= 2);
    for (const word of words) {
      for (let end = 2; end <= Math.min(word.length, 15); end++) {
        out.add(word.slice(0, end));
      }
    }
  }
  return [...out].sort();
};

const now = Timestamp.now();
const days = (n) => Timestamp.fromMillis(Date.now() + n * 86400000);

const users = [
  ['admin@cineluzdelmar.es', 'Alba Directora', 'admin'],
  ['presidencia@cineluzdelmar.es', 'Pau Presidente', 'presidente'],
  ['junta@cineluzdelmar.es', 'Júlia de la Junta', 'junta'],
  ['coordinacion@cineluzdelmar.es', 'Carla Coordinadora', 'coordinador'],
  ['socia@cineluzdelmar.es', 'Sofía Socia', 'socio'],
  ['socio2@cineluzdelmar.es', 'Marc Socio', 'socio'],
  ['invitado@cineluzdelmar.es', 'Iris Invitada', 'invitado'],
];

console.log('Creando usuarios…');
const uids = {};
for (const [email, displayName, role] of users) {
  let user;
  try {
    user = await auth.getUserByEmail(email);
  } catch {
    user = await auth.createUser({
      email,
      password: PASSWORD,
      displayName,
      emailVerified: true,
    });
  }
  uids[role] = uids[role] ?? user.uid;
  await db.doc(`users/${user.uid}`).set({
    displayName,
    email,
    role,
    bio: role === 'socio' ? 'Cinéfila de sesión doble y palomitas.' : null,
    favoriteGenres: ['drama', 'clásico'],
    fcmTokens: [],
    favoriteFilms: [],
    favoriteEvents: [],
    favoriteResources: [],
    searchTokens: tokens(displayName, email),
    createdAt: now,
    updatedAt: now,
  });
}

console.log('Creando películas…');
const films = [
  ['luces-de-la-ciudad', 'Luces de la ciudad', 1931, 'Charles Chaplin', 'Un vagabundo se enamora de una florista ciega y hará lo imposible por ayudarla.', 4.8, 12],
  ['el-faro', 'El faro', 2019, 'Robert Eggers', 'Dos fareros pierden la cordura en una isla remota de Nueva Inglaterra.', 4.1, 8],
  ['verano-1993', 'Verano 1993', 2017, 'Carla Simón', 'Tras la muerte de su madre, Frida pasa su primer verano con su nueva familia.', 4.4, 15],
  ['cinema-paradiso', 'Cinema Paradiso', 1988, 'Giuseppe Tornatore', 'La historia de amor entre un niño, un proyeccionista y el cine.', 4.9, 21],
];
for (const [id, title, year, director, synopsis, avgRating, ratingsCount] of films) {
  await db.doc(`films/${id}`).set({
    title,
    year,
    director,
    synopsis,
    posterUrl: null,
    genres: ['clásico'],
    avgRating,
    ratingsCount,
    featured: true,
    searchTokens: tokens(title, director),
    createdAt: now,
    updatedAt: now,
  });
}

console.log('Creando eventos…');
const events = [
  ['proyeccion-luces', 'proyeccion', 'Proyección: Luces de la ciudad', 'Sesión especial con presentación y coloquio posterior.', 3, 60, 'luces-de-la-ciudad'],
  ['taller-guion', 'taller', 'Taller de guion cinematográfico', 'Cuatro sesiones prácticas para escribir tu primer cortometraje.', 7, 20, null],
  ['charla-carla-simon', 'charla', 'Charla: el cine de Carla Simón', 'Un recorrido por la mirada íntima del nuevo cine catalán.', 12, 80, 'verano-1993'],
  ['festival-luz-del-mar', 'festival', 'Festival Luz del Mar 2026', 'Tres días de cine junto al mar: estrenos, clásicos y cortos locales.', 30, 200, null],
];
for (const [id, type, title, description, inDays, capacity, filmId] of events) {
  await db.doc(`events/${id}`).set({
    type,
    title,
    description,
    start: days(inDays),
    end: days(inDays),
    venue: {
      name: 'Casa de Cultura',
      address: 'Passeig del Mar, 12',
      lat: 39.9647,
      lng: 4.0818,
      geohash: 'eyd52dq1e',
    },
    capacity,
    reservedCount: 0,
    coverUrl: null,
    filmId,
    status: 'published',
    featured: true,
    searchTokens: tokens(title, type),
    createdAt: now,
    updatedAt: now,
  });
}

console.log('Creando noticias…');
const news = [
  ['nueva-temporada', 'Arranca la nueva temporada de proyecciones', 'Este trimestre recuperamos los clásicos del cine mudo con música en directo. Todas las sesiones serán en la Casa de Cultura, con entrada libre para socios.'],
  ['convocatoria-cortos', 'Abierta la convocatoria de cortometrajes', 'El Festival Luz del Mar 2026 abre su convocatoria de cortos. Si tienes una historia que contar frente al mar, este es tu festival: envíanos tu pieza antes del 30 de septiembre.'],
  ['nuevo-local', 'Estrenamos sala de montaje para socios', 'Gracias al acuerdo con el ayuntamiento, los socios ya pueden reservar la nueva sala de montaje con equipo de edición profesional.'],
];
news.forEach(async ([id, title, body], i) => {
  await db.doc(`news/${id}`).set({
    title,
    body,
    coverUrl: null,
    tags: ['asociación'],
    featured: i === 0,
    status: 'published',
    publishedAt: days(-i - 1),
    authorUid: uids.coordinador,
    searchTokens: tokens(title),
    createdAt: now,
    updatedAt: now,
  });
});

console.log('Creando biblioteca…');
const library = [
  ['guia-analisis', 'document', 'Guía de análisis fílmico', 'Cuaderno de trabajo para los cinefórums.', 'educación', 'invitado'],
  ['podcast-t01', 'podcast', 'Podcast Luz del Mar · T01', 'Temporada completa de nuestro podcast sobre clásicos.', 'podcast', 'invitado'],
  ['masterclass-luz', 'video', 'Masterclass: la luz en el cine', 'Grabación de la masterclass de iluminación (solo socios).', 'formación', 'socio'],
];
for (const [id, type, title, description, category, minRole] of library) {
  await db.doc(`library/${id}`).set({
    type,
    title,
    description,
    url: 'https://example.org/recurso',
    category,
    coverUrl: null,
    minRole,
    searchTokens: tokens(title, category),
    createdAt: now,
    updatedAt: now,
  });
}

console.log('Creando socios y cuotas…');
let n = 1;
for (const role of ['presidente', 'junta', 'coordinador', 'socio']) {
  const uid = uids[role];
  await db.doc(`members/${uid}`).set({
    memberNumber: n,
    status: 'active',
    joinedAt: days(-400),
    benefits: ['Entrada libre a proyecciones', 'Descuento en talleres'],
    createdAt: now,
    updatedAt: now,
  });
  await db.doc(`members/${uid}/fees/2026`).set({
    amount: 20,
    status: n % 2 === 0 ? 'pending' : 'paid',
    paidAt: n % 2 === 0 ? null : days(-30),
    method: n % 2 === 0 ? null : 'transferencia',
  });
  n++;
}
await db.doc('counters/members').set({ value: n - 1 });

console.log('Creando packs de socio…');
const packs = [
  ['joven', 'Socio Joven', 'Para menores de 30 años y estudiantes.', 15, false],
  ['general', 'Socio General', 'La cuota clásica de la asociación.', 25, true],
  ['familiar', 'Socio Familiar', 'Dos personas adultas y menores a cargo.', 40, false],
  ['protector', 'Socio Protector', 'Para quienes quieren apoyar más al cine.', 60, false],
];
let orden = 0;
for (const [id, name, description, price, highlight] of packs) {
  await db.doc(`membership_plans/${id}`).set({
    name,
    description,
    price,
    period: 'anual',
    benefits: [
      'Entrada libre a todas las proyecciones',
      'Descuento en talleres',
      'Carné digital y boletín semanal',
    ],
    active: true,
    highlight,
    order: orden++,
    createdAt: now,
    updatedAt: now,
  });
}

console.log('Creando comunidad…');
await db.doc('posts/bienvenida').set({
  authorUid: uids.socio,
  authorName: 'Sofía Socia',
  authorPhotoUrl: null,
  text: '¡Qué ganas de la proyección de Chaplin! ¿Alguien más va el sábado?',
  imageUrls: [],
  likesCount: 2,
  commentsCount: 1,
  visibility: 'members',
  createdAt: days(-1),
  updatedAt: days(-1),
});
await db.doc('posts/bienvenida/comments/c1').set({
  authorUid: uids.coordinador,
  authorName: 'Carla Coordinadora',
  text: '¡Allí nos vemos! Habrá coloquio al final.',
  createdAt: now,
});

console.log('Creando chat…');
await db.doc('chats/demo').set({
  type: 'direct',
  memberUids: [uids.socio, uids.coordinador],
  name: null,
  lastMessageText: '¡Nos vemos en la proyección!',
  lastMessageSenderUid: uids.coordinador,
  lastMessageAt: now,
  createdAt: now,
});
await db.doc('chats/demo/messages/m1').set({
  senderUid: uids.socio,
  text: 'Hola, ¿queda plaza en el taller de guion?',
  readBy: [uids.socio, uids.coordinador],
  createdAt: days(-1),
});
await db.doc('chats/demo/messages/m2').set({
  senderUid: uids.coordinador,
  text: '¡Nos vemos en la proyección!',
  readBy: [uids.coordinador],
  createdAt: now,
});

console.log('Configurando la home…');
await db.doc('app_config/home').set({
  bannerTitle: 'Festival Luz del Mar 2026',
  bannerSubtitle: 'Tres días de cine junto al mar · Entradas ya disponibles',
  bannerImageUrl: null,
  bannerRoute: '/agenda',
  featuredFilmIds: films.map(([id]) => id),
  featuredEventIds: events.map(([id]) => id),
  featuredNewsIds: news.map(([id]) => id),
});
await db.doc('app_config/features').set({ feeAmount: 20 });

console.log(`✔ Datos de ejemplo creados. Contraseña de todos los usuarios: ${PASSWORD}`);
