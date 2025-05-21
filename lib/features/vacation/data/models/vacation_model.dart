class VacationModel {
  final int? id;
  final String employeeName;
  final String employeeDni;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // e.g., "pending", "approved", "rejected"

  VacationModel({
    this.id,
    required this.employeeName,
    required this.employeeDni,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory VacationModel.fromJson(Map<String, dynamic> json) {
    return VacationModel(
      id: json['id'],
      employeeName: json['nombre_empleado'],
      employeeDni: json['dni_empleado'],
      startDate: DateTime.parse(json['fecha_inicio']),
      endDate: DateTime.parse(json['fecha_fin']),
      status: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dni_empleado': employeeDni,
      'nombre_empleado': employeeName,
      'fecha_inicio': startDate.toIso8601String(),
      'fecha_fin': endDate.toIso8601String(),
      'estado': status,
    };
  }
}
