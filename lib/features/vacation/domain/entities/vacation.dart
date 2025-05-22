class Vacation {
  final int? id;
  final String employeeDni;
  final String employeeName;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  Vacation({
    this.id,
    required this.employeeDni,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    this.status = 'pending',
  });

  Vacation copyWith({
    int? id,
    String? employeeName,
    String? employeeDni,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Vacation(
      id: id ?? this.id,
      employeeName: employeeName ?? this.employeeName,
      employeeDni: employeeDni ?? this.employeeDni,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
