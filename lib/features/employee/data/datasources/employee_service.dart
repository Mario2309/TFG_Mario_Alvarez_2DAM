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

  Future<void> deleteEmployee(int id) async {
    final response = await supabase.from('empleado').delete().eq('id', id);
    if (response.error != null) {
      throw Exception('Failed to delete employee: ${response.error?.message}');
    }
  }

  Future<bool> updateEmployee(EmployeeModel employee) async {
  if (employee.id == null) {
    print('Error: El ID del empleado no puede ser nulo.');
    return false;
  }

  try {
    final response = await supabase
        .from('empleado')
        .update(employee.toJson())
        .eq('id', employee.id as Object);

    if (response.error != null) {
      print('Error al actualizar empleado: ${response.error?.message}');
      return false;
    }
    return true;
  } catch (e) {
    print('Error al actualizar empleado: $e');
    return false;
  }
}

}
