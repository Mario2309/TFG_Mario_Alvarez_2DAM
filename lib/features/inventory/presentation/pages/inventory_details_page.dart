// lib/inventory_details_page.dart
import 'package:flutter/material.dart';
import 'package:nexuserp/features/inventory/domain/entities/inventory.dart';
import 'package:nexuserp/features/inventory/data/datasources/inventory_item_service.dart';
import 'package:nexuserp/core/utils/inventory_strings.dart';

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
        title: const Text(
          InventoryStrings.detailsTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade600,
                Colors.blue.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        elevation: 12,
      ),
      body:
          _inventoryItems.isEmpty
              ? Center(
                child: Text(
                  InventoryStrings.noDetails,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                            '${InventoryStrings.itemId}: ${item.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (item.productId != null)
                            Text(
                              '${InventoryStrings.productId}: ${item.productId}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          if (item.quantityInStock != null)
                            Text(
                              '${InventoryStrings.stock}: ${item.quantityInStock}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          if (item.lastUpdated != null)
                            Text(
                              '${InventoryStrings.lastUpdated}: ${item.lastUpdated!.day}/${item.lastUpdated!.month}/${item.lastUpdated!.year}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          if (item.location != null &&
                              item.location!.isNotEmpty)
                            Text(
                              '${InventoryStrings.location}: ${item.location}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          if (item.minimumStock != null)
                            Text(
                              '${InventoryStrings.minStock}: ${item.minimumStock}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
