import '../repositories/employee_signing_repository.dart';

class DeleteEmployeeSigning {
  final EmployeeSigningRepository repository;

  DeleteEmployeeSigning(this.repository);

  Future<void> call(int id) {
    return repository.deleteAttendance(id);
  }
}