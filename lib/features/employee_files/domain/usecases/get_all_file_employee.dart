import 'package:nexuserp/features/employee_files/domain/entities/employee_file.dart';
import 'package:nexuserp/features/employee_files/domain/repositories/employee_file_repository.dart';

class GetAllEmployeesFile {
  final EmployeeFileRepository repository;

  GetAllEmployeesFile(this.repository);

  Future<List<EmployeeFile>> call(int employeeId) async {
    return await repository.fetchFilesByEmployee(employeeId);
  }
}
