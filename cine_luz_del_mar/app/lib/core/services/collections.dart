/// Nombres centralizados de las colecciones de Firestore.
///
/// Evita literales de cadena dispersos por el código y mantiene un único
/// punto de verdad sincronizado con las reglas de seguridad.
abstract final class Col {
  static const String users = 'users';
  static const String news = 'news';
  static const String events = 'events';
  static const String films = 'films';
  static const String posts = 'posts';
  static const String friendships = 'friendships';
  static const String library = 'library';
  static const String members = 'members';
  static const String chats = 'chats';
  static const String notifications = 'notifications';
  static const String certificates = 'certificates';
  static const String attendance = 'attendance';
  static const String counters = 'counters';
  static const String appConfig = 'app_config';
}
