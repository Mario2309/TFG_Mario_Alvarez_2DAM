import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart'; // Importa tu servicio de empleados
import '../../data/models/employee_model.dart' show EmployeeModel;
import '../../domain/entities/employee.dart';

class EditEmployeePage extends StatefulWidget {
  final Employee employee;
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
  late TextEditingController _sueldoController;
  late TextEditingController _cargoController;

  late DateTime _nacimiento;
  late DateTime _fechaContratacion;
  late bool _activo;

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
    _sueldoController = TextEditingController(
      text: widget.employee.sueldo.toString(),
    );
    _cargoController = TextEditingController(text: widget.employee.cargo);

    _nacimiento = widget.employee.nacimiento;
    _fechaContratacion = widget.employee.fechaContratacion;
    _activo = widget.employee.activo;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _dniController.dispose();
    _sueldoController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  Future<void> _pickNacimientoDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nacimiento,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _nacimiento = picked;
      });
    }
  }

  Future<void> _pickFechaContratacionDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaContratacion,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fechaContratacion = picked;
      });
    }
  }

  void _toggleActivo(bool? value) {
    setState(() {
      _activo = value ?? false;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final sueldoParsed = double.tryParse(_sueldoController.text) ?? 0.0;

      final updatedEmployee = EmployeeModel(
        id: widget.employee.id, // Mantener el id original para la actualización
        nombreCompleto: _nombreController.text,
        nacimiento: _nacimiento,
        correoElectronico: _emailController.text,
        numeroTelefono: _telefonoController.text,
        dni: _dniController.text,
        sueldo: sueldoParsed,
        cargo: _cargoController.text,
        fechaContratacion: _fechaContratacion,
        activo: _activo,
      );

      final success = await widget.employeeService.updateEmployee(
        updatedEmployee,
      );

      if (success) {
        Navigator.pop(context);
      } else {
        _showErrorDialog();
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'No se pudo actualizar al empleado. Inténtalo nuevamente.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          ),
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
                keyboardType: TextInputType.emailAddress,
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
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: 'DNI',
                controller: _dniController,
                icon: Icons.badge,
                isEnabled: false, // no editable
              ),
              _buildTextField(
                label: 'Sueldo',
                controller: _sueldoController,
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Ingrese un sueldo válido';
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: 'Cargo',
                controller: _cargoController,
                icon: Icons.work,
              ),
              _buildDateField(
                label: 'Fecha de Nacimiento',
                date: _nacimiento,
                onPressed: _pickNacimientoDate,
              ),
              _buildDateField(
                label: 'Fecha de Contratación',
                date: _fechaContratacion,
                onPressed: _pickFechaContratacionDate,
              ),
              _buildActivoCheckbox(),
              const SizedBox(height: 24),
              _buildButtons(),
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
    bool isEnabled = true,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator:
            validator ?? (value) => value!.isEmpty ? 'Campo requerido' : null,
        enabled: isEnabled,
        keyboardType: keyboardType,
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

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: ${DateFormat('dd/MM/yyyy').format(date)}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          TextButton(onPressed: onPressed, child: const Text('Cambiar')),
        ],
      ),
    );
  }

  Widget _buildActivoCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CheckboxListTile(
        title: const Text('Empleado Activo'),
        value: _activo,
        onChanged: _toggleActivo,
        activeColor: Colors.blue.shade700,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
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
    );
  }
}
