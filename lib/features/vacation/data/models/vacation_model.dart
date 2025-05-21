class VacationModel {
  final int? id;
  final String employeeName;
  final String employeeDni;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // e.g., "pending", "approved", "rejected"
  final String? reason; // motivo o comentario opcional

  VacationModel({
    this.id,
    required this.employeeName,
    required this.employeeDni,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.reason,
  });

  factory VacationModel.fromJson(Map<String, dynamic> json) {
    return VacationModel(
      id: json['id'],
      employeeName: json['employee_name'],
      employeeDni: json['employee_dni'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeDni': employeeDni,
      'employeeName': employeeName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'reason': reason,
    };
  }
}
