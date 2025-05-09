import 'package:NexusERP/features/product/domain/entities/product.dart';

class ProductService {
  final List<Product> _products = [];

  void addProduct(Product product) {
    _products.add(product);
  }

  List<Product> getAllProducts() {
    return _products;
  }
}