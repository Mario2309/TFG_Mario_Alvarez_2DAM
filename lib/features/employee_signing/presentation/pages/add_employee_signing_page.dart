import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee_signing/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee_signing/data/models/employee_signing_model.dart';
import 'package:nexuserp/features/employee_signing/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/core/utils/employees_strings.dart';

import '../../domain/entities/employee_signing.dart';
import '../../domain/repositories/employee_signing_repository.dart';

class AddEmployeeSigningPage extends StatefulWidget {
  final Employee employee;
  const AddEmployeeSigningPage({Key? key, required this.employee})
    : super(key: key);

  @override
  State<AddEmployeeSigningPage> createState() => _AddEmployeeSigningPageState();
}

class _AddEmployeeSigningPageState extends State<AddEmployeeSigningPage> {
  DateTime _selectedDateTime = DateTime.now();
  String _selectedType = 'entrada';
  bool _isLoading = false;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      await EmployeeSingingService().addAttendance(
        EmployeeSigningModel(
          empleadoId: widget.employee.id!,
          fechaHora: _selectedDateTime,
          tipo: _selectedType,
          empleadoNombre: widget.employee.nombreCompleto,
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(EmployeesStrings.signingRegistered),
          backgroundColor: Colors.green.shade600,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${EmployeesStrings.signingError} $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.employee.nombreCompleto.split(' ').first;
    return Scaffold(
      appBar: AppBar(
        title: Text('${EmployeesStrings.newSigningTitle} - $name'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.fingerprint, size: 60, color: Colors.blue.shade700),
            const SizedBox(height: 20),
            Text(
              '${EmployeesStrings.registerSigningFor} $name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _pickDateTime,
                  child: Text(EmployeesStrings.change),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.swap_vert_circle, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: [
                      DropdownMenuItem(
                        value: 'entrada',
                        child: Text(EmployeesStrings.signingTypeIn),
                      ),
                      DropdownMenuItem(
                        value: 'salida',
                        child: Text(EmployeesStrings.signingTypeOut),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                    decoration: InputDecoration(
                      labelText: EmployeesStrings.signingTypeLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Icon(Icons.check_circle),
              label: Text(
                _isLoading
                    ? EmployeesStrings.saving
                    : EmployeesStrings.registerSigningButton,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                shadowColor: Colors.blue.shade900.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
