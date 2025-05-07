// lib/models/inventorym.dart
class Inventory {
  int? id;
  int? productId; // Corresponds to producto_id
  int? quantityInStock; // Corresponds to cantidad_en_stock
  DateTime? lastUpdated; // Corresponds to ultima_actualizacion
  String? location; // Corresponds to ubicacion
  int? minimumStock; // Corresponds to stock_minimo

  Inventory({
    this.id,
    this.productId,
    this.quantityInStock,
    this.lastUpdated,
    this.location,
    this.minimumStock,
  });
}
