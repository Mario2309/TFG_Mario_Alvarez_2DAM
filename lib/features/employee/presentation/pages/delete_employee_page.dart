import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee/presentation/pages/employees_page.dart';

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
    try {
      final list = await _repository.getEmployees();
      if (mounted) {
        setState(() {
          _employees = list;
        });
      }
    } catch (e) {
      // Mostrar un mensaje de error si no se puede cargar la lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los empleados: $e')),
      );
    }
  }

  Future<void> _deleteEmployee(Employee employee) async {
    // Mostrar un diálogo de confirmación
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text(
            '¿Estás seguro de que deseas eliminar a ${employee.nombreCompleto}?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el diálogo
                try {
                  // Intentamos eliminar el empleado de la base de datos
                  await _repository.deleteEmployee(employee.dni);

                  if (mounted) {
                    setState(() {
                      _employees.remove(
                        employee,
                      ); // Eliminar el empleado de la lista localmente
                    });
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${employee.nombreCompleto} eliminado.'),
                    ),
                  );
                  // Redirigir a la página de empleados después de eliminar el empleado
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeesPage()),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${employee.nombreCompleto} eliminado.'),
                    ),
                  );
                  print('Error al eliminar el empleado: $error');
                  // Redirigir a la página de empleados después de eliminar el empleado
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeesPage()),
                  );
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar empleados'),
        backgroundColor: Colors.red.shade700,
      ),
      body:
          _employees.isEmpty
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
                      onPressed:
                          () => _deleteEmployee(
                            employee,
                          ), // Eliminación con confirmación
                    ),
                  );
                },
              ),
    );
  }
}
