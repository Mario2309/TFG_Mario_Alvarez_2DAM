// lib/inventory_details_page.dart
import 'package:flutter/material.dart';
import 'package:nexuserp/features/inventory/domain/entities/inventory.dart';
import 'package:nexuserp/features/inventory/data/datasources/inventory_item_service.dart';

class InventoryDetailsPage extends StatefulWidget {
  @override
  _InventoryDetailsPageState createState() => _InventoryDetailsPageState();
}

class _InventoryDetailsPageState extends State<InventoryDetailsPage> {
  List<Inventory> _inventoryItems = [];
  final InventoryItemService _inventoryItemService = InventoryItemService();

  @override
  void initState() {
    super.initState();
    _loadInventoryItems();
  }

  Future<void> _loadInventoryItems() async {
    final inventoryData = await _inventoryItemService.getAllInventoryItems();
    setState(() {
      _inventoryItems = inventoryData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Details'),
        backgroundColor:
            Colors.blue.shade700, // Updated to align with the blue theme
      ),
      body:
          _inventoryItems.isEmpty
              ? const Center(
                child: Text(
                  'No inventory details available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: _inventoryItems.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  final item = _inventoryItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item ID: ${item.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (item.productId != null)
                            Text(
                              'Product ID: ${item.productId}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          if (item.quantityInStock != null)
                            Text(
                              'Stock: ${item.quantityInStock}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          if (item.lastUpdated != null)
                            Text(
                              'Last Updated: ${item.lastUpdated!.day}/${item.lastUpdated!.month}/${item.lastUpdated!.year}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          if (item.location != null &&
                              item.location!.isNotEmpty)
                            Text(
                              'Location: ${item.location}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          if (item.minimumStock != null)
                            Text(
                              'Min Stock: ${item.minimumStock}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          // You can add more details or actions here
                        ],
                      ),
                    ),
                  );
                },
              ),
      // You might want to add a FloatingActionButton here for adding/editing inventory items
    );
  }
}
