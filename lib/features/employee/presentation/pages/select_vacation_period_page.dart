import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/vacation/data/datasources/vacation_service.dart';
import 'package:nexuserp/features/vacation/domain/entities/vacation.dart';
import 'package:nexuserp/features/vacation/data/repositories/vacation_repository_impl.dart';

class SelectVacationPeriodPage extends StatefulWidget {
  final Employee employee;

  const SelectVacationPeriodPage({super.key, required this.employee});

  @override
  State<SelectVacationPeriodPage> createState() =>
      _SelectVacationPeriodPageState();
}

class _SelectVacationPeriodPageState extends State<SelectVacationPeriodPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  late final VacationRepositoryImpl _vacationRepository;

  @override
  void initState() {
    super.initState();
    _vacationRepository = VacationRepositoryImpl(VacationService());
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (_startDate != null &&
        _endDate != null &&
        _startDate!.isBefore(_endDate!)) {
      final vacation = Vacation(
        employeeName: widget.employee.nombreCompleto,
        employeeDni: widget.employee.dni,
        startDate: _startDate!,
        endDate: _endDate!,
        status: 'Pendiente',
      );

      await _vacationRepository.addVacation(vacation);

      if (mounted) {
        Navigator.pop(context, vacation);
      }
    } else {
      _showSnackBar('Selecciona un rango de fechas válido');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacaciones - ${widget.employee.nombreCompleto}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Inicio'),
              subtitle: Text(
                _startDate != null
                    ? _startDate!.toLocal().toString().split(' ')[0]
                    : 'No seleccionado',
              ),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Fin'),
              subtitle: Text(
                _endDate != null
                    ? _endDate!.toLocal().toString().split(' ')[0]
                    : 'No seleccionado',
              ),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Guardar periodo'),
            ),
          ],
        ),
      ),
    );
  }
}
