import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/presentation/pages/employees_page.dart';
import 'package:nexuserp/features/product/presentation/pages/products_page.dart';
import 'package:nexuserp/features/supliers/presentation/pages/supplier_page.dart';
import 'package:nexuserp/features/inventory/presentation/pages/inventory_details_page.dart'; // Import the InventoryDetailsPage

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
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
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 56.0,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}