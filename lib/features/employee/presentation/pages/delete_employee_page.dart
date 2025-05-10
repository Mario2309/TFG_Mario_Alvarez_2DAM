import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';

class DeleteEmployeeScreen extends StatefulWidget {
  @override
  _DeleteEmployeeScreenState createState() => _DeleteEmployeeScreenState();
}

class _DeleteEmployeeScreenState extends State<DeleteEmployeeScreen> {
  final _repository = EmployeeRepositoryImpl(EmployeeService());
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final list = await _repository.getEmployees();
    if (mounted) {
      setState(() {
        _employees = list;
      });
    }
  }

  Future<void> _deleteEmployee(Employee employee) async {
    //await _repository.deleteEmployee(employee.id);
    if (mounted) {
      setState(() {
        _employees.remove(employee); // Eliminar el empleado de la lista localmente
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${employee.nombreCompleto} eliminado.')),
    );
    
    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeleteEmployeeScreen()),
            ).then((_) => _loadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar empleados'),
        backgroundColor: Colors.red.shade700,
      ),
      body: _employees.isEmpty
          ? Center(child: Text('No hay empleados para eliminar.'))
          : ListView.builder(
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                return ListTile(
                  title: Text(employee.nombreCompleto),
                  subtitle: Text(employee.correoElectronico ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEmployee(employee), // Eliminación directa
                  ),
                );
              },
            ),
    );
  }
}
