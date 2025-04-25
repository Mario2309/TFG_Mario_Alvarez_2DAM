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
    await Future.delayed(const Duration(milliseconds: 300));
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
        title: const Text('Inventory'),
        backgroundColor: Colors.blue.shade700, // Consistent app bar color
      ),
      body: _products.isEmpty
          ? const Center(
              child: Text(
                'No products in inventory.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _products.length,
              padding: const EdgeInsets.all(8.0), // Add padding to the list
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2, // Add a subtle shadow to the cards
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Rounded corners
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 32, color: Colors.blue.shade300), // Leading icon
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stock: ${product.quantity}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              if (product.description != null && product.description!.isNotEmpty)
                                Text(
                                  product.description!,
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProductScreen,
        backgroundColor: Colors.green.shade400, // Distinct color for add button
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 4,
      ),
    );
  }
}