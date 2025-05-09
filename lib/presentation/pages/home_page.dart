// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:NexusERP/features/employee/domain/entities/employee.dart';
import 'package:NexusERP/features/product/domain/entities/product.dart';
import 'package:NexusERP/features/supliers/domain/entities/supplier.dart'; // Import the Supplier model

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Employee> _employees = [];
  List<Product> _products = [];
  List<Supplier> _suppliers = []; // List to hold supplier data

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
          id: 1,
          nombreCompleto: 'Alice Smith',
          nacimiento: DateTime(1988, 1, 10),
          correoElectronico: 'alice.smith@example.com',
          numeroTelefono: '555-111-2222',
          dni: 'X1234567Y',
        ),
        Employee(
          id: 2,
          nombreCompleto: 'Bob Johnson',
          nacimiento: DateTime(1992, 8, 25),
          correoElectronico: 'bob.johnson@example.com',
          numeroTelefono: '555-333-4444',
          dni: 'Z9876543A',
        ),
        Employee(
          id: 3,
          nombreCompleto: 'Charlie Brown',
          nacimiento: DateTime(1995, 3, 15),
          correoElectronico: 'charlie.brown@example.com',
          numeroTelefono: '555-555-6666',
          dni: 'W1122334B',
        ),
        Employee(
          id: 4,
          nombreCompleto: 'Diana Lee',
          nacimiento: DateTime(1990, 6, 20),
          correoElectronico: 'diana.lee@example.com',
          numeroTelefono: '555-777-8888',
          dni: 'V4455667C',
        ),
      ];
      _products = [
        Product(
          id: 101,
          nombre: 'Laptop',
          tipo: 'Electrónico',
          precio: 1200.00,
          cantidad: 15,
          descripcion: 'High-performance laptop for professionals.',
          proveedorId: 1,
        ),
        Product(
          id: 102,
          nombre: 'Mouse',
          tipo: 'Periférico',
          precio: 25.00,
          cantidad: 50,
          descripcion: 'Ergonomic wireless mouse.',
          proveedorId: 2,
        ),
        Product(
          id: 103,
          nombre: 'Keyboard',
          tipo: 'Periférico',
          precio: 75.00,
          cantidad: 30,
          descripcion: 'Mechanical keyboard with RGB lighting.',
          proveedorId: 1,
        ),
        Product(
          id: 104,
          nombre: 'Monitor',
          tipo: 'Electrónico',
          precio: 300.00,
          cantidad: 20,
          descripcion: '27-inch 4K UHD monitor.',
          proveedorId: 3,
        ),
        Product(
          id: 105,
          nombre: 'Webcam',
          tipo: 'Accesorio',
          precio: 50.00,
          cantidad: 40,
          descripcion: '1080p HD webcam with microphone.',
          proveedorId: 2,
        ),
      ];
      _suppliers = [
        Supplier(
          id: 1,
          name: 'Tech Solutions Inc.',
          taxId: 'TS12345',
          contactPerson: 'John Smith',
          phone: '555-987-6543',
          email: 'john.smith@techsolutions.com',
          address: '123 Main St',
        ),
        Supplier(
          id: 2,
          name: 'Global Supplies Co.',
          taxId: 'GS67890',
          contactPerson: 'Alice Brown',
          phone: '555-111-2233',
          email: 'alice.brown@globalsupplies.net',
          address: '456 Industrial Ave',
        ),
        Supplier(
          id: 3,
          name: 'Electro Gadgets Ltd.',
          taxId: 'EG13579',
          contactPerson: 'Bob Green',
          phone: '555-444-5566',
          email: 'bob.green@electrogadgets.org',
          address: '789 Commerce Blvd',
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
                            employee.nombreCompleto,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            employee.correoElectronico ?? 'N/A',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (employee.numeroTelefono?.isNotEmpty ?? false)
                            Text(
                              employee.numeroTelefono!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (employee.dni?.isNotEmpty ?? false)
                            Text(
                              'DNI: ${employee.dni!}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (employee.nacimiento != null)
                            Text(
                              'Nacimiento: ${employee.nacimiento!.day}/${employee.nacimiento!.month}/${employee.nacimiento!.year}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
              "Products",
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
                    "No products data available.",
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
                      product.nombre, // Usa nombre
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock: ${product.cantidad}', // Usa cantidad
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        if (product.tipo?.isNotEmpty ?? false)
                          Text(
                            'Tipo: ${product.tipo}', // Usa tipo
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        if (product.descripcion?.isNotEmpty ?? false)
                          Text(
                            product.descripcion!, // Usa descripcion
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (product.proveedorId != null)
                          Text(
                            'Proveedor ID: ${product.proveedorId}', // Usa proveedorId
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    trailing: Text(
                      '\$${product.precio.toStringAsFixed(2)}', // Usa precio
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    // You can add more product details or actions here
                  );
                },
              ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Suppliers",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          _suppliers.isEmpty
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No supplier data available.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
              : SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: _suppliers.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 16.0),
                  itemBuilder: (context, index) {
                    final supplier = _suppliers[index];
                    return Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color:
                            Colors
                                .orange
                                .shade50, // Different color for suppliers
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supplier.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          if (supplier.taxId?.isNotEmpty ?? false)
                            Text(
                              'Tax ID: ${supplier.taxId!}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (supplier.contactPerson?.isNotEmpty ?? false)
                            Text(
                              'Contact: ${supplier.contactPerson!}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (supplier.phone?.isNotEmpty ?? false)
                            Text(
                              supplier.phone!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (supplier.email?.isNotEmpty ?? false)
                            Text(
                              supplier.email!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
