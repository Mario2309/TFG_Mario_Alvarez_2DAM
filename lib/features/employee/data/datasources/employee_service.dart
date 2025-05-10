import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_model.dart';

class EmployeeService {
  final supabase = Supabase.instance.client;

  Future<List<EmployeeModel>> fetchEmployees() async {
    final response = await supabase.from('empleado').select();
    return (response as List).map((e) => EmployeeModel.fromJson(e)).toList();
  }

  Future<void> addEmployee(EmployeeModel emp) async {
    await supabase.from('empleado').insert(emp.toJson());
  }

  Future<void> deleteEmployee(int id) async {
    final response = await supabase.from('empleado').delete().eq('id', id);
    if (response.error != null) {
      throw Exception('Failed to delete employee: ${response.error?.message}');
    }
  }
}
