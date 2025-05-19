import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_model.dart';

class EmployeeService {
  final supabase = Supabase.instance.client;

  Future<List<EmployeeModel>> fetchEmployees() async {
    final response = await supabase.from('empleado').select();

    return (response as List)
        .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> addEmployee(EmployeeModel emp) async {
    try {
      await supabase.from('empleado').insert(emp.toJson());
      return true;
    } catch (e) {
      print('Error al insertar empleado: $e');
      return false;
    }
  }

  Future<bool> deleteEmployee(String dni) async {
    try {
      await supabase.from('empleado').delete().eq('dni', dni);
      return true;
    } catch (e) {
      print('Error al eliminar empleado: $e');
      return false;
    }
  }

  Future<bool> updateEmployee(EmployeeModel employee) async {
    if (employee.dni.isEmpty) {
      print('Error: El DNI del empleado no puede estar vacío.');
      return false;
    }

    try {
      await supabase
          .from('empleado')
          .update(employee.toJson())
          .eq('dni', employee.dni);

      return true;
    } catch (e) {
      print('Error al actualizar empleado: $e');
      return false;
    }
  }
}
