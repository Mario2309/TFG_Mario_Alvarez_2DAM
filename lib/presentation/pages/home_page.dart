import 'package:flutter/material.dart';
import 'package:NexusERP/features/employee/domain/entities/employee.dart';
import 'package:NexusERP/features/product/domain/entities/product.dart';
import 'package:NexusERP/features/supliers/domain/entities/supplier.dart'; // Import the Supplier model
import 'package:NexusERP/features/employee/data/datasources/employee_service.dart'; // Import the service to fetch employees

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Employee> _employees = [];
  List<Product> _products = [];
  List<Supplier> _suppliers = []; // List to hold supplier data
  final EmployeeService _employeeService = EmployeeService(); // EmployeeService instance

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Fetch employee data from Supabase
    final employeeModels = await _employeeService.fetchEmployees();
    setState(() {
      _employees = employeeModels.map((model) => Employee(
        id: model.id,
        nombreCompleto: model.nombreCompleto,
        nacimiento: model.nacimiento,
        correoElectronico: model.correoElectronico,
        numeroTelefono: model.numeroTelefono,
        dni: model.dni,
      )).toList();

      // Simulating fetching products and suppliers (replace with actual logic later)
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
        // Add more products as needed
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
        // Add more suppliers as needed
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16.0),
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
          // Display products data here...
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
          // Display suppliers data here...
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}