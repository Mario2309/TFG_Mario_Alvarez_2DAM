import 'dart:io';
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
  late TextEditingController _companyController;
  late TextEditingController _addressController;

  bool _isLoading = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    final user = supabase.auth.currentUser;
    final metadata = user?.userMetadata ?? {};

    _nameController = TextEditingController(text: metadata['name'] ?? '');
    _descriptionController = TextEditingController(text: metadata['description'] ?? '');
    _avatarUrlController = TextEditingController(text: metadata['avatar_url'] ?? '');
    _phoneController = TextEditingController(text: metadata['phone'] ?? '');
    _companyController = TextEditingController(text: metadata['company'] ?? '');
    _addressController = TextEditingController(text: metadata['address'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _avatarUrlController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final userId = supabase.auth.currentUser!.id;
    final fileExt = path.extension(imageFile.path);
    final fileName = 'avatar_$userId$fileExt';
    final filePath = 'avatars/$fileName';

    final mimeType = lookupMimeType(imageFile.path);

    final bytes = await imageFile.readAsBytes();

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
        final uploadedUrl = await _uploadImage(_selectedImage!);
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
    final avatarPreview = _selectedImage != null
        ? Image.file(_selectedImage!, height: 100, width: 100, fit: BoxFit.cover)
        : (_avatarUrlController.text.isNotEmpty
            ? Image.network(_avatarUrlController.text, height: 100, width: 100)
            : const Icon(Icons.person, size: 100));

    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_avatarUrlController.text.isNotEmpty
                          ? NetworkImage(_avatarUrlController.text) as ImageProvider
                          : null),
                  child: _selectedImage == null && _avatarUrlController.text.isEmpty
                      ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey.shade700)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) => value == null || value.isEmpty ? 'Introduce tu nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) => value == null || value.isEmpty ? 'Introduce tu teléfono' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avatarUrlController,
                decoration: InputDecoration(labelText: 'Avatar URL (opcional)'),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Guardar Cambios'),
                onPressed: _isLoading ? null : _updateProfile,
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
