import 'package:nexuserp/features/employee_files/domain/entities/employee_file.dart';
import '../../domain/repositories/emplyee_file_repositorY.dart';
import '../datasources/employee_file_service.dart';
import '../models/emplyee_file_model.dart';

class EmployeeFileRepositoryImpl implements EmployeeFileRepository {
  final EmployeeFileService service;

  EmployeeFileRepositoryImpl(this.service);

  @override
  Future<void> addFile(EmployeeFile file) async {
    final model = EmployeeFileModel(
      id: file.id,
      employeeId: file.employeeId,
      fileType: file.fileType,
      filePath: file.filePath,
      notes: file.notes,
      uploadDate: file.uploadDate,
      fileName: file.fileName,
    );
    await service.addFile(model);
  }

  @override
  Future<void> deleteFile(int id) async {
    await service.deleteFile(id);
  }

  @override
  Future<EmployeeFile> updateFile(EmployeeFile file) async {
    final model = EmployeeFileModel(
      id: file.id,
      employeeId: file.employeeId,
      fileType: file.fileType,
      filePath: file.filePath,
      notes: file.notes,
      uploadDate: file.uploadDate,
      fileName: file.fileName,
    );

    await service.updateFile(model);

    return file;
  }

  @override
  Future<List<EmployeeFile>> getFilesByEmployee(int empleadoId) async {
    final models = await service.fetchFiles(empleadoId);
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<EmployeeFile> uploadFile(EmployeeFile file) async {
    final model = EmployeeFileModel(
      id: file.id,
      employeeId: file.employeeId,
      fileType: file.fileType,
      filePath: file.filePath,
      notes: file.notes,
      uploadDate: file.uploadDate,
      fileName: file.fileName,
    );
    await service.addFile(model);

    return file;
  }

  EmployeeFile _mapModelToEntity(EmployeeFileModel model) {
    return EmployeeFile(
      id: model.id,
      employeeId: model.employeeId,
      fileType: model.fileType,
      filePath: model.filePath,
      notes: model.notes,
      uploadDate: model.uploadDate,
      fileName: model.fileName,
    );
  }

  @override
  Future<List<EmployeeFile>> fetchFilesByEmployee(int employeeId) async {
    final models = await service.fetchFiles(employeeId);
    return models.map(_mapModelToEntity).toList();
  }
}
