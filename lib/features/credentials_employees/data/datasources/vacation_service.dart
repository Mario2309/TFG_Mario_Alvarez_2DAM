import 'package:nexuserp/features/credentials_employees/domain/entities/credential_employess.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/credential_employee_model.dart';

class CredentialService {
  final supabase = Supabase.instance.client;

  // Obtener las credenciales de un empleado por DNI
  Future<EmployeeCredentialModel?> getCredentialByDni(String dni) async {
    try {
      final response =
          await supabase
              .from('credencial_empleado')
              .select()
              .eq('empleado_dni', dni)
              .single();

      return EmployeeCredentialModel.fromJson(response);
    } on PostgrestException catch (e) {
      print('🔴 Error PostgREST al obtener credencial: ${e.message}');
      return null;
    } catch (e) {
      print('🔴 Error inesperado al obtener credencial: $e');
      return null;
    }
  }

  // Agregar credenciales nuevas
  Future<bool> addCredential(EmployeeCredentialModel credential) async {
    try {
      final data = credential.toJson();
      final response =
          await supabase.from('credencial_empleado').insert(data).select();

      if (response != null && response is List && response.isNotEmpty) {
        print('🟢 Credencial insertada correctamente: ${response.first}');
        return true;
      } else {
        print('🔴 Fallo al insertar credencial. Respuesta: $response');
        return false;
      }
    } on PostgrestException catch (e) {
      print('🔴 Error PostgREST al insertar credencial: ${e.message}');
      return false;
    } catch (e) {
      print('🔴 Error inesperado al insertar credencial: $e');
      return false;
    }
  }

  // Actualizar el correo electrónico
  Future<bool> updateEmail(String dni, String newEmail) async {
    try {
      await supabase
          .from('credencial_empleado')
          .update({'correo_electronico': newEmail})
          .eq('empleado_dni', dni);
      return true;
    } catch (e) {
      print('Error al actualizar correo electrónico: $e');
      return false;
    }
  }

  // Actualizar la contraseña (ya debe venir hasheada)
  Future<bool> updatePassword(String dni, String newHashedPassword) async {
    try {
      await supabase
          .from('credencial_empleado')
          .update({'contrasena_hashed': newHashedPassword})
          .eq('empleado_dni', dni);
      return true;
    } catch (e) {
      print('Error al actualizar contraseña: $e');
      return false;
    }
  }

  // Eliminar credenciales por DNI
  Future<bool> deleteCredential(String dni) async {
    try {
      await supabase
          .from('credencial_empleado')
          .delete()
          .eq('empleado_dni', dni);
      return true;
    } catch (e) {
      print('Error al eliminar credencial: $e');
      return false;
    }
  }
}
