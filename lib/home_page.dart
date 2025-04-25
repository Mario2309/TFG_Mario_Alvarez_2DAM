// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/employee.dart';
import 'package:myapp/models/product.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Employee> _employees = [];
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Simulación de carga de datos con algunos datos de ejemplo
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _employees = [
        Employee(
          id: '1',
          name: 'Alice Smith',
          position: 'Manager',
          email: 'alice.smith@example.com',
        ),
        Employee(
          id: '2',
          name: 'Bob Johnson',
          position: 'Sales Representative',
          email: 'bob.johnson@example.com',
        ),
        Employee(
          id: '3',
          name: 'Charlie Brown',
          position: 'Developer',
          email: 'charlie.brown@example.com',
        ),
        Employee(
          id: '4',
          name: 'Diana Lee',
          position: 'Marketing Specialist',
          email: 'diana.lee@example.com',
        ),
      ];
      _products = [
        Product(
          id: '101',
          name: 'Laptop',
          price: 1200.00,
          quantity: 15,
          description: 'High-performance laptop for professionals.',
        ),
        Product(
          id: '102',
          name: 'Mouse',
          price: 25.00,
          quantity: 50,
          description: 'Ergonomic wireless mouse.',
        ),
        Product(
          id: '103',
          name: 'Keyboard',
          price: 75.00,
          quantity: 30,
          description: 'Mechanical keyboard with RGB lighting.',
        ),
        Product(
          id: '104',
          name: 'Monitor',
          price: 300.00,
          quantity: 20,
          description: '27-inch 4K UHD monitor.',
        ),
        Product(
          id: '105',
          name: 'Webcam',
          price: 50.00,
          quantity: 40,
          description: '1080p HD webcam with microphone.',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Employees",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          _employees.isEmpty
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No employees data available.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
              : SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: _employees.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 16.0),
                  itemBuilder: (context, index) {
                    final employee = _employees[index];
                    return Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            employee.position,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // You can add more employee details here
                        ],
                      ),
                    );
                  },
                ),
              ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Inventory",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          _products.isEmpty
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No inventory data available.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
              : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _products.length,
                separatorBuilder: (context, index) => const Divider(height: 20),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    leading: Icon(Icons.inventory, color: Colors.blue.shade300),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Stock: ${product.quantity}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    trailing: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    // You can add more product details or actions here
                  );
                },
              ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
