// Tests de las reglas de seguridad de Firestore de Cine Luz del Mar.
//
// Se ejecutan contra la Emulator Suite:
//   npm run test:emulator
// (o `npm test` si ya hay un emulador de Firestore levantado en :8080)

import { after, before, beforeEach, describe, it } from 'node:test';
import { readFileSync } from 'node:fs';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  increment,
  query,
  setDoc,
  updateDoc,
  where,
  writeBatch,
} from 'firebase/firestore';

let env;

// Contextos por rol. `verified` controla el claim email_verified.
const ctx = (uid, role, verified = true) =>
  env
    .authenticatedContext(uid, { email_verified: verified })
    .firestore();

const seedUsers = {
  'admin-1': 'admin',
  'presi-1': 'presidente',
  'junta-1': 'junta',
  'coord-1': 'coordinador',
  'socio-1': 'socio',
  'socio-2': 'socio',
  'invit-1': 'invitado',
};

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-cine-luz-del-mar',
    firestore: {
      rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
      host: process.env.FIRESTORE_EMULATOR_HOST?.split(':')[0] ?? 'localhost',
      port: Number(process.env.FIRESTORE_EMULATOR_HOST?.split(':')[1] ?? 8080),
    },
  });
});

after(async () => {
  await env.cleanup();
});

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (admin) => {
    const db = admin.firestore();
    for (const [uid, role] of Object.entries(seedUsers)) {
      await setDoc(doc(db, 'users', uid), {
        displayName: uid,
        email: `${uid}@test.dev`,
        role,
      });
    }
    await setDoc(doc(db, 'news', 'n-pub'), {
      title: 'Ciclo de cine clásico',
      status: 'published',
    });
    await setDoc(doc(db, 'news', 'n-draft'), {
      title: 'Borrador',
      status: 'draft',
    });
    await setDoc(doc(db, 'events', 'e-1'), {
      title: 'Proyección',
      status: 'published',
      capacity: 2,
      reservedCount: 0,
    });
    await setDoc(doc(db, 'events', 'e-lleno'), {
      title: 'Taller completo',
      status: 'published',
      capacity: 1,
      reservedCount: 1,
    });
    await setDoc(doc(db, 'films', 'f-1'), {
      title: 'El faro',
      avgRating: 0,
      ratingsCount: 0,
    });
    await setDoc(doc(db, 'posts', 'p-1'), {
      authorUid: 'socio-1',
      text: 'Hola',
      visibility: 'members',
      likesCount: 0,
      commentsCount: 0,
    });
    await setDoc(doc(db, 'library', 'l-socios'), {
      title: 'Guion taller',
      minRole: 'socio',
    });
    await setDoc(doc(db, 'library', 'l-publico'), {
      title: 'Programa festival',
      minRole: 'invitado',
    });
    await setDoc(doc(db, 'members', 'socio-1'), {
      memberNumber: 1,
      status: 'active',
    });
    await setDoc(doc(db, 'chats', 'c-1'), {
      type: 'direct',
      memberUids: ['socio-1', 'socio-2'],
    });
    await setDoc(doc(db, 'notifications', 'socio-1', 'items', 'noti-1'), {
      title: 'Bienvenida',
      read: false,
    });
    await setDoc(doc(db, 'app_config', 'home'), { bannerTitle: 'Hola' });
  });
});

describe('usuarios', () => {
  it('un usuario crea su perfil como invitado', () =>
    assertSucceeds(
      setDoc(doc(ctx('nuevo-1'), 'users', 'nuevo-1'), {
        displayName: 'Nueva',
        email: 'n@test.dev',
        role: 'invitado',
      }),
    ));

  it('nadie se auto-asigna un rol privilegiado al crearse', () =>
    assertFails(
      setDoc(doc(ctx('nuevo-2'), 'users', 'nuevo-2'), {
        displayName: 'Pirata',
        email: 'p@test.dev',
        role: 'admin',
      }),
    ));

  it('el dueño edita su bio pero no su rol', async () => {
    const db = ctx('socio-1');
    await assertSucceeds(
      updateDoc(doc(db, 'users', 'socio-1'), { bio: 'Cinéfila' }),
    );
    await assertFails(
      updateDoc(doc(db, 'users', 'socio-1'), { role: 'admin' }),
    );
  });

  it('presidente cambia roles; junta no puede', async () => {
    await assertSucceeds(
      updateDoc(doc(ctx('presi-1'), 'users', 'invit-1'), { role: 'socio' }),
    );
    await assertFails(
      updateDoc(doc(ctx('junta-1'), 'users', 'invit-1'), { role: 'socio' }),
    );
  });

  it('presidente no asciende a nadie por encima de su rango', () =>
    assertFails(
      updateDoc(doc(ctx('presi-1'), 'users', 'invit-1'), { role: 'admin' }),
    ));
});

