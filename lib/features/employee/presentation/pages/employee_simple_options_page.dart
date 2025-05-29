import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/presentation/pages/select_vacation_period_page.dart';
import 'package:nexuserp/features/employee_files/presentation/pages/upload_employee_file_page.dart';
import 'package:nexuserp/presentation/pages/login.dart';

import '../../../employee_signing/presentation/pages/add_employee_signing_page.dart';
import '../../../../core/utils/employees_strings.dart';

/// Página de opciones rápidas para un empleado.
/// Muestra un saludo personalizado y botones para acciones comunes.
class EmployeeSimpleOptionsPage extends StatelessWidget {
  final Employee employee;

  /// Constructor que requiere un objeto Employee.
  const EmployeeSimpleOptionsPage({Key? key, required this.employee})
    : super(key: key);

  /// Construye la interfaz principal de opciones rápidas para el empleado
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${EmployeesStrings.optionsTitle} ${employee.nombreCompleto}',
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
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.person_pin_circle,
              size: 100,
              color: Colors.blue.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              '${EmployeesStrings.welcome} ${employee.nombreCompleto.split(' ').first}!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.blue.shade800,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              EmployeesStrings.subtitle,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildOptionButton(
              context,
              icon: Icons.calendar_today,
              label: EmployeesStrings.requestVacation,
              color: Colors.green.shade50,
              iconColor: Colors.green.shade700,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => SelectVacationPeriodPage(employee: employee),
                    ),
                  ),
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              context,
              icon: Icons.cloud_upload,
              label: EmployeesStrings.uploadDocument,
              color: Colors.purple.shade50,
              iconColor: Colors.purple.shade700,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => UploadEmployeeFilePage(
                            employeeId: employee.id!,
                            employeeName: employee.nombreCompleto,
                          ),
                    ),
                  ),
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              context,
              icon: Icons.fingerprint,
              label: EmployeesStrings.addSigning,
              color: Colors.orange.shade50,
              iconColor: Colors.orange.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEmployeeSigningPage(employee: employee),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              context,
              icon: Icons.exit_to_app,
              label: EmployeesStrings.logout,
              color: Colors.red.shade50,
              iconColor: Colors.red.shade700,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un botón de opción con estilo personalizado
  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: iconColor.withOpacity(0.2),
        highlightColor: iconColor.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 36),
              const SizedBox(width: 20),
              Text(
                label,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
