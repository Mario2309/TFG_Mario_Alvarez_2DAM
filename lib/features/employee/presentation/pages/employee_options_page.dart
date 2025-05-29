import 'package:flutter/material.dart';
import 'package:nexuserp/features/credentials_employees/data/datasources/vacation_service.dart';
import 'package:nexuserp/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/presentation/pages/edit_employee_page.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee/presentation/pages/select_vacation_period_page.dart';
import 'package:nexuserp/features/employee_files/presentation/pages/upload_employee_file_page.dart';
import 'package:nexuserp/features/credentials_employees/presentation/pages/add_credential_for_employee_page.dart';
import 'package:nexuserp/features/credentials_employees/data/repositories/vacation_repository_impl.dart';
import '../../../../core/utils/employees_strings.dart';

class EmployeeOptionsPage extends StatefulWidget {
  final Employee employee;

  const EmployeeOptionsPage({
    super.key,
    required this.employee,
    required EmployeeRepositoryImpl employeeService,
  });

  @override
  _EmployeeOptionsPageState createState() => _EmployeeOptionsPageState();
}

class _EmployeeOptionsPageState extends State<EmployeeOptionsPage> {
  final EmployeeService _employeeService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    final employee = widget.employee;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${EmployeesStrings.optionsTitle} ${employee.nombreCompleto}',
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            _buildOptionCard(
              icon: Icons.info,
              label: EmployeesStrings.viewDetails,
              color: Colors.blue.shade100,
              iconColor: Colors.blue.shade700,
              onTap: () => _showDetailsDialog(context),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: Icons.calendar_month,
              label: EmployeesStrings.selectVacation,
              color: Colors.green.shade100,
              iconColor: Colors.green.shade700,
              onTap: () => _navigateToVacationSelection(context),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: Icons.edit,
              label: EmployeesStrings.edit,
              color: Colors.orange.shade100,
              iconColor: Colors.orange.shade700,
              onTap: () => _navigateToEdit(context),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: Icons.upload_file,
              label: EmployeesStrings.uploadDocument,
              color: Colors.purple.shade100,
              iconColor: Colors.purple.shade700,
              onTap: () => _navigateToUploadFile(context),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: Icons.vpn_key,
              label: EmployeesStrings.assignCredential,
              color: Colors.teal.shade100,
              iconColor: Colors.teal.shade700,
              onTap: () => _navigateToAddCredential(context),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: Icons.delete,
              label: EmployeesStrings.delete,
              color: Colors.red.shade100,
              iconColor: Colors.red.shade700,
              onTap: () => _confirmDelete(context),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: Icons.cancel,
              label: EmployeesStrings.cancel,
              color: Colors.grey.shade300,
              iconColor: Colors.grey.shade700,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          width: double.infinity,
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
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

  void _showDetailsDialog(BuildContext context) {
    final e = widget.employee;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('${EmployeesStrings.detailsTitle} ${e.nombreCompleto}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailLine(EmployeesStrings.email, e.correoElectronico),
                  _detailLine(EmployeesStrings.phone, e.numeroTelefono),
                  _detailLine(EmployeesStrings.dni, e.dni),
                  _detailLine(
                    EmployeesStrings.birth,
                    '${e.nacimiento.day}/${e.nacimiento.month}/${e.nacimiento.year}',
                  ),
                  _detailLine(EmployeesStrings.position, e.cargo),
                  _detailLine(
                    EmployeesStrings.salary,
                    '\$${e.sueldo.toStringAsFixed(2)}',
                  ),
                  _detailLine(
                    EmployeesStrings.hireDate,
                    '${e.fechaContratacion.day}/${e.fechaContratacion.month}/${e.fechaContratacion.year}',
                  ),
                  _detailLine(
                    EmployeesStrings.activeLabel,
                    e.activo ? EmployeesStrings.yes : EmployeesStrings.no,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(EmployeesStrings.close),
              ),
            ],
          ),
    );
  }

  Widget _detailLine(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$label: [0m${value ?? EmployeesStrings.notAvailable}',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final employee = widget.employee;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => EditEmployeePage(
              employee: Employee(
                id: employee.id,
                nombreCompleto: employee.nombreCompleto,
                nacimiento: employee.nacimiento,
                correoElectronico: employee.correoElectronico,
                numeroTelefono: employee.numeroTelefono,
                dni: employee.dni,
                sueldo: employee.sueldo,
                cargo: employee.cargo,
                fechaContratacion: employee.fechaContratacion,
                activo: employee.activo,
              ),
              employeeService: _employeeService,
            ),
      ),
    );

    if (mounted) {
      Navigator.pop(context, true); // Regresa y notifica que se editó
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final employee = widget.employee;
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(EmployeesStrings.confirmDelete),
            content: Text(
              '${EmployeesStrings.confirmDeleteMsg} ${employee.nombreCompleto}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(EmployeesStrings.cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(EmployeesStrings.delete),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _employeeService.deleteEmployee(employee.dni);
      if (mounted) {
        Navigator.pop(context, true); // Cierra y notifica eliminación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${employee.nombreCompleto} ${EmployeesStrings.deletedSuccessfully}',
            ),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  Future<void> _navigateToVacationSelection(BuildContext context) async {
    final employee = widget.employee;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectVacationPeriodPage(employee: employee),
      ),
    );
  }

  Future<void> _navigateToUploadFile(BuildContext context) async {
    final employee = widget.employee;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => UploadEmployeeFilePage(
              employeeId: employee.id!,
              employeeName: employee.nombreCompleto,
            ),
      ),
    );
  }

  Future<void> _navigateToAddCredential(BuildContext context) async {
    final employee = widget.employee;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AddCredentialForEmployeePage(
              employeeDni: employee.dni,
              correo: employee.correoElectronico,
              repository: EmployeeCredentialRepositoryImpl(
                credentialService: CredentialService(),
              ),
            ),
      ),
    );
  }
}
