class EmployeeModel {
  int? id;
  String nombreCompleto;
  DateTime? nacimiento;
  String correoElectronico;
  String numeroTelefono;
  String dni;

  EmployeeModel({
    this.id,
    required this.nombreCompleto,
    this.nacimiento,
    required this.correoElectronico,
    required this.numeroTelefono,
    required this.dni,
  });
}