import 'package:flutter/material.dart';
import 'package:NexusERP/features/employee/domain/entities/employee.dart';
import 'package:NexusERP/features/employee/data/datasources/employee_service.dart';
import 'package:NexusERP/features/employee/data/repositories/employee_repository_impl.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCompletoController = TextEditingController();
  final _nacimientoController = TextEditingController();
  final _correoElectronicoController = TextEditingController();
  final _numeroTelefonoController = TextEditingController();
  final _dniController = TextEditingController();

  final _repository = EmployeeRepositoryImpl(EmployeeService());

  DateTime? _selectedDate;

  @override
  void dispose() {
    _nombreCompletoController.dispose();
    _nacimientoController.dispose();
    _correoElectronicoController.dispose();
    _numeroTelefonoController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _nacimientoController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: 0,
        nombreCompleto: _nombreCompletoController.text,
        nacimiento: _selectedDate!,
        correoElectronico: _correoElectronicoController.text,
        numeroTelefono: _numeroTelefonoController.text,
        dni: _dniController.text,
      );

      await _repository.addEmployee(employee);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Empleado'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nombreCompletoController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Por favor, introduce el nombre completo' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nacimientoController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (_) =>
                    _selectedDate == null ? 'Por favor, selecciona la fecha de nacimiento' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _correoElectronicoController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el correo electrónico';
                  }
                  if (!value.contains('@')) {
                    return 'Correo electrónico inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _numeroTelefonoController,
                decoration: const InputDecoration(
                  labelText: 'Número de Teléfono',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Por favor, introduce el número de teléfono' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dniController,
                decoration: const InputDecoration(
                  labelText: 'DNI',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Por favor, introduce el DNI' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Guardar Empleado', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}