// lib/products_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/features/product/presentation/pages/add_product_screen.dart'; // Importa la AddProductScreen
import 'package:myapp/features/product/domain/entities/product.dart';
import 'package:myapp/features/product/data/datasources/product_service.dart'; // Asegúrate de tener este servicio adaptado

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> _products = [];
  final ProductService _productService = ProductService(); // Asegúrate de que este servicio use la nueva estructura de Product

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Simulación de carga de productos (reemplaza con tu lógica real usando el servicio)
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _products = _productService.getAllProducts(); // Asegúrate de que getAllProducts() devuelva List<Product> con la nueva estructura
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
            SnackBar(content: Text('${newProduct.nombre} added successfully!')), // Usa product.nombre
          );
        });
        // Aquí deberías llamar al servicio para guardar el nuevo producto
        // _productService.addProduct(newProduct); // Asegúrate de que addProduct() acepte la nueva estructura de Product
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'), // Changed title to 'Products'
        backgroundColor: const Color.fromARGB(255, 189, 210, 25), // Consistent app bar color
      ),
      body: _products.isEmpty
          ? const Center(
              child: Text(
                'No products available.', // Changed text to 'No products available.'
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
                        Icon(Icons.shopping_bag_outlined, size: 32, color: Colors.blue.shade300), // Changed icon to something product-related
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.nombre, // Usa product.nombre
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stock: ${product.cantidad}', // Usa product.cantidad
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              if (product.descripcion != null && product.descripcion!.isNotEmpty)
                                Text(
                                  product.descripcion!, // Usa product.descripcion
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (product.tipo != null && product.tipo!.isNotEmpty)
                                Text(
                                  'Type: ${product.tipo}', // Usa product.tipo
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                ),
                              if (product.proveedorId != null)
                                Text(
                                  'Supplier ID: ${product.proveedorId}', // Changed 'Proveedor' to 'Supplier'
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${product.precio.toStringAsFixed(2)}', // Usa product.precio
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