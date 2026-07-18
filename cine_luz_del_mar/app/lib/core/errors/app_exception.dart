/// Excepciones tipadas de la aplicación.
///
/// Las capas de datos capturan errores de plataforma (Firebase, red...) y los
/// traducen a estas excepciones; la capa de presentación las convierte en
/// mensajes localizados.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Sin conexión con el servidor']);
}

class AuthException extends AppException {
  const AuthException(super.message, {this.code});

  final String? code;
}

class PermissionException extends AppException {
  const PermissionException([super.message = 'No tienes permisos suficientes']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Recurso no encontrado']);
}

class CapacityException extends AppException {
  const CapacityException([super.message = 'No quedan plazas disponibles']);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class StorageException extends AppException {
  const StorageException([super.message = 'Error al subir el archivo']);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Ha ocurrido un error inesperado']);
}
