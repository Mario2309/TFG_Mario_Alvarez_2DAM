import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/domain/repositories/product_repository.dart';

class GetAllProduct {
  final ProductRepository repository;

  GetAllProduct(this.repository);

  Future<List<Product>> call() async{
    return await repository.getAllProducts();
  } 
}
