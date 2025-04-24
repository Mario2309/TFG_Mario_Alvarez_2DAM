// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/employee.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/services/employee_service.dart';
import 'package:myapp/services/inventory_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InventoryService _inventoryService = InventoryService();
  final EmployeeService _employeeService = EmployeeService();
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Simulación de carga de datos (reemplaza con tu lógica real)
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _employees = _employeeService.getAllEmployees();
    });
  }

  // La función para agregar empleados y mostrar el formulario ya no son necesarias aquí

  @override
  Widget build(BuildContext context) {
    List<Product> products = _inventoryService.getAllProducts();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Employees",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _employees.isEmpty
              ? Center(child: Text("No employees data"))
              : SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _employees.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_employees[index].name),
                        subtitle: Text(_employees[index].position),
                      );
                    },
                  ),
                ),
          // ... (resto de tu HomePage)
        ],
      ),
    );
  }
}