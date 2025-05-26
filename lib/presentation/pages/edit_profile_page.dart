import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _avatarUrlController;
  late TextEditingController _phoneController;

  bool _isLoading = false;
  File? _selectedImage;
  Uint8List? _webImageBytes;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    final user = supabase.auth.currentUser;
    final metadata = user?.userMetadata ?? {};

    _nameController = TextEditingController(text: metadata['name'] ?? '');
    _descriptionController = TextEditingController(
      text: metadata['description'] ?? '',
    );
    _avatarUrlController = TextEditingController(
      text: metadata['avatar_url'] ?? '',
    );
    _phoneController = TextEditingController(text: metadata['phone'] ?? '');
    _avatarUrl = metadata['avatar_url'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _avatarUrlController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _selectedImage = File(pickedFile.name); // just for name
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<String?> _uploadImage() async {
    final userId = supabase.auth.currentUser!.id;
    final fileExt =
        kIsWeb
            ? path.extension(_selectedImage!.path)
            : path.extension(_selectedImage!.path);
    final fileName = 'avatar_$userId$fileExt';
    final filePath = 'avatars/$fileName';

    final mimeType = lookupMimeType(_selectedImage!.path);
    final bytes =
        kIsWeb ? _webImageBytes! : await _selectedImage!.readAsBytes();

    final response = await supabase.storage
        .from('avatars')
        .uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(contentType: mimeType, upsert: true),
        );

    if (response.isEmpty) {
      return supabase.storage.from('avatars').getPublicUrl(filePath);
    }

    return null;
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String avatarUrl = _avatarUrlController.text.trim();

      if (_selectedImage != null) {
        final uploadedUrl = await _uploadImage();
        if (uploadedUrl != null) {
          avatarUrl = uploadedUrl;
        }
      }

      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'name': _nameController.text.trim(),
            'description': _descriptionController.text.trim(),
            'avatar_url': avatarUrl,
            'phone': _phoneController.text.trim(),
          },
        ),
      );

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado correctamente.'),
            duration: Duration(seconds: 3), // Added duration
            backgroundColor: Colors.green, // Color de éxito
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar perfil: $e'),
          duration: const Duration(
            seconds: 5,
          ), // Duración más larga para errores
          backgroundColor: Colors.red, // Color de error
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Función para crear la decoración de entrada de texto con el estilo deseado
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.blue.shade500,
        ), // Borde azul por defecto
      ),
      enabledBorder: OutlineInputBorder(
        // Definir explícitamente el borde habilitado
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.blue.shade500,
        ), // Borde azul por defecto
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.blue.shade700, // Color de enfoque más oscuro
          width: 2, // Borde de enfoque ligeramente más grueso
        ),
      ),
      errorBorder: OutlineInputBorder(
        // Definir borde de error
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        // Definir borde de error enfocado
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarPreview =
        _webImageBytes != null
            ? Image.memory(
              _webImageBytes!,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            )
            : (_selectedImage != null && !kIsWeb
                ? Image.file(
                  _selectedImage!,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                )
                : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                    ? Image.network(
                      _avatarUrl!,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    )
                    : const Icon(Icons.person, size: 60, color: Colors.grey)));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo claro
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            fontWeight: FontWeight.w600, // Título ligeramente más negrita
            color: Colors.white, // Color de título blanco
          ),
        ),
        backgroundColor: Colors.blue.shade700, // Barra de aplicación azul
        iconTheme: const IconThemeData(
          color: Colors.white, // Color de icono blanco
        ),
        elevation: 0, // Sombra de la barra de aplicación eliminada
        centerTitle: true, // Centrar título
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Alineación central
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade300,
                      child: ClipOval(
                        child: avatarPreview,
                      ), // Asegura que la imagen sea circular
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600, // Color azul
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Nombre'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Introduce tu nombre'
                            : null,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: _buildInputDecoration('Descripción'),
                maxLines: 3,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: _buildInputDecoration('Teléfono'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Introduce tu teléfono'
                            : null,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avatarUrlController,
                decoration: _buildInputDecoration('Avatar URL (opcional)'),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width:
                    double.infinity, // Asegura que el botón ocupe todo el ancho
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Guardar Cambios',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue.shade600, // Color azul del botón
                    foregroundColor: Colors.white, // Color del texto del botón
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    elevation: 4, // Elevación aumentada
                    shadowColor: Colors.blue.withOpacity(0.3), // Sombra
                  ),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: CircularProgressIndicator(
                    color: Colors.blue, // Color azul del indicador de carga
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
