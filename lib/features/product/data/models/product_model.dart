class ProductModel {
  int? id;
  String nombre;
  String? tipo;
  double precio;
  int cantidad;
  String? descripcion;
  int? proveedorId;

  ProductModel({
    this.id,
    required this.nombre,
    this.tipo,
    required this.precio,
    required this.cantidad,
    this.descripcion,
    this.proveedorId,
  });
}
