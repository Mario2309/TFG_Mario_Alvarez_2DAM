class EmployeeModel {
  final int?id;
  final String nombreCompleto;
  final DateTime nacimiento;
  final String correoElectronico;
  final String numeroTelefono;
  final String dni;

  EmployeeModel({
    this.id,
    required this.nombreCompleto,
    required this.nacimiento,
    required this.correoElectronico,
    required this.numeroTelefono,
    required this.dni,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      nombreCompleto: json['nombre_completo'],
      nacimiento: DateTime.parse(json['nacimiento']),
      correoElectronico: json['correo_electronico'],
      numeroTelefono: json['numero_telefono'],
      dni: json['dni'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre_completo': nombreCompleto,
        'nacimiento': nacimiento.toIso8601String(),
        'correo_electronico': correoElectronico,
        'numero_telefono': numeroTelefono,
        'dni': dni,
      };
}
