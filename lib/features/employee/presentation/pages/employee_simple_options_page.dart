import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/presentation/pages/select_vacation_period_page.dart';
import 'package:nexuserp/features/employee_files/presentation/pages/upload_employee_file_page.dart';
import 'package:nexuserp/presentation/pages/login.dart';

class EmployeeSimpleOptionsPage extends StatelessWidget {
  final Employee employee;
  const EmployeeSimpleOptionsPage({Key? key, required this.employee})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opciones rápidas de ${employee.nombreCompleto}'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(
              context,
              icon: Icons.calendar_month,
              label: 'Vacaciones',
              color: Colors.green.shade100,
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
            const SizedBox(height: 24),
            _buildOptionButton(
              context,
              icon: Icons.upload_file,
              label: 'Subir archivo',
              color: Colors.purple.shade100,
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
            const SizedBox(height: 24),
            _buildOptionButton(
              context,
              icon: Icons.logout,
              label: 'Cerrar sesión',
              color: Colors.red.shade100,
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
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 32),
              const SizedBox(width: 18),
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
