import 'package:nexuserp/features/employee/domain/entities/employee.dart';

abstract class EmployeeRepository {
  Future<void> addEmployee(Employee employee);
  Future<void> deleteEmployee(String dni);
  Future<void> updateEmployee(Employee employee);
  Future<List<Employee>> getAllEmployees();
  Future<List<Employee>> getEmployees();
}
