// lib/employees_page.dart
import 'package:flutter/material.dart';
import 'package:NexusERP/features/employee/presentation/pages/add_employee_screen.dart';
import 'package:NexusERP/features/employee/domain/entities/employee.dart';
import 'package:NexusERP/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:NexusERP/features/employee/data/datasources/employee_service.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<Employee> _employees = [];
  late final EmployeeRepositoryImpl _repository;

  @override
  void initState() {
    super.initState();
    _repository = EmployeeRepositoryImpl(EmployeeService());
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final employees = await _repository.getEmployees();
    setState(() {
      _employees = employees;
    });
  }

  void _navigateToAddEmployeeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
    ).then((newEmployee) {
      if (newEmployee is Employee) {
        _loadEmployees(); // Recargar lista completa desde DB
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${newEmployee.nombreCompleto} agregado con éxito')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empleados'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: _employees.isEmpty
          ? const Center(
              child: Text(
                'No hay empleados registrados.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _employees.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final employee = _employees[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline, size: 32, color: Colors.blue),
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
        backgroundColor: Colors.green.shade400,
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 4,
      ),
    );
  }
}