import 'package:nexuserp/features/supliers/domain/repositories/supplier_repository.dart';

import '../../data/models/supplier_model.dart';

class AddSupplier {
  final SupplierRepository repository;

  AddSupplier(this.repository);

  Future<void> call(SupplierModel supplier) async {
    await repository.addSupplier(supplier);
  }
}
