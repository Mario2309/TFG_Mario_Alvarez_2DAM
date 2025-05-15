import 'package:nexuserp/features/product/data/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final supabase = Supabase.instance.client;

  Future<void> addProduct(ProductModel product) async {
    try {
      await supabase.from('productos').insert(product.toJson());
    } catch (e) {
      throw Exception('Error al agregar producto: $e');
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final List<dynamic> data = await supabase.from('productos').select();
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener productos: $e');
    }
  }

  Future<ProductModel?> getProductById(int id) async {
    try {
      final data = await supabase
          .from('productos')
          .select()
          .eq('id', id)
          .single(); 
      return ProductModel.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener producto con ID $id: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    if (product.id == null) {
      throw Exception('ID del producto requerido para actualizar');
    }

    try {
      await supabase
          .from('productos')
          .update(product.toJson())
          .eq('id', product.id!);
    } catch (e) {
      throw Exception('Error al actualizar producto con ID ${product.id}: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await supabase.from('productos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar producto con ID $id: $e');
    }
  }

}

