import 'package:nexuserp/features/employee_signing/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee_signing/data/models/employee_signing_model.dart';
import 'package:nexuserp/features/employee_signing/domain/entities/employee_signing.dart';
import 'package:nexuserp/features/employee_signing/domain/repositories/employee_signing_repository.dart';

class EmployeeSingingRepositoryImpl implements EmployeeSigningRepository {
  final EmployeeSingingService service;

  EmployeeSingingRepositoryImpl(this.service);

  @override
  Future<void> addAttendance(EmployeeSigning attendance) async {
    final model = _mapEntityToModel(attendance);
    await service.addAttendance(model);
  }

  @override
  Future<void> deleteAttendance(int id) async {
    await service.deleteAttendance(id);
  }

  @override
  Future<void> updateAttendance(EmployeeSigning attendance) async {
    final model = _mapEntityToModel(attendance);
    await service.updateAttendance(model);
  }

  @override
  Future<List<EmployeeSigning>> getAttendancesByEmployee(int employeeId) async {
    final models = await service.fetchAttendancesByEmployee(employeeId);
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<EmployeeSigning>> getAttendancesByDate(DateTime date) async {
    final models = await service.fetchAttendancesByDate(date);
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<EmployeeSigning>> getAllAttendances() async {
    final models = await service.fetchAllAttendances();
    return models.map(_mapModelToEntity).toList();
  }

  EmployeeSigning _mapModelToEntity(EmployeeSigningModel m) {
    return EmployeeSigning(
      id: m.id,
      empleadoId: m.empleadoId,
      fechaHora: m.fechaHora,
      tipo: m.tipo,
      empleadoNombre: m.empleadoNombre,
    );
  }

  EmployeeSigningModel _mapEntityToModel(EmployeeSigning a) {
    return EmployeeSigningModel(
      id: a.id,
      empleadoId: a.empleadoId,
      fechaHora: a.fechaHora,
      tipo: a.tipo,
      empleadoNombre: a.empleadoNombre,
    );
  }
}
