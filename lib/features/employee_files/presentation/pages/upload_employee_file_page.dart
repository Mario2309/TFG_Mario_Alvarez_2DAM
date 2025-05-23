import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nexuserp/features/employee_files/domain/entities/employee_file.dart';
import 'package:nexuserp/features/employee_files/data/repositories/employee_file_repository_impl.dart';
import 'package:nexuserp/features/employee_files/data/datasources/employee_file_service.dart';

// Esta página permite a los usuarios subir archivos relacionados con un empleado,
// especificando el tipo de archivo y añadiendo observaciones.
class UploadEmployeeFilePage extends StatefulWidget {
  final int employeeId;
  final String employeeName;

  const UploadEmployeeFilePage({
    Key? key,
    required this.employeeId,
    required this.employeeName,
  }) : super(key: key);

  @override
  State<UploadEmployeeFilePage> createState() => _UploadEmployeeFilePageState();
}

class _UploadEmployeeFilePageState extends State<UploadEmployeeFilePage> {
  File? _selectedFile;
  String? _fileType;
  final TextEditingController _notesController = TextEditingController();
  bool _isUploading = false;
  final _formKey = GlobalKey<FormState>();

  // Repositorio para interactuar con el servicio de archivos de empleado.
  late final EmployeeFileRepositoryImpl _repository;
  // Servicio para interactuar con Supabase Storage.
  late final EmployeeFileService _service;

  @override
  void initState() {
    super.initState();
    _service = EmployeeFileService();
    _repository = EmployeeFileRepositoryImpl(_service);
  }

  @override
  void dispose() {
    _notesController
        .dispose(); // Libera el controlador cuando el widget se destruye.
    super.dispose();
  }

  // Normaliza el nombre de un archivo para asegurar que sea seguro para URLs y rutas.
  String _normalizeFileName(String name) {
    // Solo permite letras, números, guiones y puntos. Reemplaza otros caracteres con '_'.
    return name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }

  // Abre el selector de archivos para que el usuario elija un archivo.
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Sube el archivo seleccionado y registra su información en la base de datos.
  Future<void> _uploadFile() async {
    // Valida el formulario antes de intentar la subida.
    if (!_formKey.currentState!.validate() || _selectedFile == null) {
      _showSnackBar(
        'Por favor, selecciona un archivo y un tipo de archivo.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isUploading = true; // Activa el indicador de carga.
    });

    try {
      // Normalizar nombre de empleado y archivo para evitar problemas en la ruta de almacenamiento.
      final employeeNameNormalized = widget.employeeName.replaceAll(
        RegExp(r'[^A-Za-z0-9._-]'),
        '_',
      );
      final fileName = _selectedFile!.path.split(Platform.pathSeparator).last;
      final normalizedFileName = _normalizeFileName(fileName);
      final filePath =
          '$employeeNameNormalized/$normalizedFileName'; // Ruta en el almacenamiento.
      final fileBytes = await _selectedFile!.readAsBytes();

      if (fileBytes.isEmpty) {
        throw Exception('El archivo está vacío o dañado.');
      }

      // Subir archivo a Supabase Storage.
      // Se asume que 'empleados' es el bucket de almacenamiento.
      await _service.supabase.storage
          .from('empleados')
          .uploadBinary(filePath, fileBytes);

      // Obtener URL pública del archivo subido.
      final publicUrl = _service.supabase.storage
          .from('empleados')
          .getPublicUrl(filePath);

      // Crear entidad EmployeeFile para registrar en la base de datos.
      final fileEntity = EmployeeFile(
        employeeId: widget.employeeId,
        fileType: _fileType!,
        fileName: normalizedFileName,
        filePath: publicUrl, // Guardar la URL pública.
        uploadDate: DateTime.now(),
        notes: _notesController.text.trim(), // Eliminar espacios en blanco.
      );

      // Registrar archivo en la tabla empleado_archivo.
      await _repository.uploadFile(fileEntity);

      if (mounted) {
        _showSnackBar('Archivo subido correctamente.', isError: false);
        Navigator.pop(
          context,
          true,
        ); // Vuelve a la página anterior indicando éxito.
      }
    } catch (e) {
      // Muestra un mensaje de error si algo sale mal durante la subida o registro.
      _showSnackBar(
        'Error al subir o registrar archivo: ${e.toString().split(':').last.trim()}',
        isError: true,
      );
    } finally {
      setState(() {
        _isUploading = false; // Desactiva el indicador de carga.
      });
    }
  }

