import 'package:nexuserp/features/employee_files/domain/entities/employee_file.dart';
import '../repositories/emplyee_file_repositorY.dart';

class DeleteFileEmployee {
  final EmployeeFileRepository repository;

  DeleteFileEmployee(this.repository);

  Future<void> call(EmployeeFile employee) async {
    await repository.updateFile(employee);
  }
}