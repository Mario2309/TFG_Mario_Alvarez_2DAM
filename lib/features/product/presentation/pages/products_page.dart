import 'package:flutter/material.dart';
import 'package:nexuserp/features/product/presentation/pages/add_product_screen.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/data/datasources/product_service.dart';
import 'package:nexuserp/features/product/data/repositories/product_repository_impl.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductRepositoryImpl _productRepository =
      ProductRepositoryImpl(ProductService());

  List<Product> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productRepository.getAllProducts();
      setState(() => _products = products);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToAddProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    ).then((newProduct) async {
      if (newProduct is Product) {
        final success =
            await _productRepository.addProductWithoutId(newProduct);
        if (success) {
          setState(() => _products.add(newProduct));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoading() : _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Products'),
      backgroundColor: Colors.blue.shade700,
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBody() {
    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'No products available.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: _products.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) => _buildProductCard(_products[index]),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 32, color: Colors.blue.shade300),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nombre,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stock: ${product.cantidad}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  if (product.descripcion != null &&
                      product.descripcion!.isNotEmpty)
                    Text(
                      product.descripcion!,
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (product.tipo != null && product.tipo!.isNotEmpty)
                    Text(
                      'Type: ${product.tipo}',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12),
                    ),
                  if (product.proveedorId != null)
                    Text(
                      'Supplier ID: ${product.proveedorId}',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '\$${product.precio.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToAddProductScreen,
      backgroundColor: Colors.green.shade400,
      child: const Icon(Icons.add, color: Colors.white),
      elevation: 4,
    );
  }
}
