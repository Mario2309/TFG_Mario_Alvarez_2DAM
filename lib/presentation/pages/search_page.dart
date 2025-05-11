import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/presentation/pages/employees_page.dart';
import 'package:nexuserp/features/product/presentation/pages/products_page.dart';
import 'package:nexuserp/features/supliers/presentation/pages/supplier_page.dart';
import 'package:nexuserp/features/inventory/presentation/pages/inventory_details_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Variable para cambiar el modo de vista
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Explore Options'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          // Icono para cambiar entre vista en cuadrícula y lista
          IconButton(
            icon: Icon(
              isGridView ? Icons.view_list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            isGridView
                // Vista en cuadrícula
                ? GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  children: <Widget>[
                    _buildModernOption(
                      context,
                      'Products',
                      Icons.shopping_bag_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProductsPage()),
                        );
                      },
                    ),
                    _buildModernOption(
                      context,
                      'Employees',
                      Icons.people_alt_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EmployeesPage()),
                        );
                      },
                    ),
                    _buildModernOption(
                      context,
                      'Suppliers',
                      Icons.local_shipping_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SuppliersPage()),
                        );
                      },
                    ),
                    _buildModernOption(
                      context,
                      'Inventory',
                      Icons.inventory_2_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InventoryDetailsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                )
                // Vista en lista
                : ListView(
                  children: <Widget>[
                    _buildModernOption(
                      context,
                      'Products',
                      Icons.shopping_bag_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProductsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 8.0), // Margen entre elementos
                    _buildModernOption(
                      context,
                      'Employees',
                      Icons.people_alt_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EmployeesPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 8.0), // Margen entre elementos
                    _buildModernOption(
                      context,
                      'Suppliers',
                      Icons.local_shipping_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SuppliersPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 8.0), // Margen entre elementos
                    _buildModernOption(
                      context,
                      'Inventory',
                      Icons.inventory_2_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InventoryDetailsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildModernOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.blue.shade100,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 50.0, color: Colors.blue.shade700),
                const SizedBox(height: 12.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
