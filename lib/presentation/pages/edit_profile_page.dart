import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:html' as html;

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
    _descriptionController = TextEditingController(text: metadata['description'] ?? '');
    _avatarUrlController = TextEditingController(text: metadata['avatar_url'] ?? '');
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _selectedImage = File(pickedFile.name); // solo por nombre
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
    final fileExt = kIsWeb
        ? path.extension(_selectedImage!.path)
        : path.extension(_selectedImage!.path);
    final fileName = 'avatar_$userId$fileExt';
    final filePath = 'avatars/$fileName';

    final mimeType = lookupMimeType(_selectedImage!.path);
    final bytes = kIsWeb
        ? _webImageBytes!
        : await _selectedImage!.readAsBytes();

    final response = await supabase.storage.from('avatars').uploadBinary(
      filePath,
      bytes,
      fileOptions: FileOptions(
        contentType: mimeType,
        upsert: true,
      ),
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
          SnackBar(content: Text('Perfil actualizado correctamente.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar perfil: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarPreview = _webImageBytes != null
        ? Image.memory(_webImageBytes!, height: 100, width: 100, fit: BoxFit.cover)
        : (_selectedImage != null && !kIsWeb
            ? Image.file(_selectedImage!, height: 100, width: 100, fit: BoxFit.cover)
            : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                ? Image.network(_avatarUrl!, height: 100, width: 100)
                : const Icon(Icons.person, size: 100)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _webImageBytes != null
                      ? MemoryImage(_webImageBytes!)
                      : (_selectedImage != null && !kIsWeb
                          ? FileImage(_selectedImage!)
                          : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                              ? NetworkImage(_avatarUrl!) as ImageProvider
                              : null)),
                  child: _webImageBytes == null &&
                          (_selectedImage == null || (kIsWeb && _selectedImage != null)) &&
                          (_avatarUrl == null || _avatarUrl!.isEmpty)
                      ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey.shade700)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value == null || value.isEmpty ? 'Introduce tu nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) => value == null || value.isEmpty ? 'Introduce tu teléfono' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avatarUrlController,
                decoration: const InputDecoration(labelText: 'Avatar URL (opcional)'),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar Cambios'),
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}