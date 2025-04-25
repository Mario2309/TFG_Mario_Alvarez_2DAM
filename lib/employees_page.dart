// lib/employees_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/add_employee_screen.dart'; // Importa la AddEmployeeScreen
import 'package:myapp/models/employee.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    // Simulación de carga de empleados con algunos datos de ejemplo
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _employees = [
        Employee(
          id: 'e1',
          name: 'Sophia Rodriguez',
          position: 'Team Lead',
          email: 'sophia.r@example.com',
        ),
        Employee(
          id: 'e2',
          name: 'Ethan Williams',
          position: 'Senior Developer',
          email: 'ethan.w@example.com',
        ),
        Employee(
          id: 'e3',
          name: 'Olivia Davis',
          position: 'UX Designer',
          email: 'olivia.d@example.com',
        ),
        Employee(
          id: 'e4',
          name: 'Liam Martinez',
          position: 'Project Manager',
          email: 'liam.m@example.com',
        ),
        Employee(
          id: 'e5',
          name: 'Ava Garcia',
          position: 'Marketing Analyst',
          email: 'ava.g@example.com',
        ),
      ];
    });
  }

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
        title: const Text('Employees'),
        backgroundColor: Colors.blue.shade700, // Consistent app bar color
      ),
      body:
          _employees.isEmpty
              ? const Center(
                child: Text(
                  'No employees registered.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: _employees.length,
                padding: const EdgeInsets.all(8.0), // Add padding to the list
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 2, // Add a subtle shadow to the cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ), // Rounded corners
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 32,
                            color: Colors.blue,
                          ), // Leading icon
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  employee.position ?? 'N/A',
                                  style: TextStyle(color: Colors.grey.shade600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (employee.email != null &&
                                    employee.email!.isNotEmpty)
                                  Text(
                                    employee.email!,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddEmployeeScreen,
        backgroundColor: Colors.green.shade400, // Distinct add button color
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 4,
      ),
    );
  }
}
