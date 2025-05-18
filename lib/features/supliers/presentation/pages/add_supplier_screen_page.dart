// lib/features/supliers/presentation/pages/add_supplier_screen_page.dart
import 'package:flutter/material.dart';
import 'package:nexuserp/features/supliers/data/models/supplier_model.dart';
import 'package:nexuserp/features/supliers/domain/entities/supplier.dart';

import '../../data/datasources/suppliers_service.dart';

class AddSupplierScreen extends StatefulWidget {
  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final SupplierService _supplierService = SupplierService();

  @override
  void dispose() {
    _nameController.dispose();
    _taxIdController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newSupplier = SupplierModel(
        id: null,
        nombre: _nameController.text.trim(),
        nifCif: _taxIdController.text.trim(),
        personaContacto: _contactPersonController.text.trim(),
        telefono: _phoneController.text.trim(),
        correoElectronico: _emailController.text.trim(),
        direccion:
            _addressController.text.trim().isNotEmpty
                ? _addressController.text.trim()
                : null,
      );

      try {
        await _supplierService.addSupplier(newSupplier);
        Navigator.pop(context, true); // Puede indicar éxito con 'true'
      } catch (e) {
        // Manejar error (puedes mostrar un diálogo o snackbar)
        print('Error al agregar supplier: $e');
        // Opcional: mostrar mensaje al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el proveedor')),
        );
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        validator:
            validator ?? (value) => value!.isEmpty ? 'Campo requerido' : null,
        decoration: InputDecoration(
          prefixIcon:
              icon != null ? Icon(icon, color: Colors.blue.shade700) : null,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Proveedor'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Nombre',
                controller: _nameController,
                icon: Icons.business,
              ),
              _buildTextField(
                label: 'NIF/CIF (Opcional)',
                controller: _taxIdController,
                icon: Icons.badge,
                validator: (value) => null,
              ),
              _buildTextField(
                label: 'Persona de Contacto (Opcional)',
                controller: _contactPersonController,
                icon: Icons.person_outline,
                validator: (value) => null,
              ),
              _buildTextField(
                label: 'Teléfono (Opcional)',
                controller: _phoneController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => null,
              ),
              _buildTextField(
                label: 'Email (Opcional)',
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => null,
              ),
              _buildTextField(
                label: 'Dirección (Opcional)',
                controller: _addressController,
                icon: Icons.location_on,
                validator: (value) => null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