  // Muestra un SnackBar con un mensaje, con estilo para errores o éxitos.
  void _showSnackBar(String message, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? Colors.red.shade600 : Colors.green.shade600,
          behavior: SnackBarBehavior.floating, // Hace que el SnackBar flote.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ), // Bordes redondeados.
          margin: const EdgeInsets.all(16), // Margen alrededor del SnackBar.
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subir Archivo - ${widget.employeeName.split(' ').first}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), // Padding uniforme y generoso.
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .stretch, // Estira los elementos horizontalmente.
            children: [
              const SizedBox(height: 20),
              Text(
                'Adjunta un nuevo documento para ${widget.employeeName.split(' ').first}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Botón para seleccionar archivo.
              ElevatedButton.icon(
                icon: const Icon(Icons.attach_file, size: 24),
                label: Text(
                  _selectedFile != null
                      ? 'Archivo Seleccionado'
                      : 'Seleccionar Archivo',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: _pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedFile != null
                          ? Colors.green.shade600
                          : Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
              ),
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Archivo: ${_selectedFile!.path.split(Platform.pathSeparator).last}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),

              // Selector de tipo de archivo.
              DropdownButtonFormField<String>(
                value: _fileType,
                decoration: InputDecoration(
                  labelText: 'Tipo de Archivo',
                  hintText: 'Selecciona el tipo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue.shade300,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50.withOpacity(0.5),
                  prefixIcon: Icon(Icons.category, color: Colors.blue.shade700),
                ),
                items: const [
                  DropdownMenuItem(value: 'Contrato', child: Text('Contrato')),
                  DropdownMenuItem(value: 'Nómina', child: Text('Nómina')),
                  DropdownMenuItem(value: 'DNI', child: Text('DNI')),
                  DropdownMenuItem(
                    value: 'Certificado',
                    child: Text('Certificado'),
                  ), // Añadido un tipo más
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                ],
                onChanged: (value) => setState(() => _fileType = value),
                validator:
                    (value) =>
                        value == null
                            ? 'Por favor, selecciona un tipo de archivo.'
                            : null,
                style: TextStyle(fontSize: 16, color: Colors.blue.shade800),
                dropdownColor: Colors.white,
              ),
              const SizedBox(height: 20),

              // Campo de texto para observaciones.
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Observaciones (opcional)',
                  hintText: 'Añade cualquier nota relevante aquí',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50.withOpacity(0.5),
                  prefixIcon: Icon(Icons.notes, color: Colors.grey.shade600),
                ),
                maxLines: 3, // Permite más líneas para las observaciones.
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 40),

              // Botón de subida de archivo.
              ElevatedButton.icon(
                onPressed:
                    _isUploading
                        ? null
                        : _uploadFile, // Deshabilita si está subiendo.
                icon:
                    _isUploading
                        ? const SizedBox(
                          width:
                              24, // Tamaño ligeramente más grande para el indicador.
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5, // Grosor del indicador.
                          ),
                        )
                        : const Icon(
                          Icons.cloud_upload_rounded,
                          size: 28,
                        ), // Icono de subida más moderno.
                label: Text(
                  _isUploading ? 'Subiendo...' : 'Subir Archivo',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 24,
                  ), // Mayor padding.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10, // Mayor sombra.
                  shadowColor: Colors.blue.shade900.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
