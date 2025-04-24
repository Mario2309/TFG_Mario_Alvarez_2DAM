// lib/inventory_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/add_product_screen.dart'; // Importa la AddProductScreen
import 'package:myapp/models/product.dart';
import 'package:myapp/services/inventory_service.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Product> _products = [];
  final InventoryService _inventoryService = InventoryService();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Simulación de carga de productos (reemplaza con tu lógica real)
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _products = _inventoryService.getAllProducts();
    });
  }

  void _navigateToAddProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    ).then((newProduct) {
      if (newProduct is Product) {
        setState(() {
          _products.add(newProduct);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newProduct.name} added successfully!')),
          );
        });
        // Aquí deberías llamar al servicio para guardar el nuevo producto
        // _inventoryService.addProduct(newProduct);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
      ),
      body: _products.isEmpty
          ? Center(child: Text('No hay productos en el inventario.'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_products[index].name, style: TextStyle(fontSize: 18)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProductScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}