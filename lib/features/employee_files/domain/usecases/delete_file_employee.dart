import 'package:nexuserp/features/employee_files/domain/entities/employee_file.dart';
import '../repositories/employee_file_repository.dart';

class DeleteFileEmployee {
  final EmployeeFileRepository repository;

  DeleteFileEmployee(this.repository);

  Future<void> call(EmployeeFile employee) async {
    await repository.updateFile(employee);
  }
}