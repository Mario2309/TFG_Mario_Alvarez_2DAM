import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_signing_model.dart';

class EmployeeSingingService {
  final supabase = Supabase.instance.client;

  // Obtener todos los fichajes
  Future<List<EmployeeSigningModel>> fetchAllAttendances() async {
    final response = await supabase.from('fichaje').select();

    return (response as List)
        .map((e) => EmployeeSigningModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Obtener fichajes por ID de empleado
  Future<List<EmployeeSigningModel>> fetchAttendancesByEmployee(
    int employeeId,
  ) async {
    final response = await supabase
        .from('fichaje')
        .select()
        .eq('empleado_id', employeeId);

    return (response as List)
        .map((e) => EmployeeSigningModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Obtener fichajes por fecha (YYYY-MM-DD)
  Future<List<EmployeeSigningModel>> fetchAttendancesByDate(
    DateTime date,
  ) async {
    final formattedDate = date.toIso8601String().split('T').first;

    final response = await supabase
        .from('fichaje')
        .select()
        .like('fecha', '$formattedDate%');

    return (response as List)
        .map((e) => EmployeeSigningModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Insertar nuevo fichaje
  Future<bool> addAttendance(EmployeeSigningModel attendance) async {
    try {
      await supabase.from('fichaje').insert(attendance.toJson());
      return true;
    } catch (e) {
      print('Error inserting attendance: $e');
      return false;
    }
  }

  // Actualizar fichaje existente
  Future<bool> updateAttendance(EmployeeSigningModel attendance) async {
    if (attendance.id == null) {
      print('Error: Attendance ID cannot be null.');
      return false;
    }

    try {
      await supabase
          .from('fichaje')
          .update(attendance.toJson())
          .eq('id', attendance.id as int);

      return true;
    } catch (e) {
      print('Error updating attendance: $e');
      return false;
    }
  }

  // Eliminar fichaje por ID
  Future<bool> deleteAttendance(int id) async {
    try {
      await supabase.from('fichaje').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting attendance: $e');
      return false;
    }
  }
}
