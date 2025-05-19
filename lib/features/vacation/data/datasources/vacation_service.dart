import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vacation_model.dart';

class VacationService {
  final supabase = Supabase.instance.client;

  // Obtener todas las solicitudes de vacaciones
  Future<List<VacationModel>> fetchVacations() async {
    try {
      final response = await supabase.from('vacaciones').select();
      return (response as List)
          .map((v) => VacationModel.fromJson(v as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener vacaciones: $e');
      return [];
    }
  }

  // Agregar una nueva solicitud de vacaciones
  Future<bool> addVacation(VacationModel vacation) async {
    try {
      await supabase.from('vacaciones').insert(vacation.toJson());
      return true;
    } catch (e) {
      print('Error al insertar vacaciones: $e');
      return false;
    }
  }

  // Eliminar una solicitud de vacaciones por ID
  Future<bool> deleteVacation(dynamic id) async {
    try {
      await supabase.from('vacaciones').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error al eliminar vacaciones: $e');
      return false;
    }
  }

  // Actualizar una solicitud de vacaciones por ID
  Future<bool> updateVacation(VacationModel vacation) async {
    if (vacation.id == null) {
      print('Error: El ID de la solicitud no puede ser nulo.');
      return false;
    }

    try {
      await supabase
          .from('vacaciones')
          .update(vacation.toJson())
          .eq('employeeDni', vacation.employeeDni);
      return true;
    } catch (e) {
      print('Error al actualizar vacaciones: $e');
      return false;
    }
  }

  // Obtener vacaciones por DNI del empleado
  Future<List<VacationModel>> fetchVacationsByDni(String dni) async {
    try {
      final response = await supabase
          .from('vacaciones')
          .select()
          .eq('employeeDni', dni);

      return (response as List)
          .map((v) => VacationModel.fromJson(v as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener vacaciones por DNI: $e');
      return [];
    }
  }
}
