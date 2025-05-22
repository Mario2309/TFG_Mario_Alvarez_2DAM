import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nexuserp/features/employee_files/domain/entities/employee_file.dart';
import 'package:nexuserp/features/employee_files/data/repositories/employee_file_repository_impl.dart';
import 'package:nexuserp/features/employee_files/data/datasources/employee_file_service.dart';

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
  String? _notes;
  bool _isUploading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();
  late final EmployeeFileRepositoryImpl _repository;
  late final EmployeeFileService _service;

  @override
  void initState() {
    super.initState();
    _service = EmployeeFileService();
    _repository = EmployeeFileRepositoryImpl(_service);
  }

  String _normalizeFileName(String name) {
    // Solo letras, números, guiones y puntos
    return name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null || _fileType == null) return;
    setState(() {
      _isUploading = true;
    });
    try {
      // Suponiendo que recibes el nombre del empleado como parámetro en el widget
      final employeeName = widget.employeeName
          .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
      final fileName = _selectedFile!.path.split(Platform.pathSeparator).last;
      final normalizedFileName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
      final filePath = '${employeeName}_$normalizedFileName';
      final fileBytes = await _selectedFile!.readAsBytes();
      if (fileBytes.isEmpty) {
        throw Exception('El archivo está vacío o dañado');
      }
      // Subir archivo a Supabase Storage
      final response = await _service.supabase.storage
          .from('empleados')
          .uploadBinary(filePath, fileBytes);
      if (response.isEmpty) {
        throw Exception('No se pudo subir el archivo');
      }
      final publicUrl = _service.supabase.storage
          .from('empleados')
          .getPublicUrl(filePath);
      final fileEntity = EmployeeFile(
        employeeId: widget.employeeId,
        fileType: _fileType!,
        fileName: normalizedFileName,
        filePath: publicUrl,
        uploadDate: DateTime.now(),
        notes: _notesController.text,
      );
      await _repository.uploadFile(fileEntity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archivo subido correctamente.')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al subir archivo: $e')));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subir archivo de empleado')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.attach_file),
                label: const Text('Seleccionar archivo'),
                onPressed: _pickFile,
              ),
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Archivo: ${_selectedFile!.path.split('/').last}',
                  ),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _fileType,
                items: const [
                  DropdownMenuItem(value: 'Contrato', child: Text('Contrato')),
                  DropdownMenuItem(value: 'Nómina', child: Text('Nómina')),
                  DropdownMenuItem(value: 'DNI', child: Text('DNI')),
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                ],
                onChanged: (value) => setState(() => _fileType = value),
                decoration: const InputDecoration(
                  labelText: 'Tipo de archivo',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value == null ? 'Selecciona un tipo' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Observaciones (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon:
                      _isUploading
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.cloud_upload),
                  label: Text(_isUploading ? 'Subiendo...' : 'Subir archivo'),
                  onPressed:
                      _isUploading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate() &&
                                _selectedFile != null) {
                              _uploadFile();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Selecciona un archivo y tipo.',
                                  ),
                                ),
                              );
                            }
                          },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
