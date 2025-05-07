// lib/models/inventorym.dart
class InventoryModel {
  int? id;
  int? productId; 
  int? quantityInStock; 
  DateTime? lastUpdated; 
  String? location; 
  int? minimumStock; 

  InventoryModel({
    this.id,
    this.productId,
    this.quantityInStock,
    this.lastUpdated,
    this.location,
    this.minimumStock,
  });
}
