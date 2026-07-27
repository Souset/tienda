/// Generación de tokens de búsqueda por prefijos para Firestore.
///
/// Firestore no ofrece búsqueda full-text; en su lugar cada documento
/// buscable guarda un array `searchTokens` con los prefijos normalizados de
/// sus palabras (mínimo 2 caracteres, máximo 15 por palabra). El buscador
/// consulta con `array-contains` sobre el término normalizado.
library;

String normalizeSearchTerm(String input) {
  const withDiacritics = 'áàäâãéèëêíìïîóòöôõúùüûñç';
  const withoutDiacritics = 'aaaaaeeeeiiiiooooouuuunc';
  final lower = input.toLowerCase().trim();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final char = String.fromCharCode(rune);
    final index = withDiacritics.indexOf(char);
    buffer.write(index >= 0 ? withoutDiacritics[index] : char);
  }
  return buffer.toString();
}

List<String> buildSearchTokens(Iterable<String> fields) {
  final tokens = <String>{};
  for (final field in fields) {
    final words = normalizeSearchTerm(
      field,
    ).split(RegExp(r'[^a-z0-9]+')).where((w) => w.length >= 2);
    for (final word in words) {
      final limit = word.length > 15 ? 15 : word.length;
      for (var end = 2; end <= limit; end++) {
        tokens.add(word.substring(0, end));
      }
    }
  }
  return tokens.toList()..sort();
}
