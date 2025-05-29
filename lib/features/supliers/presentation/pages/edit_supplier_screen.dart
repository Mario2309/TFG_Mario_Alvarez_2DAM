import 'package:flutter/material.dart';
import 'package:nexuserp/core/utils/suppliers_strings.dart';
import '../../data/models/supplier_model.dart';
import '../../data/datasources/suppliers_service.dart';

/// Página para editar la información de un proveedor existente.
class EditSupplierPage extends StatefulWidget {
  /// Modelo del proveedor a editar.
  final SupplierModel supplier;

  /// Servicio para operaciones de proveedor.
  final SupplierService supplierService;

  /// Constructor de la página de edición de proveedor.
  const EditSupplierPage({
    Key? key,
    required this.supplier,
    required this.supplierService,
  }) : super(key: key);

  @override
  _EditSupplierPageState createState() => _EditSupplierPageState();
}

/// Estado para la página de edición de proveedor.
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

  /// Envía el formulario y actualiza el proveedor si es válido.
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

  /// Muestra un diálogo de error si la actualización falla.
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(SuppliersStrings.error),
            content: Text(SuppliersStrings.updateError),
            actions: [
              TextButton(
                child: Text(SuppliersStrings.accept),
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
        title: Text(SuppliersStrings.editSupplier),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: SuppliersStrings.name,
                controller: _nombreController,
                icon: Icons.business,
              ),
              _buildTextField(
                label: SuppliersStrings.nifCif,
                controller: _nifCifController,
                icon: Icons.badge,
              ),
              _buildTextField(
                label: SuppliersStrings.contactPerson,
                controller: _personaContactoController,
                icon: Icons.person,
              ),
              _buildTextField(
                label: SuppliersStrings.phone,
                controller: _telefonoController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: SuppliersStrings.email,
                controller: _correoController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                label: SuppliersStrings.address,
                controller: _direccionController,
                icon: Icons.location_on,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(SuppliersStrings.cancel),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                    ),
                    child: Text(SuppliersStrings.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un campo de texto con validación y estilo estándar.
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
                value == null || value.isEmpty
                    ? SuppliersStrings.requiredField
                    : null,
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
