import 'package:nexuserp/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<void> addProduct(Product p);
  Future<void> updateProduct(Product p);
  Future<void> deleteProduct(String id);
  Future<List<Product>> getAllProducts();
  Future<Product?> getProductById(int id);
}