import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final credential = EmployeeCredentialModel(
        employeeDni: widget.employeeDni,
        email: widget.correo,
        hashedPassword: _passwordController.text.trim(),
      );
      await widget.repository.addCredential(credential);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credencial agregada correctamente.')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar credencial: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showPasswordHashDialog() {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduce una contraseña para comprobar.'),
        ),
      );
      return;
    }
    final hash = _hashPassword(password);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hash de la contraseña'),
            content: SelectableText(hash),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar credencial al empleado')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce el correo';
                  }
                  if (!value.contains('@')) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce la contraseña';
                  }
                  if (value.length < 6) {
                    return 'Debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text('Agregar credencial'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _showPasswordHashDialog(),
                    child: const Text('Ver hash'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
