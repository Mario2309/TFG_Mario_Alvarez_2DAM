import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_model.dart';

class EmployeeService {
  final supabase = Supabase.instance.client;

  Future<List<EmployeeModel>> fetchEmployees() async {
    final response = await supabase.from('empleado').select();
    return (response as List).map((e) => EmployeeModel.fromJson(e)).toList();
  }

  Future<bool> addEmployee(EmployeeModel emp) async {
    await supabase.from('empleado').insert(emp.toJson());
    return false;
  }

  Future<void> deleteEmployee(String dni) async {
    final response = await supabase.from('empleado').delete().eq('dni', dni);
    if (response.error != null) {
      throw Exception('Failed to delete employee: ${response.error?.message}');
    }
  }

  Future<bool> updateEmployee(EmployeeModel employee) async {
    if (employee.dni == null) {
      print('Error: El DNI del empleado no puede ser nulo.');
      return false;
    }

    try {
      final response = await supabase
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
