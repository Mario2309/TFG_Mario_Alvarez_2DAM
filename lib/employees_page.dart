// lib/employees_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/add_employee_screen.dart'; // Importa la AddEmployeeScreen
import 'package:myapp/models/employee.dart';
import 'package:myapp/services/employee_service.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<Employee> _employees = [];
  final EmployeeService _employeeService = EmployeeService();

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    // Simulación de carga de empleados (reemplaza con tu lógica real)
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _employees = _employeeService.getAllEmployees();
    });
  }

  // Ya no necesitamos esta función aquí, AddEmployeeScreen manejará la adición
  // void _addEmployeeToList(Employee newEmployee) {
  //   setState(() {
  //     _employees.add(newEmployee);
  //   });
  //   // Aquí también podrías llamar al servicio para guardar
  //   // _employeeService.addEmployee(newEmployee);
  // }

  void _navigateToAddEmployeeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
    ).then((newEmployee) {
      // Este .then se ejecuta cuando volvemos de AddEmployeeScreen
      if (newEmployee is Employee) {
        setState(() {
          _employees.add(newEmployee);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newEmployee.name} added successfully!')),
          );
        });
        // Aquí deberías llamar al servicio para guardar el nuevo empleado
        // _employeeService.addEmployee(newEmployee);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empleados'),
      ),
      body: _employees.isEmpty
          ? Center(child: Text('No hay empleados registrados.'))
          : ListView.builder(
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_employees[index].name, style: TextStyle(fontSize: 18)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddEmployeeScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}