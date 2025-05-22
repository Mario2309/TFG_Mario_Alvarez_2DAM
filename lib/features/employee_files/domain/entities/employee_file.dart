class EmployeeFile {
  int? id;
  int employeeId; // empleado_id
  String fileType; // tipo_archivo
  String fileName; // nombre_archivo
  String filePath; // ruta_archivo
  DateTime uploadDate; // fecha_subida
  String? notes; // observaciones

  EmployeeFile({
    this.id,
    required this.employeeId,
    required this.fileType,
    required this.fileName,
    required this.filePath,
    required this.uploadDate,
    this.notes,
  });
}