describe('noticias', () => {
  it('cualquiera lee noticias publicadas, nadie sin rango lee borradores', async () => {
    const anon = env.unauthenticatedContext().firestore();
    await assertSucceeds(getDoc(doc(anon, 'news', 'n-pub')));
    await assertFails(getDoc(doc(anon, 'news', 'n-draft')));
    await assertSucceeds(getDoc(doc(ctx('coord-1'), 'news', 'n-draft')));
  });

  it('solo coordinador+ crea noticias', async () => {
    await assertFails(
      setDoc(doc(ctx('socio-1'), 'news', 'nueva'), {
        title: 'x',
        status: 'draft',
      }),
    );
    await assertSucceeds(
      setDoc(doc(ctx('coord-1'), 'news', 'nueva'), {
        title: 'x',
        status: 'draft',
      }),
    );
  });
});

describe('reservas', () => {
  const reservar = (db, uid, eventId = 'e-1') => {
    const batch = writeBatch(db);
    batch.set(doc(db, 'events', eventId, 'reservations', uid), {
      status: 'active',
    });
    batch.update(doc(db, 'events', eventId), {
      reservedCount: increment(1),
    });
    return batch.commit();
  };

  it('un socio reserva plaza incrementando el contador en la transacción', () =>
    assertSucceeds(reservar(ctx('socio-1'), 'socio-1')));

  it('no se puede reservar sin incrementar el contador', () =>
    assertFails(
      setDoc(doc(ctx('socio-1'), 'events', 'e-1', 'reservations', 'socio-1'), {
        status: 'active',
      }),
    ));

  it('no se puede reservar un evento completo', () =>
    assertFails(reservar(ctx('socio-1'), 'socio-1', 'e-lleno')));

  it('nadie reserva en nombre de otro', () =>
    assertFails(reservar(ctx('socio-2'), 'socio-1')));

  it('cancelar decrementa el contador en la misma transacción', async () => {
    await reservar(ctx('socio-1'), 'socio-1');
    const db = ctx('socio-1');
    const batch = writeBatch(db);
    batch.update(doc(db, 'events', 'e-1', 'reservations', 'socio-1'), {
      status: 'cancelled',
    });
    batch.update(doc(db, 'events', 'e-1'), { reservedCount: increment(-1) });
    await assertSucceeds(batch.commit());
  });

  it('el contador no admite saltos de más de 1', () =>
    assertFails(
      updateDoc(doc(ctx('socio-1'), 'events', 'e-1'), {
        reservedCount: increment(5),
      }),
    ));
});

describe('películas', () => {
  it('valoración propia entre 0.5 y 5', async () => {
    await assertSucceeds(
      setDoc(doc(ctx('socio-1'), 'films', 'f-1', 'ratings', 'socio-1'), {
        score: 4.5,
      }),
    );
    await assertFails(
      setDoc(doc(ctx('socio-1'), 'films', 'f-1', 'ratings', 'socio-1'), {
        score: 6,
      }),
    );
  });

  it('sin email verificado no se valora', () =>
    assertFails(
      setDoc(
        doc(ctx('socio-1', 'socio', false), 'films', 'f-1', 'ratings', 'socio-1'),
        { score: 3 },
      ),
    ));

  it('un socio solo toca los agregados de valoración', async () => {
    await assertSucceeds(
      updateDoc(doc(ctx('socio-1'), 'films', 'f-1'), {
        avgRating: 4.5,
        ratingsCount: 1,
      }),
    );
    await assertFails(
      updateDoc(doc(ctx('socio-1'), 'films', 'f-1'), { title: 'Hackeada' }),
    );
  });
});

describe('comunidad', () => {
  it('socio verificado publica; invitado no', async () => {
    await assertSucceeds(
      setDoc(doc(ctx('socio-1'), 'posts', 'p-nuevo'), {
        authorUid: 'socio-1',
        text: 'Gran proyección',
        visibility: 'members',
        likesCount: 0,
        commentsCount: 0,
      }),
    );
    await assertFails(
      setDoc(doc(ctx('invit-1'), 'posts', 'p-invitado'), {
        authorUid: 'invit-1',
        text: 'Hola',
        visibility: 'members',
        likesCount: 0,
        commentsCount: 0,
      }),
    );
  });

  it('el autor edita su texto; otro socio no', async () => {
    await assertSucceeds(
      updateDoc(doc(ctx('socio-1'), 'posts', 'p-1'), { text: 'Editado' }),
    );
    await assertFails(
      updateDoc(doc(ctx('socio-2'), 'posts', 'p-1'), { text: 'Vandalismo' }),
    );
  });

  it('dar like mueve el contador en 1 junto al doc de like', async () => {
    const db = ctx('socio-2');
    const batch = writeBatch(db);
    batch.set(doc(db, 'posts', 'p-1', 'likes', 'socio-2'), { at: 1 });
    batch.update(doc(db, 'posts', 'p-1'), { likesCount: increment(1) });
    await assertSucceeds(batch.commit());
    await assertFails(
      updateDoc(doc(ctx('socio-2'), 'posts', 'p-1'), {
        likesCount: increment(10),
      }),
    );
  });
});

