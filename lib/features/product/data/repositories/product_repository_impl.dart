import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_service.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductService service;

  ProductRepositoryImpl(this.service);

  @override
  Future<void> addProduct(Product p) async {
    final model = ProductModel(
      nombre: p.nombre,
      tipo: p.tipo,
      precio: p.precio,
      cantidad: p.cantidad,
      descripcion: p.descripcion,
      proveedorId: p.proveedorId,
    );
    await service.addProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await service.deleteProduct(id);
  }

  @override
  Future<List<Product>> getAllProducts() async {
    final models = await service.getAllProducts();
    return models.map(
      (m) => Product(
        id: m.id,
        nombre: m.nombre,
        tipo: m.tipo,
        precio: m.precio,
        cantidad: m.cantidad,
        descripcion: m.descripcion,
        proveedorId: m.proveedorId,
      ),
    ).toList();
  }

  @override
  Future<Product?> getProductById(int id) async {
    final model = await service.getProductById(id);
    if (model == null) return null;
    return Product(
      id: model.id,
      nombre: model.nombre,
      tipo: model.tipo,
      precio: model.precio,
      cantidad: model.cantidad,
      descripcion: model.descripcion,
      proveedorId: model.proveedorId,
    );
  }

  Future<bool> addProductWithoutId(Product p) async {
    try {
      final model = ProductModel(
        nombre: p.nombre,
        tipo: p.tipo,
        precio: p.precio,
        cantidad: p.cantidad,
        descripcion: p.descripcion,
        proveedorId: p.proveedorId,
      );
      await service.addProduct(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateProduct(Product p) async {
    final model = ProductModel(
      id: p.id,
      nombre: p.nombre,
      tipo: p.tipo,
      precio: p.precio,
      cantidad: p.cantidad,
      descripcion: p.descripcion,
      proveedorId: p.proveedorId,
    );
    await service.updateProduct(model);
  }
}
