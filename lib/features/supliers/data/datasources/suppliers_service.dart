import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/supplier.dart';
import '../models/supplier_model.dart';

class SupplierService {
  final supabase = Supabase.instance.client;

  Future<void> addSupplier(SupplierModel supplier) async {
    try {
      await supabase.from('proveedores').insert(supplier.toJson());
    } catch (e) {
      throw Exception('Error al agregar proveedor: $e');
    }
  }

  Future<List<SupplierModel>> getAllSuppliers() async {
    try {
      final List<dynamic> data = await supabase.from('proveedores').select();
      return data.map((json) => SupplierModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener proveedores: $e');
    }
  }

  Future<SupplierModel?> getSupplierById(int id) async {
    try {
      final data =
          await supabase.from('proveedores').select().eq('id', id).single();
      return SupplierModel.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener proveedor con ID $id: $e');
    }
  }

  Future<bool> updateSupplier(SupplierModel supplier) async {
    if (supplier.id == null) {
      throw Exception('ID del proveedor requerido para actualizar');
    }

    try {
      await supabase
          .from('proveedores')
          .update(supplier.toJson())
          .eq('id', supplier.id!);
      return true;
    } catch (e) {
      throw Exception('Error al actualizar proveedor con ID ${supplier.id}: $e');
    }
  }

  Future<void> deleteSupplier(String nifCif) async {
    try {
      await supabase.from('proveedores').delete().eq('nifCif', nifCif);
    } catch (e) {
      throw Exception('Error al eliminar proveedor con nif/Cif $nifCif: $e');
    }
  }

  Future<List<SupplierModel>> fetchSuppliers() async {
    final response = await supabase.from('proveedores').select();
    return (response as List).map((e) => SupplierModel.fromJson(e)).toList();
  }
}
