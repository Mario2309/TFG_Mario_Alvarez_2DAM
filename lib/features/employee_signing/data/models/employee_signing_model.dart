class EmployeeSigningModel {
  final int? id;
  final int empleadoId;
  final String
  empleadoNombre; // Placeholder, should be set from a related employee model
  final DateTime fechaHora;
  final String tipo; // 'entrada' o 'salida'

  EmployeeSigningModel({
    this.id,
    required this.empleadoId,
    required this.empleadoNombre,
    required this.fechaHora,
    required this.tipo,
  }) : assert(
         tipo == 'entrada' || tipo == 'salida',
         'Tipo debe ser "entrada" o "salida"',
       );

  // Para insertar o enviar por red
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,  // <-- NO incluir esto en el insert
      'empleado_id': empleadoId,
      'fecha': fechaHora.toIso8601String(),
      'tipo': tipo,
      'empleado_nombre': empleadoNombre,
    };
  }

  // Desde una base de datos o JSON
  factory EmployeeSigningModel.fromJson(Map<String, dynamic> map) {
    return EmployeeSigningModel(
      id: map['id'],
      empleadoId: map['empleado_id'],
      empleadoNombre:
          map['empleado_nombre'] ??
          '', // Placeholder, should be set from a related employee model
      fechaHora: DateTime.parse(map['fecha']),
      tipo: map['tipo'],
    );
  }
}
