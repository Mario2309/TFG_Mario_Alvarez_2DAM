import '../repositories/employee_repository.dart';

class DeleteEmployee {
  final EmployeeRepository repository;

  DeleteEmployee(this.repository);

  Future<void> call(int id) async {
    await repository.deleteEmployee(id);
  }
}
