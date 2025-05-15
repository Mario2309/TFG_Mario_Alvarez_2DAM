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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      precio: json['precio'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      proveedorId: json['proveedor_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'tipo': tipo,
    'precio': precio,
    'cantidad': cantidad,
    'descripcion': descripcion,
    'proveedor_id': proveedorId,
  };
}
