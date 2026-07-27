// Tests de ida y vuelta (toJson -> fromJson) de los modelos freezed de
// Firestore. Las fechas se normalizan a microsegundos porque `Timestamp`
// (cloud_firestore) trunca la precisión de `DateTime` a microsegundos al
// serializar.
import 'package:cine_luz_del_mar/shared/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

/// Trunca un [DateTime] a la precisión de microsegundos que usa `Timestamp`.
DateTime _truncated(DateTime date) =>
    DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);

void main() {
  final now = _truncated(DateTime.now());

  group('NewsItem', () {
    test('toJson -> fromJson conserva los campos', () {
      final original = NewsItem(
        id: 'noticia-1',
        title: 'Nueva sala inaugurada',
        body: 'Contenido de la noticia.',
        coverUrl: 'https://example.com/cover.jpg',
        tags: const ['inauguracion', 'sala'],
        featured: true,
        status: 'published',
        publishedAt: now,
        authorUid: 'uid-autor',
        searchTokens: const ['nueva', 'sala'],
        createdAt: now,
        updatedAt: now,
      );

      final json = original.toJson();
      // El id no viaja en el JSON: lo rellena el repositorio con doc.id.
      expect(json.containsKey('id'), isFalse);

      final restored = NewsItem.fromJson(json);

      expect(restored.title, original.title);
      expect(restored.body, original.body);
      expect(restored.coverUrl, original.coverUrl);
      expect(restored.tags, original.tags);
      expect(restored.featured, original.featured);
      expect(restored.status, original.status);
      expect(restored.publishedAt, now);
      expect(restored.authorUid, original.authorUid);
      expect(restored.searchTokens, original.searchTokens);
      expect(restored.createdAt, now);
      expect(restored.updatedAt, now);
      // fromJson no rellena id: queda con el valor por defecto.
      expect(restored.id, '');
    });
  });

  group('EventItem con Venue', () {
    test(
      'toJson -> fromJson conserva los campos, incluido el objeto anidado',
      () {
        const venue = Venue(
          name: 'Cine Luz del Mar',
          address: 'Paseo Marítimo 1',
          lat: 43.36,
          lng: -8.41,
          geohash: 'ez3f',
        );

        final original = EventItem(
          id: 'evento-1',
          type: 'proyeccion',
          title: 'Proyección de verano',
          description: 'Sesión al aire libre.',
          start: now,
          end: now.add(const Duration(hours: 2)),
          venue: venue,
          capacity: 100,
          reservedCount: 42,
          coverUrl: 'https://example.com/evento.jpg',
          filmId: 'pelicula-1',
          status: 'published',
          featured: true,
          searchTokens: const ['verano', 'proyeccion'],
          createdAt: now,
          updatedAt: now,
        );

        final json = original.toJson();
        final restored = EventItem.fromJson(json);

        expect(restored.type, original.type);
        expect(restored.title, original.title);
        expect(restored.description, original.description);
        expect(restored.start, now);
        expect(restored.end, _truncated(original.end!));
        expect(restored.venue, venue);
        expect(restored.venue?.name, venue.name);
        expect(restored.venue?.lat, venue.lat);
        expect(restored.capacity, original.capacity);
        expect(restored.reservedCount, original.reservedCount);
        expect(restored.coverUrl, original.coverUrl);
        expect(restored.filmId, original.filmId);
        expect(restored.status, original.status);
        expect(restored.featured, original.featured);
        expect(restored.searchTokens, original.searchTokens);
        expect(restored.createdAt, now);
        expect(restored.updatedAt, now);
      },
    );
  });

  group('Member', () {
    test('toJson -> fromJson conserva los campos', () {
      final original = Member(
        id: 'uid-socio',
        memberNumber: 123,
        status: 'active',
        joinedAt: now,
        benefits: const ['descuento_entradas', 'acceso_biblioteca'],
        createdAt: now,
        updatedAt: now,
      );

      final json = original.toJson();
      final restored = Member.fromJson(json);

      expect(restored.memberNumber, original.memberNumber);
      expect(restored.status, original.status);
      expect(restored.joinedAt, now);
      expect(restored.benefits, original.benefits);
      expect(restored.createdAt, now);
      expect(restored.updatedAt, now);
    });
  });

  group('Chat', () {
    test('toJson -> fromJson conserva los campos', () {
      final original = Chat(
        id: 'chat-1',
        type: 'group',
        memberUids: const ['uid-1', 'uid-2', 'uid-3'],
        name: 'Grupo de cinéfilos',
        lastMessageText: 'Hola a todos',
        lastMessageSenderUid: 'uid-1',
        lastMessageAt: now,
        createdAt: now,
      );

      final json = original.toJson();
      final restored = Chat.fromJson(json);

      expect(restored.type, original.type);
      expect(restored.memberUids, original.memberUids);
      expect(restored.name, original.name);
      expect(restored.lastMessageText, original.lastMessageText);
      expect(restored.lastMessageSenderUid, original.lastMessageSenderUid);
      expect(restored.lastMessageAt, now);
      expect(restored.createdAt, now);
    });
  });
}
