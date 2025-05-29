import 'package:flutter/material.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/core/utils/products_strings.dart';

/// Pantalla para agregar un nuevo producto al inventario.
class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _proveedorIdController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _stockController.dispose();
    _tipoController.dispose();
    _proveedorIdController.dispose();
    super.dispose();
  }

  /// Envía el formulario y retorna el nuevo producto si es válido.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        nombre: _nombreController.text,
        precio: double.tryParse(_precioController.text) ?? 0.0,
        cantidad: int.tryParse(_stockController.text) ?? 0,
        descripcion:
            _descripcionController.text.isNotEmpty
                ? _descripcionController.text
                : null,
        tipo: _tipoController.text.isNotEmpty ? _tipoController.text : null,
        proveedorId:
            _proveedorIdController.text.isNotEmpty
                ? int.tryParse(_proveedorIdController.text)
                : null,
        id: null,
      );

      Navigator.pop(context, newProduct);
    }
  }

  /// Muestra un diálogo de error si ocurre un fallo al agregar el producto.
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(ProductsStrings.error),
            content: Text(ProductsStrings.addProductError),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(ProductsStrings.accept),
              ),
            ],
          ),
    );
  }

  /// Construye un campo de texto reutilizable para el formulario.
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
            validator ??
            (value) => value!.isEmpty ? ProductsStrings.requiredField : null,
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
        title: Text(ProductsStrings.addProduct),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: ProductsStrings.name,
                controller: _nombreController,
                icon: Icons.shopping_bag_outlined,
              ),
              _buildTextField(
                label: ProductsStrings.typeOptional,
                controller: _tipoController,
                icon: Icons.category,
                validator: (value) => null,
              ),
              _buildTextField(
                label: ProductsStrings.price,
                controller: _precioController,
                icon: Icons.attach_money,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ProductsStrings.requiredField;
                  }
                  if (double.tryParse(value) == null) {
                    return ProductsStrings.invalidPrice;
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: ProductsStrings.stockLabel,
                controller: _stockController,
                icon: Icons.store,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ProductsStrings.requiredField;
                  }
                  if (int.tryParse(value) == null) {
                    return ProductsStrings.invalidStock;
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: ProductsStrings.descriptionOptional,
                controller: _descripcionController,
                maxLines: 3,
                icon: Icons.description,
                validator: (value) => null,
              ),
              _buildTextField(
                label: ProductsStrings.providerIdOptional,
                controller: _proveedorIdController,
                icon: Icons.local_shipping,
                keyboardType: TextInputType.number,
                validator: (value) => null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(ProductsStrings.cancel),
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
                    child: Text(
                      ProductsStrings.save,
                      style: const TextStyle(color: Colors.white),
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
