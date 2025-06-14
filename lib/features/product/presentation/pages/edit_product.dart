import 'package:flutter/material.dart';
import 'package:nexuserp/core/utils/products_strings.dart';
import '../../data/models/product_model.dart';
import '../../data/datasources/product_service.dart';

/// Pantalla para editar un producto existente.
class EditProductPage extends StatefulWidget {
  final ProductModel product;
  final ProductService productService;

  const EditProductPage({
    Key? key,
    required this.product,
    required this.productService,
  }) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _tipoController;
  late TextEditingController _precioController;
  late TextEditingController _cantidadController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.product.nombre);
    _tipoController = TextEditingController(text: widget.product.tipo);
    _precioController = TextEditingController(
      text: widget.product.precio.toString(),
    );
    _cantidadController = TextEditingController(
      text: widget.product.cantidad.toString(),
    );
    _descripcionController = TextEditingController(
      text: widget.product.descripcion,
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  /// Envía el formulario y actualiza el producto si es válido.
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = ProductModel(
        id: widget.product.id,
        nombre: _nombreController.text,
        tipo: _tipoController.text,
        precio: double.tryParse(_precioController.text) ?? 0.0,
        cantidad: int.tryParse(_cantidadController.text) ?? 0,
        descripcion: _descripcionController.text,
        proveedorId: widget.product.proveedorId,
      );

      final success = await widget.productService.updateProduct(updatedProduct);

      if (success) {
        Navigator.pop(context, true);
      } else {
        _showErrorDialog();
      }
    }
  }

  /// Muestra un diálogo de error si ocurre un fallo al actualizar el producto.
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(ProductsStrings.error),
            content: Text(ProductsStrings.updateError),
            actions: [
              TextButton(
                child: Text(ProductsStrings.accept),
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
        title: Text(ProductsStrings.editProduct),
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
                icon: Icons.label,
              ),
              _buildTextField(
                label: ProductsStrings.type,
                controller: _tipoController,
                icon: Icons.category,
              ),
              _buildTextField(
                label: ProductsStrings.price,
                controller: _precioController,
                icon: Icons.attach_money,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              _buildTextField(
                label: ProductsStrings.stock,
                controller: _cantidadController,
                icon: Icons.format_list_numbered,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                label: ProductsStrings.description,
                controller: _descripcionController,
                icon: Icons.description,
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
                    ),
                    child: Text(ProductsStrings.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un campo de texto reutilizable para el formulario.
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
                    ? ProductsStrings.requiredField
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
