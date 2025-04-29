class Employee {
  int? id;
  String nombreCompleto;
  DateTime? nacimiento;
  String correoElectronico;
  String numeroTelefono;
  String dni;

  Employee({
    this.id,
    required this.nombreCompleto,
    this.nacimiento,
    required this.correoElectronico,
    required this.numeroTelefono,
    required this.dni,
  });
}