class EmployeeSigning {
  final int? id;
  final int empleadoId;
  final String
  empleadoNombre; // Placeholder, should be set from a related employee model
  final DateTime fechaHora;
  final String tipo; // 'entrada' o 'salida'

  EmployeeSigning({
    this.id,
    required this.empleadoId,
    required this.empleadoNombre,
    required this.fechaHora,
    required this.tipo,
  });
}
