import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/domain/repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<void> call(Product product) async {
    await repository.addProduct(product);
  }
}
