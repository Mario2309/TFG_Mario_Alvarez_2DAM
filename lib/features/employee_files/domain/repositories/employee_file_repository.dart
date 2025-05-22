import '../entities/employee_file.dart';

abstract class EmployeeFileRepository {
  Future<List<EmployeeFile>> fetchFilesByEmployee(int employeeId);

  Future<List<EmployeeFile>> getAllFiles();

  Future<EmployeeFile> uploadFile(EmployeeFile file);

  Future<EmployeeFile> updateFile(EmployeeFile file);

  Future<void> deleteFile(int id);
}
