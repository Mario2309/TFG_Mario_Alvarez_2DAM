import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_service.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeService service;

  EmployeeRepositoryImpl(this.service);

  @override
  Future<void> addEmployee(Employee e) async {
    final model = EmployeeModel(
      id: e.id,
      nombreCompleto: e.nombreCompleto,
      nacimiento: e.nacimiento,
      correoElectronico: e.correoElectronico,
      numeroTelefono: e.numeroTelefono,
      dni: e.dni,
    );
    await service.addEmployee(model);
  }

  @override
  Future<void> deleteEmployee(int id) async {
    await service.deleteEmployee(id);
  }

  @override
  Future<List<Employee>> getAllEmployees() async {
    final models = await service.fetchEmployees();
    return models.map((m) => Employee(
      id: m.id,
      nombreCompleto: m.nombreCompleto,
      nacimiento: m.nacimiento,
      correoElectronico: m.correoElectronico,
      numeroTelefono: m.numeroTelefono,
      dni: m.dni,
    )).toList();
  }

  @override
  Future<List<Employee>> getEmployees() async {
    final models = await service.fetchEmployees();
    return models.map((m) => Employee(
      id: m.id,
      nombreCompleto: m.nombreCompleto,
      nacimiento: m.nacimiento,
      correoElectronico: m.correoElectronico,
      numeroTelefono: m.numeroTelefono,
      dni: m.dni,
    )).toList();
  }
}
