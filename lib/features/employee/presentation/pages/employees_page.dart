import 'package:NexusERP/features/employee/presentation/pages/delete_employee_page.dart';
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
          SnackBar(
            content: Text('${newEmployee.nombreCompleto} agregado con éxito'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _employees.isEmpty ? _buildEmptyState() : _buildEmployeeList(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // AppBar widget
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Empleados'),
      backgroundColor: Colors.blue.shade700,
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No hay empleados registrados.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // List view of employees
  Widget _buildEmployeeList() {
    return ListView.builder(
      itemCount: _employees.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final employee = _employees[index];
        return _buildEmployeeCard(employee);
      },
    );
  }

  // Employee card widget
  Widget _buildEmployeeCard(Employee employee) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                  _buildEmployeeName(employee),
                  const SizedBox(height: 4),
                  _buildEmployeeEmail(employee),
                  _buildEmployeePhone(employee),
                  _buildEmployeeDNI(employee),
                  _buildEmployeeBirthDate(employee),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Employee name widget
  Widget _buildEmployeeName(Employee employee) {
    return Text(
      employee.nombreCompleto,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Employee email widget
  Widget _buildEmployeeEmail(Employee employee) {
    return Text(
      employee.correoElectronico ?? 'N/A',
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Employee phone widget
  Widget _buildEmployeePhone(Employee employee) {
    return employee.numeroTelefono != null &&
            employee.numeroTelefono!.isNotEmpty
        ? Text(
          employee.numeroTelefono!,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
        : const SizedBox.shrink();
  }

  // Employee DNI widget
  Widget _buildEmployeeDNI(Employee employee) {
    return employee.dni != null && employee.dni!.isNotEmpty
        ? Text(
          'DNI: ${employee.dni!}',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
        : const SizedBox.shrink();
  }

  // Employee birth date widget
  Widget _buildEmployeeBirthDate(Employee employee) {
    return employee.nacimiento != null
        ? Text(
          'Nacimiento: ${employee.nacimiento!.day}/${employee.nacimiento!.month}/${employee.nacimiento!.year}',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
        : const SizedBox.shrink();
  }

  // Floating action button widget
  Widget _buildFloatingActionButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'deleteEmployeeBtn',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeleteEmployeeScreen()),
            ).then((_) => _loadEmployees());
          },
          backgroundColor: Colors.red.shade400,
          child: const Icon(Icons.delete, color: Colors.white),
          tooltip: 'Eliminar empleados',
          mini: true,
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'addEmployeeBtn',
          onPressed: _navigateToAddEmployeeScreen,
          backgroundColor: Colors.green.shade400,
          child: const Icon(Icons.add, color: Colors.white),
          tooltip: 'Agregar empleado',
        ),
      ],
    );
  }
}
