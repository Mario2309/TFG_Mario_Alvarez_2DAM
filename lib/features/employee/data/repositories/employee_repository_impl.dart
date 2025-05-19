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
      nombreCompleto: e.nombreCompleto,
      nacimiento: e.nacimiento,
      correoElectronico: e.correoElectronico,
      numeroTelefono: e.numeroTelefono,
      dni: e.dni,
      sueldo: e.sueldo,
      cargo: e.cargo,
      fechaContratacion: e.fechaContratacion,
      activo: e.activo,
    );
    await service.addEmployee(model);
  }

  @override
  Future<void> deleteEmployee(String dni) async {
    await service.deleteEmployee(dni);
  }

  @override
  Future<List<Employee>> getAllEmployees() async {
    final models = await service.fetchEmployees();
    return models.map((m) => _mapModelToEntity(m)).toList();
  }

  @override
  Future<List<Employee>> getEmployees() async {
    final models = await service.fetchEmployees();
    return models.map((m) => _mapModelToEntity(m)).toList();
  }

  Future<bool> addEmployeeWithoutId(Employee employee) async {
    try {
      final model = EmployeeModel(
        nombreCompleto: employee.nombreCompleto,
        nacimiento: employee.nacimiento,
        correoElectronico: employee.correoElectronico,
        numeroTelefono: employee.numeroTelefono,
        dni: employee.dni,
        sueldo: employee.sueldo,
        cargo: employee.cargo,
        fechaContratacion: employee.fechaContratacion,
        activo: employee.activo,
      );
      final response = await service.addEmployee(model);
      return response;
    } catch (e) {
      return false;
    }
  }

  Employee _mapModelToEntity(EmployeeModel m) {
    return Employee(
      id: m.id,
      nombreCompleto: m.nombreCompleto,
      nacimiento: m.nacimiento,
      correoElectronico: m.correoElectronico,
      numeroTelefono: m.numeroTelefono,
      dni: m.dni,
      sueldo: m.sueldo,
      cargo: m.cargo,
      fechaContratacion: m.fechaContratacion,
      activo: m.activo,
    );
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    final model = EmployeeModel(
      id: employee.id,
      nombreCompleto: employee.nombreCompleto,
      nacimiento: employee.nacimiento,
      correoElectronico: employee.correoElectronico,
      numeroTelefono: employee.numeroTelefono,
      dni: employee.dni,
      sueldo: employee.sueldo,
      cargo: employee.cargo,
      fechaContratacion: employee.fechaContratacion,
      activo: employee.activo,
    );
    await service.updateEmployee(model);
  }
}
