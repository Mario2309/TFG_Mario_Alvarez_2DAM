import 'package:flutter/material.dart';
import '../../data/models/supplier_model.dart';
import '../../data/datasources/suppliers_service.dart';

class EditSupplierPage extends StatefulWidget {
  final SupplierModel supplier;
  final SupplierService supplierService;

  const EditSupplierPage({
    Key? key,
    required this.supplier,
    required this.supplierService,
  }) : super(key: key);

  @override
  _EditSupplierPageState createState() => _EditSupplierPageState();
}

class _EditSupplierPageState extends State<EditSupplierPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _nifCifController;
  late TextEditingController _personaContactoController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoController;
  late TextEditingController _direccionController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.supplier.nombre);
    _nifCifController = TextEditingController(text: widget.supplier.nifCif);
    _personaContactoController = TextEditingController(
      text: widget.supplier.personaContacto,
    );
    _telefonoController = TextEditingController(text: widget.supplier.telefono);
    _correoController = TextEditingController(
      text: widget.supplier.correoElectronico,
    );
    _direccionController = TextEditingController(
      text: widget.supplier.direccion,
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _nifCifController.dispose();
    _personaContactoController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedSupplier = SupplierModel(
        id: widget.supplier.id,
        nombre: _nombreController.text,
        nifCif: _nifCifController.text,
        personaContacto: _personaContactoController.text,
        telefono: _telefonoController.text,
        correoElectronico: _correoController.text,
        direccion: _direccionController.text,
      );

      final success = await widget.supplierService.updateSupplier(
        updatedSupplier,
      );

      if (success) {
        Navigator.pop(context, true);
      } else {
        _showErrorDialog();
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'No se pudo actualizar el proveedor. Inténtalo nuevamente.',
            ),
            actions: [
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Proveedor'),
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
                controller: _nombreController,
                icon: Icons.business,
              ),
              _buildTextField(
                label: 'NIF/CIF',
                controller: _nifCifController,
                icon: Icons.badge,
              ),
              _buildTextField(
                label: 'Persona de Contacto',
                controller: _personaContactoController,
                icon: Icons.person,
              ),
              _buildTextField(
                label: 'Teléfono',
                controller: _telefonoController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: 'Correo Electrónico',
                controller: _correoController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                label: 'Dirección',
                controller: _direccionController,
                icon: Icons.location_on,
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
                    ),
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Campo requerido' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
}