describe('biblioteca', () => {
  it('minRole se respeta', async () => {
    await assertFails(getDoc(doc(ctx('invit-1'), 'library', 'l-socios')));
    await assertSucceeds(getDoc(doc(ctx('socio-1'), 'library', 'l-socios')));
    await assertSucceeds(getDoc(doc(ctx('invit-1'), 'library', 'l-publico')));
  });
});

describe('socios y cuotas', () => {
  it('cada socio ve su ficha; junta gestiona', async () => {
    await assertSucceeds(getDoc(doc(ctx('socio-1'), 'members', 'socio-1')));
    await assertFails(getDoc(doc(ctx('socio-2'), 'members', 'socio-1')));
    await assertSucceeds(
      setDoc(doc(ctx('junta-1'), 'members', 'socio-2'), {
        memberNumber: 2,
        status: 'active',
      }),
    );
    await assertFails(
      setDoc(doc(ctx('socio-2'), 'members', 'socio-2'), {
        memberNumber: 99,
        status: 'active',
      }),
    );
  });
});

describe('chat', () => {
  it('solo los miembros leen y escriben', async () => {
    await assertSucceeds(getDoc(doc(ctx('socio-1'), 'chats', 'c-1')));
    await assertFails(getDoc(doc(ctx('invit-1'), 'chats', 'c-1')));
    await assertSucceeds(
      setDoc(doc(ctx('socio-1'), 'chats', 'c-1', 'messages', 'm-1'), {
        senderUid: 'socio-1',
        text: 'Hola',
      }),
    );
    await assertFails(
      setDoc(doc(ctx('invit-1'), 'chats', 'c-1', 'messages', 'm-2'), {
        senderUid: 'invit-1',
        text: 'Intruso',
      }),
    );
    await assertFails(
      setDoc(doc(ctx('socio-1'), 'chats', 'c-1', 'messages', 'm-3'), {
        senderUid: 'socio-2',
        text: 'Suplantación',
      }),
    );
  });
});

describe('notificaciones', () => {
  it('el dueño lee y marca como leída; no reescribe el contenido', async () => {
    const db = ctx('socio-1');
    await assertSucceeds(
      getDoc(doc(db, 'notifications', 'socio-1', 'items', 'noti-1')),
    );
    await assertSucceeds(
      updateDoc(doc(db, 'notifications', 'socio-1', 'items', 'noti-1'), {
        read: true,
      }),
    );
    await assertFails(
      updateDoc(doc(db, 'notifications', 'socio-1', 'items', 'noti-1'), {
        title: 'Cambiada',
      }),
    );
    await assertFails(
      getDoc(doc(ctx('socio-2'), 'notifications', 'socio-1', 'items', 'noti-1')),
    );
  });
});

describe('configuración', () => {
  it('lectura pública, escritura de coordinador+', async () => {
    const anon = env.unauthenticatedContext().firestore();
    await assertSucceeds(getDoc(doc(anon, 'app_config', 'home')));
    await assertSucceeds(
      updateDoc(doc(ctx('coord-1'), 'app_config', 'home'), { bannerTitle: 'x' }),
    );
    await assertFails(
      updateDoc(doc(ctx('socio-1'), 'app_config', 'home'), { bannerTitle: 'x' }),
    );
  });
});

describe('rutas no contempladas', () => {
  it('cualquier colección desconocida está cerrada', async () => {
    await assertFails(
      setDoc(doc(ctx('admin-1'), 'secretos', 's-1'), { x: 1 }),
    );
    await assertFails(
      getDocs(query(collection(ctx('socio-1'), 'secretos'))),
    );
  });

  it('borrar usuarios es solo de admin', async () => {
    await assertFails(deleteDoc(doc(ctx('presi-1'), 'users', 'invit-1')));
    await assertSucceeds(deleteDoc(doc(ctx('admin-1'), 'users', 'invit-1')));
  });

  it('members: filtros de junta funcionan con query where', () =>
    assertSucceeds(
      getDocs(
        query(
          collection(ctx('junta-1'), 'members'),
          where('status', '==', 'active'),
        ),
      ),
    ));
});
