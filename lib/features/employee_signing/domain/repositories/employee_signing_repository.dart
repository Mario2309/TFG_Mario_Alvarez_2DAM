import '../entities/employee_signing.dart';

abstract class EmployeeSigningRepository {
  Future<void> addAttendance(EmployeeSigning attendance);
  Future<void> deleteAttendance(int id);
  Future<void> updateAttendance(EmployeeSigning attendance);
  Future<List<EmployeeSigning>> getAttendancesByEmployee(int employeeId);
  Future<List<EmployeeSigning>> getAttendancesByDate(DateTime date);
  Future<List<EmployeeSigning>> getAllAttendances();
}
