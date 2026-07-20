// Reproduce la lectura del carné como haría la app (SDK cliente + reglas).
import { initializeApp } from 'firebase/app';
import {
  connectAuthEmulator,
  getAuth,
  signInWithEmailAndPassword,
} from 'firebase/auth';
import {
  collection,
  connectFirestoreEmulator,
  doc,
  getDoc,
  getDocs,
  getFirestore,
  orderBy,
  query,
  where,
} from 'firebase/firestore';

const app = initializeApp({
  apiKey: 'fake',
  projectId: 'cine-luz-de-mar',
  authDomain: 'localhost',
});
const auth = getAuth(app);
const db = getFirestore(app);
connectAuthEmulator(auth, 'http://localhost:9099', { disableWarnings: true });
connectFirestoreEmulator(db, 'localhost', 8080);

const cred = await signInWithEmailAndPassword(
  auth,
  'socia@cineluzdelmar.es',
  'CineLuz2026',
);
console.log('uid:', cred.user.uid);

const member = await getDoc(doc(db, 'members', cred.user.uid));
console.log('member exists:', member.exists(), member.data());

const fees = await getDocs(collection(db, 'members', cred.user.uid, 'fees'));
console.log('fees:', fees.docs.map((d) => [d.id, d.data().status]));

const plans = await getDocs(
  query(
    collection(db, 'membership_plans'),
    where('active', '==', true),
    orderBy('order'),
  ),
);
console.log('plans:', plans.docs.map((d) => d.data().name));
process.exit(0);
