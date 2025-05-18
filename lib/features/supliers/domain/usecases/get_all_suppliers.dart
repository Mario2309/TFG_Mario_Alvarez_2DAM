import '../../data/models/supplier_model.dart';
import '../entities/supplier.dart';
import '../repositories/supplier_repository.dart';

class GetAllSupplier {
  final SupplierRepository repository;

  GetAllSupplier(this.repository);

  Future<List<SupplierModel>> call() async {
    return await repository.getAllSuppliers();
  }
}
