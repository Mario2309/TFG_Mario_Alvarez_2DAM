import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/data/models/employee_model.dart';
import 'package:nexuserp/features/employee/presentation/pages/add_employee_screen.dart';
import 'package:nexuserp/features/employee/presentation/pages/delete_employee_page.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee/presentation/pages/edit_employee_page.dart'
    show EditEmployeePage;

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
      MaterialPageRoute(
        builder:
            (_) => AddEmployeePage(
              employeeService: EmployeeRepositoryImpl(EmployeeService()),
            ),
      ),
    ).then((newEmployee) {
      if (newEmployee is Employee) {
        _loadEmployees();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newEmployee.nombreCompleto} agregado con éxito'),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _employees.isEmpty ? _buildEmptyState() : _buildEmployeeList(),
          Positioned(bottom: 16, right: 16, child: _buildFloatingButtons()),
          Positioned(
            bottom: 16,
            left: 24, // margen sobre la izquierda
            child: FloatingActionButton(
              heroTag: 'refreshBtn',
              onPressed: _loadEmployees,
              backgroundColor: Colors.blue.shade700,
              tooltip: 'Recargar empleados',
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Gestión de Empleados'),
      centerTitle: true,
      backgroundColor: Colors.blue.shade700,
      elevation: 2,
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No hay empleados registrados.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildEmployeeList() {
    return ListView.builder(
      itemCount: _employees.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        return _buildEmployeeCard(_employees[index]);
      },
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EditEmployeePage(
                      employee: EmployeeModel(
                        id: employee.id,
                        nombreCompleto: employee.nombreCompleto,
                        nacimiento: employee.nacimiento,
                        correoElectronico: employee.correoElectronico,
                        numeroTelefono: employee.numeroTelefono,
                        dni: employee.dni,
                      ),
                      employeeService: EmployeeService(),
                    ),
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, color: Colors.blue),
            ),
            title: Text(
              employee.nombreCompleto,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (employee.correoElectronico != null)
                  Text(
                    employee.correoElectronico!,
                    style: const TextStyle(fontSize: 13),
                  ),
                if (employee.numeroTelefono != null &&
                    employee.numeroTelefono!.isNotEmpty)
                  Text(
                    'Tel: ${employee.numeroTelefono!}',
                    style: const TextStyle(fontSize: 12),
                  ),
                if (employee.dni != null && employee.dni!.isNotEmpty)
                  Text(
                    'DNI: ${employee.dni!}',
                    style: const TextStyle(fontSize: 12),
                  ),
                if (employee.nacimiento != null)
                  Text(
                    'Nacimiento: ${employee.nacimiento!.day}/${employee.nacimiento!.month}/${employee.nacimiento!.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'deleteBtn',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DeleteEmployeeScreen()),
            ).then((_) => _loadEmployees());
          },
          backgroundColor: Colors.red.shade400,
          tooltip: 'Eliminar empleados',
          child: const Icon(Icons.delete),
          mini: true,
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'addBtn',
          onPressed: _navigateToAddEmployeeScreen,
          backgroundColor: Colors.green.shade500,
          tooltip: 'Agregar empleado',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}