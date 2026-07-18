/// Sistema de roles de la asociación, ordenados por rango descendente.
///
/// El rango se usa para comparaciones jerárquicas ("coordinador o superior").
/// Debe mantenerse sincronizado con `roleRank()` en firestore.rules.
enum UserRole {
  admin('admin', 'Administrador', 6),
  presidente('presidente', 'Presidente', 5),
  junta('junta', 'Junta Directiva', 4),
  coordinador('coordinador', 'Coordinador', 3),
  socio('socio', 'Socio', 2),
  invitado('invitado', 'Invitado', 1);

  const UserRole(this.id, this.label, this.rank);

  final String id;
  final String label;
  final int rank;

  static UserRole fromId(String? id) => UserRole.values.firstWhere(
    (r) => r.id == id,
    orElse: () => UserRole.invitado,
  );

  bool atLeast(UserRole other) => rank >= other.rank;

  bool get canManageContent => atLeast(UserRole.coordinador);
  bool get canManageMembers => atLeast(UserRole.junta);
  bool get canManageUsers => atLeast(UserRole.presidente);
  bool get isAdmin => this == UserRole.admin;
}
