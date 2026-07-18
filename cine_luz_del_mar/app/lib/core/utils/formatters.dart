import 'package:intl/intl.dart';

/// Formateadores de fecha y número para la app (locale es_ES por defecto).
abstract final class Formatters {
  static final DateFormat dayMonth = DateFormat('d MMM', 'es');
  static final DateFormat fullDate = DateFormat("d 'de' MMMM 'de' y", 'es');
  static final DateFormat time = DateFormat.Hm('es');
  static final DateFormat dateTime = DateFormat("d MMM y · HH:mm", 'es');
  static final NumberFormat currency = NumberFormat.currency(
    locale: 'es',
    symbol: '€',
  );

  static String relative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'ahora mismo';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'hace ${diff.inDays} d';
    return dayMonth.format(date);
  }
}
