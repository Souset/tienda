/// Matemática pura del recálculo de la valoración media de una película.
///
/// Se extrae de la capa de datos para poder testearla de forma aislada.
/// [previous] es la nota anterior del mismo usuario (null si es su primera
/// valoración); [newScore] es la nota nueva (null cuando el usuario borra su
/// valoración). Devuelve la media y el número de valoraciones resultantes.
({double avg, int count}) recalcRating({
  required double? previous,
  required double? newScore,
  required double currentAvg,
  required int currentCount,
}) {
  // Suma total actual de todas las notas.
  final double currentSum = currentAvg * currentCount;

  double sum = currentSum;
  int count = currentCount;

  if (previous != null) {
    // El usuario ya había valorado: retiramos su nota previa.
    sum -= previous;
    count -= 1;
  }

  if (newScore != null) {
    // Añadimos (o sustituimos) con la nota nueva.
    sum += newScore;
    count += 1;
  }

  if (count <= 0) {
    // Sin valoraciones: media y contador a cero (evita divisiones raras).
    return (avg: 0, count: 0);
  }

  // Redondea la media a dos decimales para almacenar un valor estable.
  final double avg = (sum / count * 100).roundToDouble() / 100;
  return (avg: avg, count: count);
}
