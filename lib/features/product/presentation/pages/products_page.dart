import 'package:flutter/material.dart';
import 'package:nexuserp/features/product/presentation/pages/add_product_screen.dart';
import 'package:nexuserp/features/product/presentation/pages/edit_product.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/data/models/product_model.dart';
import 'package:nexuserp/features/product/data/datasources/product_service.dart';
import 'package:nexuserp/features/product/data/repositories/product_repository_impl.dart';
import 'package:nexuserp/core/utils/products_strings.dart';

import 'details_products_page.dart'; // Importa la pantalla de detalles

/// Página principal para la gestión y visualización de productos.
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

  /// Carga la lista de productos desde el repositorio.
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productRepository.getAllProducts();
      setState(() {
        _products = products;
        _applyFilter();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${ProductsStrings.errorLoading} $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Aplica el filtro de búsqueda sobre la lista de productos.
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

  /// Navega a la pantalla para agregar un nuevo producto.
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
          _applyFilter();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ProductsStrings.addedSuccessfully)),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(ProductsStrings.failedToAdd)));
        }
      }
    });
  }

  /// Navega a la pantalla de detalles de un producto.
  void _navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  /// Navega a la pantalla de edición de un producto y recarga si hay cambios.
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

  /// Construye la tarjeta visual para un producto individual.
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
          '${ProductsStrings.stock}: ￿{product.cantidad}\n${ProductsStrings.price}: \u0024${product.precio.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        onTap: () => _navigateToProductDetails(product),
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
                PopupMenuItem<String>(
                  value: 'details',
                  child: Text(ProductsStrings.viewDetails),
                ),
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Text(ProductsStrings.edit),
                ),
              ],
        ),
      ),
    );
  }

  /// Construye el panel lateral de filtros y búsqueda.
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
                ProductsStrings.options,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: ProductsStrings.searchHint,
                  hintStyle: const TextStyle(color: Colors.white70),
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
          title: Text(ProductsStrings.reloadProducts),
          onTap: () {
            _loadProducts();
            if (!isLargeScreen) Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: Text(ProductsStrings.addProduct),
          onTap: () {
            if (!isLargeScreen) Navigator.pop(context);
            _navigateToAddProductScreen();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ProductsStrings.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade600,
                Colors.blue.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        elevation: 12,
        centerTitle: true,
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
                    ? Center(
                      child: Text(
                        ProductsStrings.noProducts,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
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
