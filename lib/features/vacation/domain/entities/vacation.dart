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
}
