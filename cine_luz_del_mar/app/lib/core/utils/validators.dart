/// Validadores de formularios reutilizables.
library;

final RegExp _emailRegExp = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

String? validateEmail(String? value) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return 'Introduce tu correo electrónico';
  if (!_emailRegExp.hasMatch(v)) return 'El correo no es válido';
  return null;
}

String? validatePassword(String? value) {
  final v = value ?? '';
  if (v.isEmpty) return 'Introduce una contraseña';
  if (v.length < 8) return 'Mínimo 8 caracteres';
  if (!v.contains(RegExp('[A-Za-z]')) || !v.contains(RegExp('[0-9]'))) {
    return 'Debe combinar letras y números';
  }
  return null;
}

String? validateRequired(String? value, [String label = 'Este campo']) {
  if ((value ?? '').trim().isEmpty) return '$label es obligatorio';
  return null;
}

String? validateMaxLength(String? value, int max) {
  if ((value ?? '').length > max) return 'Máximo $max caracteres';
  return null;
}
