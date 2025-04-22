import 'package:myapp/models/employee.dart';

class EmployeeService {
  final List<Employee> _employees = [];

  void addEmployee(Employee employee) {
    _employees.add(employee);
  }

  List<Employee> getAllEmployees() {
    return _employees;
  }
}
