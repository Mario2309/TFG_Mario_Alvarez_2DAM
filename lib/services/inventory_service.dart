import 'package:myapp/models/product.dart';

class InventoryService {
  final List<Product> _products = [];

  void addProduct(Product product) {
    _products.add(product);
  }

  List<Product> getAllProducts() {
    return _products;
  }
}