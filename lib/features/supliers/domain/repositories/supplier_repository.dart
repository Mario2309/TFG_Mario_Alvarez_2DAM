import '../../data/models/supplier_model.dart';

abstract class SupplierRepository {
  Future<void> addSupplier(SupplierModel s);
  Future<bool> updateSupplier(SupplierModel s);
  Future<void> deleteSupplier(String nifCif);
  Future<List<SupplierModel>> getAllSuppliers();
  Future<SupplierModel?> getSupplierById(int id);
}
