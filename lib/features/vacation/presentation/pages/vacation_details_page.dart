import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexuserp/features/vacation/domain/entities/vacation.dart';
import '../../../../core/utils/vacation_details_strings.dart';

import '../../data/datasources/vacation_service.dart';

class VacationDetailPage extends StatefulWidget {
  final Vacation vacation;

  const VacationDetailPage({super.key, required this.vacation});

  @override
  State<VacationDetailPage> createState() => _VacationDetailPageState();
}

class _VacationDetailPageState extends State<VacationDetailPage> {
  // Usamos una variable de estado para la vacación para poder actualizar su estado
  late Vacation _currentVacation;

  @override
  void initState() {
    super.initState();
    _currentVacation = widget.vacation;
  }

  // Función para obtener el color del estado
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprobada':
        return Colors.green.shade400;
      case 'rechazada':
        return Colors.red.shade400;
      case 'pendiente':
        return Colors.yellow.shade700;
      default:
        return Colors.grey.shade400;
    }
  }

  // Función para obtener el icono del estado
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'aprobada':
        return Icons.check_circle;
      case 'rechazada':
        return Icons.cancel;
      case 'pendiente':
        return Icons.hourglass_empty;
      default:
        return Icons.info_outline;
    }
  }

  // Función para actualizar el estado de la vacación
  Future<void> _updateVacationStatus(String newStatus) async {
    setState(() {
      _currentVacation = _currentVacation.copyWith(status: newStatus);
    });

    try {
      await VacationService().updateVacationStatus(
        _currentVacation.id as int,
        newStatus,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La solicitud de ${_currentVacation.employeeName} ${newStatus.toLowerCase() == 'aprobada' ? VacationDetailsStrings.approveSuccess : VacationDetailsStrings.rejectSuccess}',
          ),
          backgroundColor: _getStatusColor(newStatus),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${VacationDetailsStrings.updateError} $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(VacationDetailsStrings.pageTitle),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta principal con el nombre del empleado y el estado
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: _getStatusColor(
                        _currentVacation.status,
                      ).withOpacity(0.2),
                      child: Icon(
                        _getStatusIcon(_currentVacation.status),
                        color: _getStatusColor(_currentVacation.status),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentVacation.employeeName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                _currentVacation.status,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              _currentVacation.status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(_currentVacation.status),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tarjeta con detalles de fechas
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: VacationDetailsStrings.startDate,
                      value:
                          _currentVacation.startDate.toLocal().toString().split(
                            ' ',
                          )[0],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: VacationDetailsStrings.endDate,
                      value:
                          _currentVacation.endDate.toLocal().toString().split(
                            ' ',
                          )[0],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: VacationDetailsStrings.daysRequested,
                      value:
                          (_currentVacation.endDate
                                      .difference(_currentVacation.startDate)
                                      .inDays +
                                  1)
                              .toString(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tarjeta con detalles adicionales
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      label: VacationDetailsStrings.dni,
                      value: _currentVacation.employeeDni,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.info_outline,
                      label: VacationDetailsStrings.name,
                      value:
                          _currentVacation.employeeName.isNotEmpty
                              ? _currentVacation.employeeName
                              : VacationDetailsStrings.notSpecified,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botones de acción (solo si el estado es 'Pendiente')
            if (_currentVacation.status.toLowerCase() == 'pendiente')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          () => _updateVacationStatus(
                            VacationDetailsStrings.approved,
                          ),
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text(
                        VacationDetailsStrings.approve,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          () => _updateVacationStatus(
                            VacationDetailsStrings.rejected,
                          ),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text(
                        VacationDetailsStrings.reject,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir filas de detalles
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
