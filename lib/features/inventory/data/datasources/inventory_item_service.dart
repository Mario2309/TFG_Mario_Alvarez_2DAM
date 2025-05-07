// lib/services/inventory_item_service.dart
import 'package:myapp/features/inventory/domain/entities/inventory.dart';

class InventoryItemService {
  // In-memory data simulation (replace with your actual database logic)
  final List<Inventory> _inventoryItems = [
    Inventory(
      id: 1,
      productId: 101,
      quantityInStock: 15,
      lastUpdated: DateTime(2025, 4, 28),
      location: 'Warehouse A',
      minimumStock: 5,
    ),
    Inventory(
      id: 2,
      productId: 102,
      quantityInStock: 50,
      lastUpdated: DateTime.now(),
      location: 'Store Front',
      minimumStock: 10,
    ),
    Inventory(
      id: 3,
      productId: 103,
      quantityInStock: 30,
      lastUpdated: DateTime(2025, 4, 29, 10, 0),
      location: 'Warehouse B',
      minimumStock: 8,
    ),
    Inventory(
      id: 4,
      productId: 104,
      quantityInStock: 22,
      lastUpdated: DateTime(2025, 4, 27),
      location: 'Warehouse A',
      minimumStock: 12,
    ),
    Inventory(
      id: 5,
      productId: 105,
      quantityInStock: 75,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
      location: 'Online Store',
      minimumStock: 20,
    ),
  ];

  Future<List<Inventory>> getAllInventoryItems() async {
    // Replace this with your actual database query
    await Future.delayed(const Duration(milliseconds: 200));
    return _inventoryItems;
  }

  Future<Inventory?> getInventoryItemById(int id) async {
    // Replace this with your actual database query
    await Future.delayed(const Duration(milliseconds: 100));
    return _inventoryItems.firstWhere((item) => item.id == id);
  }

  Future<void> addInventoryItem(Inventory newItem) async {
    // Replace this with your actual database insert operation
    await Future.delayed(const Duration(milliseconds: 150));
    _inventoryItems.add(newItem.copyWith(id: _inventoryItems.length + 1));
  }

  Future<void> updateInventoryItem(Inventory updatedItem) async {
    // Replace this with your actual database update operation
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _inventoryItems.indexWhere(
      (item) => item.id == updatedItem.id,
    );
    if (index != -1) {
      _inventoryItems[index] = updatedItem;
    }
  }

  Future<void> deleteInventoryItem(int id) async {
    // Replace this with your actual database delete operation
    await Future.delayed(const Duration(milliseconds: 150));
    _inventoryItems.removeWhere((item) => item.id == id);
  }
}

// Extension on InventoryItem to easily create a copy with a new ID
extension InventoryItemCopyWith on Inventory {
  Inventory copyWith({
    int? id,
    int? productId,
    int? quantityInStock,
    DateTime? lastUpdated,
    String? location,
    int? minimumStock,
  }) {
    return Inventory(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantityInStock: quantityInStock ?? this.quantityInStock,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      minimumStock: minimumStock ?? this.minimumStock,
    );
  }
}
