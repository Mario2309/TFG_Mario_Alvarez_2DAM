import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart'; // Importa tu servicio de empleados
import '../../data/models/employee_model.dart' show EmployeeModel;
import '../../domain/entities/employee.dart';
import '../../../../core/utils/employees_strings.dart';

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

  /// Selecciona la fecha de nacimiento usando un selector de fecha.
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

  /// Selecciona la fecha de contratación usando un selector de fecha.
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

  /// Cambia el estado de activo del empleado.
  void _toggleActivo(bool? value) {
    setState(() {
      _activo = value ?? false;
    });
  }

  /// Envía el formulario para actualizar los datos del empleado.
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

  /// Muestra un diálogo de error si la actualización falla.
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text(EmployeesStrings.error),
            content: const Text(EmployeesStrings.updateEmployeeError),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(EmployeesStrings.accept),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(EmployeesStrings.editEmployee),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: EmployeesStrings.fullName,
                controller: _nombreController,
                icon: Icons.person,
              ),
              _buildTextField(
                label: EmployeesStrings.emailLabel,
                controller: _emailController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return EmployeesStrings.invalidEmail;
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: EmployeesStrings.phoneLabel,
                controller: _telefonoController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: EmployeesStrings.dniLabel,
                controller: _dniController,
                icon: Icons.badge,
                isEnabled: false, // no editable
              ),
              _buildTextField(
                label: EmployeesStrings.salaryLabel,
                controller: _sueldoController,
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return EmployeesStrings.validSalary;
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: EmployeesStrings.positionLabel,
                controller: _cargoController,
                icon: Icons.work,
              ),
              _buildDateField(
                label: EmployeesStrings.birthDate,
                date: _nacimiento,
                onPressed: _pickNacimientoDate,
              ),
              _buildDateField(
                label: EmployeesStrings.hireDateLabel,
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

  /// Construye un campo de texto personalizado para el formulario.
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
            validator ??
            (value) => value!.isEmpty ? EmployeesStrings.requiredField : null,
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

  /// Construye un campo de selección de fecha para el formulario.
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
          TextButton(
            onPressed: onPressed,
            child: const Text(EmployeesStrings.change),
          ),
        ],
      ),
    );
  }

  /// Construye el checkbox para indicar si el empleado está activo.
  Widget _buildActivoCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CheckboxListTile(
        title: const Text(EmployeesStrings.activeEmployee),
        value: _activo,
        onChanged: _toggleActivo,
        activeColor: Colors.blue.shade700,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  /// Construye los botones de acción para guardar o cancelar.
  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(EmployeesStrings.cancelButton),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
          ),
          child: const Text(EmployeesStrings.saveButton),
        ),
      ],
    );
  }
}
