class Employee {
  final int? id;
  final String nombreCompleto;
  final DateTime nacimiento;
  final String correoElectronico;
  final String numeroTelefono;
  final String dni;
  final double sueldo;
  final String cargo;
  final DateTime fechaContratacion;
  final bool activo;

  Employee({
    this.id,
    required this.nombreCompleto,
    required this.nacimiento,
    required this.correoElectronico,
    required this.numeroTelefono,
    required this.dni,
    required this.sueldo,
    required this.cargo,
    required this.fechaContratacion,
    required this.activo,
  });
}
