import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/vacation/data/datasources/vacation_service.dart';
import 'package:nexuserp/features/vacation/domain/entities/vacation.dart';
import 'package:nexuserp/features/vacation/data/repositories/vacation_repository_impl.dart';
import 'package:intl/intl.dart'; // Importar para formatear fechas
import '../../../../core/utils/employees_strings.dart';

/// Página para que el empleado seleccione un período de vacaciones y lo envíe para su aprobación.
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _vacationRepository = VacationRepositoryImpl(VacationService());
  }

  /// Selecciona una fecha usando un DatePicker y la asigna como inicio o fin.
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = null;
          }
        }
      });
    }
  }

  /// Guarda la solicitud de vacaciones validando fechas y mostrando feedback.
  Future<void> _save() async {
    if (_startDate == null || _endDate == null) {
      _showSnackBar(EmployeesStrings.selectStartAndEnd);
      return;
    }
    if (_startDate!.isAfter(_endDate!)) {
      _showSnackBar(EmployeesStrings.startAfterEnd);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final vacation = Vacation(
        employeeName: widget.employee.nombreCompleto,
        employeeDni: widget.employee.dni,
        startDate: _startDate!,
        endDate: _endDate!,
        status: 'Pendiente',
      );
      await _vacationRepository.addVacation(vacation);
      if (mounted) {
        _showSnackBar(EmployeesStrings.requestSent, isError: false);
        Navigator.pop(context, vacation);
      }
    } catch (e) {
      _showSnackBar('${EmployeesStrings.requestError} $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Muestra un SnackBar con el mensaje proporcionado.
  void _showSnackBar(String message, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? Colors.red.shade600 : Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${EmployeesStrings.vacationTitle} ${widget.employee.nombreCompleto.split(' ').first}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              '${EmployeesStrings.selectPeriod} ${widget.employee.nombreCompleto.split(' ').first}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildDateSelectionCard(
              context,
              icon: Icons.date_range,
              label: EmployeesStrings.startDate,
              date: _startDate,
              onTap: () => _selectDate(context, true),
              iconColor: Colors.green.shade600,
            ),
            const SizedBox(height: 20),
            _buildDateSelectionCard(
              context,
              icon: Icons.date_range,
              label: EmployeesStrings.endDate,
              date: _endDate,
              onTap: () => _selectDate(context, false),
              iconColor: Colors.orange.shade600,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _save,
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
                      : const Icon(Icons.send_rounded, size: 24),
              label: Text(
                _isLoading
                    ? EmployeesStrings.sending
                    : EmployeesStrings.sendRequest,
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

  /// Construye una tarjeta para seleccionar una fecha (inicio o fin).
  Widget _buildDateSelectionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 30, color: iconColor),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date != null
                          ? DateFormat('dd/MM/yyyy').format(date)
                          : EmployeesStrings.tapToSelect,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
