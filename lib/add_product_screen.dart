// lib/add_product_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/services/inventory_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final InventoryService _inventoryService = InventoryService();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0, description: '', quantity: 0,
      );
      // Aquí podrías llamar al servicio para guardar el producto en la base de datos
      // _inventoryService.addProduct(newProduct);

      Navigator.pop(context, newProduct); // Devuelve el nuevo producto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el nombre del producto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, introduce un precio válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}