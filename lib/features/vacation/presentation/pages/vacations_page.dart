import 'package:flutter/material.dart';
import 'package:nexuserp/features/vacation/data/models/vacation_model.dart';
import 'package:nexuserp/features/vacation/data/repositories/vacation_repository_impl.dart';
import 'package:nexuserp/features/vacation/data/datasources/vacation_service.dart';
import 'package:nexuserp/features/vacation/domain/entities/vacation.dart';

class VacationsPage extends StatefulWidget {
  @override
  _VacationsPageState createState() => _VacationsPageState();
}

class _VacationsPageState extends State<VacationsPage> {
  List<Vacation> _vacations = [];
  late final VacationRepositoryImpl _repository;
  late final VacationService _vacationService;

  @override
  void initState() {
    super.initState();
    _vacationService = VacationService();
    _repository = VacationRepositoryImpl(_vacationService);
    _loadVacations();
  }

  Future<void> _loadVacations() async {
    final vacations = await _repository.getVacations();
    setState(() {
      _vacations = vacations;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade400;
      case 'rejected':
        return Colors.red.shade400;
      default:
        return Colors.orange.shade400;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _vacations.isEmpty ? _buildEmptyState() : _buildVacationList(),
          Positioned(
            bottom: 16,
            left: 24,
            child: FloatingActionButton(
              heroTag: 'refreshBtn',
              onPressed: _loadVacations,
              backgroundColor: Colors.blue.shade700,
              tooltip: 'Recargar vacaciones',
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Gestión de Vacaciones'),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
      elevation: 2,
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No hay solicitudes de vacaciones registradas.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildVacationList() {
    return ListView.builder(
      itemCount: _vacations.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        return _buildVacationCard(_vacations[index]);
      },
    );
  }

  Widget _buildVacationCard(Vacation vacation) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(
                vacation.status,
              ).withOpacity(0.2),
              child: Icon(
                _getStatusIcon(vacation.status),
                color: _getStatusColor(vacation.status),
              ),
            ),
            title: Text(
              vacation.employeeName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Desde: ${vacation.startDate.toLocal().toString().split(' ')[0]}\n'
              'Hasta: ${vacation.endDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _getStatusColor(vacation.status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                vacation.status.toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(vacation.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
