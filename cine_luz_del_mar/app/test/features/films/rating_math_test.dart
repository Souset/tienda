import 'package:cine_luz_del_mar/features/films/domain/rating_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('recalcRating', () {
    test('primera valoración de la película', () {
      final result = recalcRating(
        previous: null,
        newScore: 4,
        currentAvg: 0,
        currentCount: 0,
      );
      expect(result.count, 1);
      expect(result.avg, 4.0);
    });

    test('actualización de una valoración existente', () {
      // Media 4.0 con 2 votos (suma 8, p. ej. 3 y 5). El usuario cambia su 3
      // por un 5: nuevas notas 5 y 5 -> media 5.0 sin variar el número.
      final result = recalcRating(
        previous: 3,
        newScore: 5,
        currentAvg: 4,
        currentCount: 2,
      );
      expect(result.count, 2);
      expect(result.avg, 5.0);
    });

    test('borrado con otras valoraciones presentes', () {
      // Media 4.0 con 2 votos (suma 8). Se borra el voto de 3 -> queda 5.
      final result = recalcRating(
        previous: 3,
        newScore: null,
        currentAvg: 4,
        currentCount: 2,
      );
      expect(result.count, 1);
      expect(result.avg, 5.0);
    });

    test('borrado de la única valoración deja la media a cero', () {
      final result = recalcRating(
        previous: 4,
        newScore: null,
        currentAvg: 4,
        currentCount: 1,
      );
      expect(result.count, 0);
      expect(result.avg, 0.0);
    });

    test('la media se redondea a dos decimales', () {
      // Notas 4 y 5 y 4 -> 13/3 = 4.333... -> 4.33.
      final result = recalcRating(
        previous: null,
        newScore: 4,
        currentAvg: 4.5,
        currentCount: 2,
      );
      expect(result.count, 3);
      expect(result.avg, 4.33);
    });
  });
}
