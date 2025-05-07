// lib/employees_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/features/employee/presentation/pages/add_employee_screen.dart'; // Importa la AddEmployeeScreen
import 'package:myapp/features/employee/domain/entities/employee.dart';

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
          id: 1, // Ahora el ID es int?
          nombreCompleto: 'Sophia Rodriguez',
          nacimiento: DateTime(1990, 5, 15), // Ejemplo de fecha
          correoElectronico: 'sophia.r@example.com',
          numeroTelefono: '123-456-7890',
          dni: 'A1234567Z',
        ),
        Employee(
          id: 2,
          nombreCompleto: 'Ethan Williams',
          nacimiento: DateTime(1985, 10, 20),
          correoElectronico: 'ethan.w@example.com',
          numeroTelefono: '987-654-3210',
          dni: 'B9876543Y',
        ),
        Employee(
          id: 3,
          nombreCompleto: 'Olivia Davis',
          nacimiento: DateTime(1993, 3, 10),
          correoElectronico: 'olivia.d@example.com',
          numeroTelefono: '555-123-4567',
          dni: 'C5554443X',
        ),
        Employee(
          id: 4,
          nombreCompleto: 'Liam Martinez',
          nacimiento: DateTime(1988, 7, 25),
          correoElectronico: 'liam.m@example.com',
          numeroTelefono: '111-222-3333',
          dni: 'D1112224W',
        ),
        Employee(
          id: 5,
          nombreCompleto: 'Ava Garcia',
          nacimiento: DateTime(1995, 12, 5),
          correoElectronico: 'ava.g@example.com',
          numeroTelefono: '444-555-6666',
          dni: 'E4445552V',
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
            SnackBar(content: Text('${newEmployee.nombreCompleto} added successfully!')),
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
        backgroundColor: const Color.fromARGB(255, 25, 210, 96), // Consistent app bar color
      ),
      body: _employees.isEmpty
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
                                employee.nombreCompleto,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                employee.correoElectronico ?? 'N/A',
                                style: TextStyle(color: Colors.grey.shade600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (employee.numeroTelefono != null &&
                                  employee.numeroTelefono!.isNotEmpty)
                                Text(
                                  employee.numeroTelefono!,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (employee.dni != null && employee.dni!.isNotEmpty)
                                Text(
                                  'DNI: ${employee.dni!}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (employee.nacimiento != null)
                                Text(
                                  'Nacimiento: ${employee.nacimiento!.day}/${employee.nacimiento!.month}/${employee.nacimiento!.year}',
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