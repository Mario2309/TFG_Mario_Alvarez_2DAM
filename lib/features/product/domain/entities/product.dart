class Product {
  int? id;
  String nombre;
  String? tipo;
  double precio;
  int cantidad;
  String? descripcion;
  int? proveedorId;

  Product({
    this.id,
    required this.nombre,
    this.tipo,
    required this.precio,
    required this.cantidad,
    this.descripcion,
    this.proveedorId,
  });
}
