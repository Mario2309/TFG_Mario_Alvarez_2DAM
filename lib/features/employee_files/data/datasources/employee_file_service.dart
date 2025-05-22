import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/emplyee_file_model.dart';

class EmployeeFileService {
  final supabase = Supabase.instance.client;

  /// Obtener todos los archivos asociados a un empleado
  Future<List<EmployeeFileModel>> fetchFiles(int employeeId) async {
    final response = await supabase
        .from('empleado_archivo')
        .select()
        .eq('empleado_id', employeeId);

    return (response as List)
        .map((e) => EmployeeFileModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Agregar un nuevo archivo
  Future<bool> addFile(EmployeeFileModel file) async {
    try {
      await supabase.from('empleado_archivo').insert(file.toJson());
      return true;
    } catch (e) {
      print('Error al insertar archivo: $e');
      return false;
    }
  }

  /// Eliminar un archivo por ID
  Future<bool> deleteFile(int fileId) async {
    try {
      await supabase.from('empleado_archivo').delete().eq('id', fileId);
      return true;
    } catch (e) {
      print('Error al eliminar archivo: $e');
      return false;
    }
  }

  /// Actualizar un archivo existente
  Future<bool> updateFile(EmployeeFileModel file) async {
    if (file.id == null) {
      print('Error: El ID del archivo no puede ser nulo.');
      return false;
    }

    try {
      await supabase
          .from('empleado_archivo')
          .update(file.toJson())
          .eq('id', file.id as int);
      return true;
    } catch (e) {
      print('Error al actualizar archivo: $e');
      return false;
    }
  }
}
