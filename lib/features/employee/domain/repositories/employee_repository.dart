import 'package:nexuserp/features/employee/domain/entities/employee.dart';

abstract class EmployeeRepository {
  Future<void> addEmployee(Employee employee);
  Future<List<Employee>> getAllEmployees();
  Future<void> deleteEmployee(int id);
    Future<List<Employee>> getEmployees();
}