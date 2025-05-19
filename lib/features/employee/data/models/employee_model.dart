class EmployeeModel {
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

  EmployeeModel({
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

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      nombreCompleto: json['nombre_completo'],
      nacimiento: DateTime.parse(json['nacimiento']),
      correoElectronico: json['correo_electronico'],
      numeroTelefono: json['numero_telefono'],
      dni: json['dni'],
      sueldo: (json['sueldo'] as num).toDouble(),
      cargo: json['cargo'],
      fechaContratacion: DateTime.parse(json['fecha_contratacion']),
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre_completo': nombreCompleto,
    'nacimiento': nacimiento.toIso8601String(),
    'correo_electronico': correoElectronico,
    'numero_telefono': numeroTelefono,
    'dni': dni,
    'sueldo': sueldo,
    'cargo': cargo,
    'fecha_contratacion': fechaContratacion.toIso8601String(),
    'activo': activo,
  };
}
