import '../../domain/entities/supplier.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../datasources/suppliers_service.dart';
import '../models/supplier_model.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierService service;

  SupplierRepositoryImpl(this.service);

  @override
  Future<void> addSupplier(SupplierModel s) async {
    await service.addSupplier(s);
  }

  Future<bool> addSupplierWithoutId(SupplierModel s) async {
    try {
      final model = SupplierModel(
        nombre: s.nombre,
        nifCif: s.nifCif,
        personaContacto: s.personaContacto,
        telefono: s.telefono,
        correoElectronico: s.correoElectronico,
        direccion: s.direccion,
      );
      await service.addSupplier(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteSupplier(String nifCif) async {
    await service.deleteSupplier(nifCif);
  }

  @override
  Future<List<SupplierModel>> getAllSupplier() async {
    final models = await service.getAllSuppliers();
    return models
        .map(
          (m) => SupplierModel(
            id: m.id,
            nombre: m.nombre,
            nifCif: m.nifCif,
            personaContacto: m.personaContacto,
            telefono: m.telefono,
            correoElectronico: m.correoElectronico,
            direccion: m.direccion,
          ),
        )
        .toList();
  }

  @override
  Future<SupplierModel?> getSupplierById(int id) async {
    final model = await service.getSupplierById(id);
    if (model == null) return null;
    return SupplierModel(
      id: model.id,
      nombre: model.nombre,
      nifCif: model.nifCif,
      personaContacto: model.personaContacto,
      telefono: model.telefono,
      correoElectronico: model.correoElectronico,
      direccion: model.direccion,
    );
  }

  @override
  Future<bool> updateSupplier(SupplierModel s) async {
    try {
      await service.updateSupplier(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<SupplierModel>> getAllSuppliers() {
    return getAllSupplier();
  }
}
