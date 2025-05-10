import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class GetAllEmployees {
  final EmployeeRepository repository;

  GetAllEmployees(this.repository);

  Future<List<Employee>> call() async {
    return await repository.getAllEmployees();
  }
}
