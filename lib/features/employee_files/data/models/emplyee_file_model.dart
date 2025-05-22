// lib/models/employee_file.dart
class EmployeeFileModel {
  int? id;
  int employeeId; // empleado_id
  String fileType; // tipo_archivo
  String fileName; // nombre_archivo
  String filePath; // ruta_archivo
  DateTime uploadDate; // fecha_subida
  String? notes; // observaciones

  EmployeeFileModel({
    this.id,
    required this.employeeId,
    required this.fileType,
    required this.fileName,
    required this.filePath,
    required this.uploadDate,
    this.notes,
  });

  // Método para convertir desde JSON
  factory EmployeeFileModel.fromJson(Map<String, dynamic> json) {
    return EmployeeFileModel(
      id: json['id'],
      employeeId: json['empleado_id'],
      fileType: json['tipo_archivo'],
      fileName: json['nombre_archivo'],
      filePath: json['ruta_archivo'],
      uploadDate: json['fecha_subida'],
      notes: json['observaciones'],
    );
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empleado_id': employeeId,
      'tipo_archivo': fileType,
      'nombre_archivo': fileName,
      'ruta_archivo': filePath,
      'fecha_subida': uploadDate,
      'observaciones': notes,
    };
  }
}
