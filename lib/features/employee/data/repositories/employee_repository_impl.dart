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
    return models
        .map(
          (m) => Employee(
            id: m.id,
            nombreCompleto: m.nombreCompleto,
            nacimiento: m.nacimiento,
            correoElectronico: m.correoElectronico,
            numeroTelefono: m.numeroTelefono,
            dni: m.dni,
          ),
        )
        .toList();
  }

  @override
  Future<List<Employee>> getEmployees() async {
    final models = await service.fetchEmployees();
    return models
        .map(
          (m) => Employee(
            id: m.id,
            nombreCompleto: m.nombreCompleto,
            nacimiento: m.nacimiento,
            correoElectronico: m.correoElectronico,
            numeroTelefono: m.numeroTelefono,
            dni: m.dni,
          ),
        )
        .toList();
  }

  // Método corregido para agregar un empleado sin el campo `id`
  Future<bool> addEmployeeWithoutId(Employee employee) async {
    try {
      // Crear el modelo de empleado, pero sin incluir el id
      final model = EmployeeModel(
        nombreCompleto: employee.nombreCompleto,
        nacimiento: employee.nacimiento,
        correoElectronico: employee.correoElectronico,
        numeroTelefono: employee.numeroTelefono,
        dni: employee.dni,
      );

      // Llamada al servicio para agregar el empleado
      final response = await service.addEmployee(model);

      // Si la respuesta es exitosa (por ejemplo, código 200), retornamos true
      return true;
    } catch (e) {
      // En caso de error, devolvemos false
      return false;
    }
  }
}
