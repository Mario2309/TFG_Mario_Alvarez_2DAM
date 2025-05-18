import '../repositories/supplier_repository.dart';

class DeleteSupplier {
  final SupplierRepository repository;

  DeleteSupplier(this.repository);

  Future<void> call(String nifCif) async {
    await repository.deleteSupplier(nifCif);
  }
}
