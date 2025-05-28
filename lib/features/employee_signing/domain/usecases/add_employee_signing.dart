import '../entities/employee_signing.dart';
import '../repositories/employee_signing_repository.dart';

class AddEmployeeSigning {
  final EmployeeSigningRepository repository;

  AddEmployeeSigning(this.repository);

  Future<void> call(EmployeeSigning employee) async {
    await repository.addAttendance(employee);
  }
}
