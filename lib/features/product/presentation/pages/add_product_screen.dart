// lib/add_product_screen.dart
import 'package:flutter/material.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController(); // Cambiado a nombre
  final _precioController = TextEditingController();
  final _descripcionController = TextEditingController(); // Controlador para descripción
  final _stockController = TextEditingController(); // Controlador para cantidad
  final _tipoController = TextEditingController(); // Nuevo controlador para tipo
  final _proveedorIdController = TextEditingController(); // Nuevo controlador para proveedorId

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        nombre: _nombreController.text, 
        precio: double.tryParse(_precioController.text) ?? 0.0,
        cantidad: int.tryParse(_stockController.text) ?? 0, 
        descripcion: _descripcionController.text.isNotEmpty ? _descripcionController.text : null, 
        tipo: _tipoController.text.isNotEmpty ? _tipoController.text : null, 
        proveedorId: _proveedorIdController.text.isNotEmpty ? int.tryParse(_proveedorIdController.text) : null, 
        id: null, 
      );
      

      Navigator.pop(context, newProduct); // Devuelve el nuevo producto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.blue.shade700, // Consistent app bar color
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView for better keyboard handling
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nombreController, // Usa _nombreController
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tipoController, // Usa _tipoController
                decoration: const InputDecoration(
                  labelText: 'Type (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money), // Added price icon
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _stockController, // Usa _stockController
                decoration: const InputDecoration(
                  labelText: 'Stock Level',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store), // Added stock icon
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the stock level';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid stock level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController, // Usa _descripcionController
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // Align label to top for multiline
                ),
                maxLines: 3, // Allow multiple lines for description
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _proveedorIdController, // Usa _proveedorIdController
                decoration: const InputDecoration(
                  labelText: 'Proveedor ID (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_shipping), // Added supplier icon
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400, // Distinct save button color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const SizedBox(
                  width: double.infinity, // Make button full width
                  child: Center(child: Text('Save Product', style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}