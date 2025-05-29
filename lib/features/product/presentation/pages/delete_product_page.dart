import 'package:flutter/material.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/data/repositories/product_repository_impl.dart';
import 'package:nexuserp/features/product/data/datasources/product_service.dart';
import 'package:nexuserp/features/product/presentation/pages/products_page.dart';
import 'package:nexuserp/core/utils/products_strings.dart';

/// Pantalla para eliminar productos del inventario.
class DeleteProductScreen extends StatefulWidget {
  @override
  _DeleteProductScreenState createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  final _repository = ProductRepositoryImpl(ProductService());
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// Carga la lista de productos desde el repositorio.
  Future<void> _loadProducts() async {
    try {
      final list = await _repository.getAllProducts();
      if (mounted) {
        setState(() {
          _products = list;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${ProductsStrings.errorLoading} $e')),
      );
    }
  }

  /// Muestra un diálogo de confirmación y elimina el producto si se acepta.
  Future<void> _deleteProduct(Product product) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ProductsStrings.confirmDelete),
          content: Text(
            '${ProductsStrings.confirmDeleteMsg} "${product.nombre}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(ProductsStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _repository.deleteProduct(product.id.toString()!);
                  if (mounted) {
                    setState(() {
                      _products.remove(product);
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product.nombre} ${ProductsStrings.deletedSuccessfully}',
                      ),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsPage()),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ProductsStrings.deleteError)),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsPage()),
                  );
                }
              },
              child: Text(ProductsStrings.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProductsStrings.deleteProducts),
        backgroundColor: Colors.red.shade700,
      ),
      body:
          _products.isEmpty
              ? Center(child: Text(ProductsStrings.noProductsToDelete))
              : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product.nombre),
                    subtitle: Text(
                      '${ProductsStrings.stock}: ${product.cantidad}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(product),
                    ),
                  );
                },
              ),
    );
  }
}
