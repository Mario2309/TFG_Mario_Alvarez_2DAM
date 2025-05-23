import 'package:flutter/material.dart';
import 'package:nexuserp/features/product/presentation/pages/add_product_screen.dart';
import 'package:nexuserp/features/product/presentation/pages/edit_product.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/data/models/product_model.dart';
import 'package:nexuserp/features/product/data/datasources/product_service.dart';
import 'package:nexuserp/features/product/data/repositories/product_repository_impl.dart';

import 'details_products_page.dart'; // Importa la pantalla de detalles

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductRepositoryImpl _productRepository = ProductRepositoryImpl(
    ProductService(),
  );

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
        _applyFilter();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productRepository.getAllProducts();
      setState(() {
        _products = products;
        _applyFilter();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    List<Product> temp = _products;
    if (_searchQuery.isNotEmpty) {
      temp =
          temp
              .where((p) => p.nombre.toLowerCase().contains(_searchQuery))
              .toList();
    }
    _filteredProducts = temp;
  }

  void _navigateToAddProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    ).then((newProduct) async {
      if (newProduct is Product) {
        final success = await _productRepository.addProductWithoutId(
          newProduct,
        );
        if (success) {
          setState(() => _products.add(newProduct));
          _applyFilter(); // Re-apply filter after adding
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newProduct.nombre} added successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add product')),
          );
        }
      }
    });
  }

  void _navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _navigateToEditProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditProductPage(
              product: ProductModel(
                id: product.id,
                nombre: product.nombre,
                tipo: product.tipo,
                precio: product.precio,
                cantidad: product.cantidad,
                descripcion: product.descripcion,
                proveedorId: product.proveedorId,
              ),
              productService: ProductService(),
            ),
      ),
    );
    if (result == true) {
      _loadProducts();
    }
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          Icons.shopping_bag_outlined,
          color: Colors.blue.shade700,
          size: 32,
        ),
        title: Text(
          product.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'Stock: ${product.cantidad}\nPrecio: \$${product.precio.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        onTap:
            () => _navigateToProductDetails(
              product,
            ), // Acción al tocar la tarjeta
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'details') {
              _navigateToProductDetails(product);
            } else if (value == 'edit') {
              _navigateToEditProduct(product);
            }
          },
          itemBuilder:
              (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'details',
                  child: Text('Ver detalles'),
                ),
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Editar'),
                ),
              ],
        ),
      ),
    );
  }

  Widget _buildFilterOptions(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue.shade700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Opciones",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.blue.shade600,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.refresh),
          title: const Text('Recargar productos'),
          onTap: () {
            _loadProducts();
            if (!isLargeScreen) Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Agregar producto'),
          onTap: () {
            if (!isLargeScreen) Navigator.pop(context);
            _navigateToAddProductScreen();
          },
        ),
        // Puedes añadir más opciones de filtrado aquí si lo necesitas
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: isLargeScreen ? null : Drawer(child: _buildFilterOptions(false)),
      body: Row(
        children: [
          if (isLargeScreen)
            Container(
              width: 280,
              color: Colors.grey.shade100,
              child: _buildFilterOptions(true),
            ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredProducts.isEmpty
                    ? const Center(
                      child: Text(
                        'No hay productos disponibles.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredProducts.length,
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder:
                          (context, index) =>
                              _buildProductCard(_filteredProducts[index]),
                    ),
          ),
        ],
      ),
    );
  }
}
