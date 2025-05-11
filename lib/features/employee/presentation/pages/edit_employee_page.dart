import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart'; // Importa tu servicio de empleados
import '../../data/models/employee_model.dart' show EmployeeModel;

class EditEmployeePage extends StatefulWidget {
  final EmployeeModel employee;
  final EmployeeService employeeService;

  const EditEmployeePage({
    Key? key,
    required this.employee,
    required this.employeeService,
  }) : super(key: key);

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _dniController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.employee.nombreCompleto,
    );
    _emailController = TextEditingController(
      text: widget.employee.correoElectronico,
    );
    _telefonoController = TextEditingController(
      text: widget.employee.numeroTelefono,
    );
    _dniController = TextEditingController(text: widget.employee.dni);
    _selectedDate = widget.employee.nacimiento;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedEmployee = EmployeeModel(
        nombreCompleto: _nombreController.text,
        nacimiento: _selectedDate,
        correoElectronico: _emailController.text,
        numeroTelefono: _telefonoController.text,
        dni: _dniController.text,
      );

      // Llamada al servicio para actualizar el empleado en la base de datos
      final success = await widget.employeeService.updateEmployee(
        updatedEmployee,
      );

      if (success) {
        // Si la actualización es exitosa, regresa a la página anterior
        Navigator.pop(context);
      } else {
        // Si ocurre un error en la actualización
        _showErrorDialog();
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'No se pudo actualizar al empleado. Inténtalo nuevamente.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        title: const Text('Editar Empleado'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Nombre Completo',
                controller: _nombreController,
                icon: Icons.person,
              ),
              _buildTextField(
                label: 'Correo Electrónico',
                controller: _emailController,
                icon: Icons.email,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: 'Número de Teléfono',
                controller: _telefonoController,
                icon: Icons.phone,
              ),
              _buildTextField(
                label: 'DNI',
                controller: _dniController,
                icon: Icons.badge,
                isEnabled: false, // Aquí deshabilitamos el campo
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Nacimiento: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Cambiar'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                    ),
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    bool isEnabled =
        true, // Añadimos un parámetro para habilitar/deshabilitar el campo
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator:
            validator ?? (value) => value!.isEmpty ? 'Campo requerido' : null,
        enabled: isEnabled, // Usamos el parámetro para habilitar/deshabilitar
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
}
