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
  // Agregar una nueva solicitud de vacaciones
  Future<bool> addVacation(VacationModel vacation) async {
    try {
      final data = vacation.toJson();
      print('🟡 Enviando a Supabase: $data');

      final response = await supabase.from('vacaciones').insert(data).select();

      if (response != null && response is List && response.isNotEmpty) {
        print('🟢 Vacación insertada correctamente: ${response.first}');
        return true;
      } else {
        print('🔴 Insert falló sin error aparente. Respuesta: $response');
        return false;
      }
    } on PostgrestException catch (e) {
      print('🔴 Error PostgREST: ${e.message}');
      return false;
    } catch (e) {
      print('🔴 Error inesperado al insertar vacaciones: $e');
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
          .eq('id', vacation.id as int);
      return true;
    } catch (e) {
      print('Error al actualizar vacaciones: $e');
      return false;
    }
  }

  // Actualizar solo el estado de una solicitud de vacaciones
  Future<void> updateVacationStatus(int id, String newStatus) async {
    try {
      await supabase
          .from('vacaciones')
          .update({'status': newStatus})
          .eq('id', id);
    } catch (e) {
      print('Error al actualizar el estado de la vacación: $e');
      rethrow;
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
