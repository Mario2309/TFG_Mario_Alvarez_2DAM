import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../../../core/utils/employees_strings.dart';
import '../../data/repositories/vacation_repository_impl.dart';
import '../../data/models/credential_employee_model.dart';

class AddCredentialForEmployeePage extends StatefulWidget {
  final String employeeDni;
  final String correo;
  final EmployeeCredentialRepositoryImpl repository;
  const AddCredentialForEmployeePage({
    Key? key,
    required this.employeeDni,
    required this.correo,
    required this.repository,
  }) : super(key: key);

  @override
  State<AddCredentialForEmployeePage> createState() =>
      _AddCredentialForEmployeePageState();
}

class _AddCredentialForEmployeePageState
    extends State<AddCredentialForEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.correo;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Envía el formulario para agregar la credencial del empleado.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final credential = EmployeeCredentialModel(
        employeeDni: widget.employeeDni,
        email: widget.correo,
        hashedPassword: _hashPassword(_passwordController.text.trim()),
      );
      await widget.repository.addCredential(credential);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(EmployeesStrings.credentialAdded),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${EmployeesStrings.credentialError} $e'),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Genera el hash SHA-256 de la contraseña proporcionada.
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Construye la decoración para los campos de texto del formulario.
  InputDecoration _buildInputDecoration(String label, {bool enabled = true}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: enabled ? Colors.grey.shade700 : Colors.grey.shade500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade500),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade500),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          EmployeesStrings.addCredentialTitle,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                EmployeesStrings.credentialData,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                EmployeesStrings.credentialSubtitle,
                style: TextStyle(fontSize: 16, color: Color(0xFF4A5568)),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: _buildInputDecoration(
                  EmployeesStrings.credentialEmail,
                  enabled: false,
                ),
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return EmployeesStrings.enterEmail;
                  }
                  if (!value.contains('@')) {
                    return EmployeesStrings.invalidCredentialEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _buildInputDecoration(EmployeesStrings.password),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return EmployeesStrings.enterPassword;
                  }
                  if (value.length < 6) {
                    return EmployeesStrings.passwordMinLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_task, color: Colors.white),
                  label: const Text(
                    EmployeesStrings.addCredentialButton,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    elevation: 4,
                    shadowColor: Colors.blue.withOpacity(0.3),
                  ),
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
