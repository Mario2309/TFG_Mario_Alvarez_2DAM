import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee/data/models/employee_model.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';

class ActiveInactiveEmployeesPage extends StatefulWidget {
  const ActiveInactiveEmployeesPage({Key? key}) : super(key: key);

  @override
  _ActiveInactiveEmployeesPageState createState() =>
      _ActiveInactiveEmployeesPageState();
}

class _ActiveInactiveEmployeesPageState
    extends State<ActiveInactiveEmployeesPage> {
  final EmployeeService _employeeService = EmployeeService();
  List<Employee> _activeEmployees = [];
  List<Employee> _inactiveEmployees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final models = await _employeeService.fetchEmployees();
      final employees =
          models
              .map(
                (model) => Employee(
                  id: model.id,
                  nombreCompleto: model.nombreCompleto,
                  nacimiento: model.nacimiento,
                  correoElectronico: model.correoElectronico,
                  numeroTelefono: model.numeroTelefono,
                  dni: model.dni,
                  sueldo: model.sueldo,
                  cargo: model.cargo,
                  fechaContratacion: model.fechaContratacion,
                  activo: model.activo,
                ),
              )
              .toList();

      if (!mounted) return;

      setState(() {
        _activeEmployees = employees.where((e) => e.activo == true).toList();
        _inactiveEmployees = employees.where((e) => e.activo == false).toList();
      });
    } catch (e) {
      debugPrint('Error loading employees: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Empleados'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: RefreshIndicator(
        onRefresh: _loadEmployees,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            _buildSection('Empleados Activos', _activeEmployees, true),
            const SizedBox(height: 32),
            _buildSection('Empleados Inactivos', _inactiveEmployees, false),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Employee> employees, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.green.shade700 : Colors.red.shade700,
          ),
        ),
        const SizedBox(height: 16),
        if (employees.isEmpty)
          Text(
            'No hay empleados ${isActive ? 'activos' : 'inactivos'}.',
            style: const TextStyle(color: Colors.grey),
          )
        else
          ...employees.map(_buildEmployeeTile).toList(),
      ],
    );
  }

  Widget _buildEmployeeTile(Employee employee) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.blue.shade700),
        title: Text(employee.nombreCompleto),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (employee.correoElectronico != null)
              Text('Correo: ${employee.correoElectronico!}'),
            if (employee.numeroTelefono != null)
              Text('Teléfono: ${employee.numeroTelefono!}'),
            if (employee.cargo != null) Text('Cargo: ${employee.cargo!}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
  