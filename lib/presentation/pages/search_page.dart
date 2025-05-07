// lib/search_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/features/employee/presentation/pages/employees_page.dart';
import 'package:myapp/features/product/presentation/pages/products_page.dart';
import 'package:myapp/features/supliers/presentation/pages/supplier_page.dart';
import 'package:myapp/features/inventory/presentation/pages/inventory_details_page.dart'; // Import the InventoryDetailsPage

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Options')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: <Widget>[
          _buildOption(context, 'Products', Icons.shopping_bag, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsPage(),
              ),
            );
          }),
          _buildOption(context, 'Employees', Icons.people, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmployeesPage()),
            );
          }),
          _buildOption(context, 'Suppliers', Icons.local_shipping, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SuppliersPage()),
            );
          }),
          _buildOption(context, 'Inventory', Icons.inventory, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InventoryDetailsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48.0, color: Colors.blue[700]),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
