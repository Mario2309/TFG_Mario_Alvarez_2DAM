import 'package:flutter/material.dart';
import 'package:nexuserp/features/vacation/data/models/vacation_model.dart';
import 'package:nexuserp/features/vacation/data/repositories/vacation_repository_impl.dart';
import 'package:nexuserp/features/vacation/data/datasources/vacation_service.dart';
import 'package:nexuserp/features/vacation/domain/entities/vacation.dart';

import '../../../../presentation/pages/search_page.dart';
import 'vacation_details_page.dart'; // Importa la página de detalles de vacaciones

class VacationsPage extends StatefulWidget {
  @override
  _VacationsPageState createState() => _VacationsPageState();
}

class _VacationsPageState extends State<VacationsPage> {
  List<Vacation> _vacations = [];
  List<Vacation> _filteredVacations = []; // Lista para vacaciones filtradas
  late final VacationRepositoryImpl _repository;
  late final VacationService _vacationService;

  String _filtroEstado = 'Todos';
  String _searchQuery = ''; // Variable para la consulta de búsqueda
  final TextEditingController _searchController =
      TextEditingController(); // Controlador para el campo de búsqueda

  @override
  void initState() {
    super.initState();
    _vacationService = VacationService();
    _repository = VacationRepositoryImpl(_vacationService);
    _loadVacations();

    // Listener para el campo de búsqueda
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
        _applyFilter(); // Aplica el filtro cada vez que cambia la búsqueda
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Disponer del controlador al salir
    super.dispose();
  }

  Future<void> _loadVacations() async {
    final vacations = await _repository.getVacations();
    setState(() {
      _vacations = vacations;
      _applyFilter(); // Aplica el filtro después de cargar las vacaciones
    });
  }

  // Función para aplicar filtros de estado y búsqueda
  void _applyFilter() {
    List<Vacation> temp = _vacations;

    // Filtrar por estado
    if (_filtroEstado != 'Todos') {
      temp =
          temp
              .where(
                (v) => v.status.toLowerCase() == _filtroEstado.toLowerCase(),
              )
              .toList();
    }

    // Filtrar por búsqueda (por nombre de empleado en este caso)
    if (_searchQuery.isNotEmpty) {
      temp =
          temp
              .where((v) => v.employeeName.toLowerCase().contains(_searchQuery))
              .toList();
    }

    _filteredVacations = temp;
  }

  // Función para obtener el color del estado
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprobada':
        return Colors.green.shade400;
      case 'rechazada':
        return Colors.red.shade400;
      case 'pendiente':
        return Colors.yellow.shade700; // Color amarillo para 'pendiente'
      default:
        return Colors
            .grey
            .shade400; // Color por defecto para estados desconocidos
    }
  }

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

  // Widget para las opciones de filtro y acciones rápidas en el Drawer
  Widget _buildFilterOptions(bool showBackButton) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
          ), // Color adaptado a la AppBar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Opciones",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (showBackButton)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SearchPage()),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre de empleado...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.blue.shade600, // Color adaptado
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Filtrar por estado',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        RadioListTile<String>(
          value: 'Todos',
          groupValue: _filtroEstado,
          title: const Text("Todos"),
          onChanged: (value) {
            setState(() {
              _filtroEstado = value!;
              _applyFilter();
            });
          },
        ),
        RadioListTile<String>(
          value: 'Aprobada',
          groupValue: _filtroEstado,
          title: const Text("Aprobadas"),
          onChanged: (value) {
            setState(() {
              _filtroEstado = value!;
              _applyFilter();
            });
          },
        ),
        RadioListTile<String>(
          value: 'Rechazada',
          groupValue: _filtroEstado,
          title: const Text("Rechazadas"),
          onChanged: (value) {
            setState(() {
              _filtroEstado = value!;
              _applyFilter();
            });
          },
        ),
        RadioListTile<String>(
          value: 'Pendiente',
          groupValue: _filtroEstado,
          title: const Text("Pendientes"),
          onChanged: (value) {
            setState(() {
              _filtroEstado = value!;
              _applyFilter();
            });
          },
        ),
        const Divider(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Acciones rápidas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Recargar solicitudes'),
          onTap: () {
            _loadVacations();
            if (showBackButton)
              Navigator.pop(context); // Cierra el Drawer al recargar
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Acerca de'),
          onTap: () {
            if (showBackButton) Navigator.pop(context);
            showAboutDialog(
              context: context,
              applicationName: 'Gestión de Vacaciones',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(
                Icons.beach_access,
              ), // Icono de vacaciones
              children: [
                const Text(
                  'Aplicación para gestionar solicitudes de vacaciones, con filtros y búsqueda.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width >= 800;

    // Define el número de columnas basado en el ancho de la pantalla
    final crossAxisCount = (width / 300).floor().clamp(1, 4);

    // Relación de aspecto fija para las tarjetas, similar a las de empleados
    final double fixedCardAspectRatio = 2.0;

    return Scaffold(
      appBar: _buildAppBar(),
      // El Drawer se muestra solo en pantallas pequeñas
      drawer: isLargeScreen ? null : Drawer(child: _buildFilterOptions(true)),
      body: Row(
        children: [
          // La barra lateral de opciones se muestra en pantallas grandes
          if (isLargeScreen)
            Container(
              width: 280,
              color: Colors.blue.shade50,
              child: _buildFilterOptions(
                false,
              ), // No necesita botón de retroceso aquí
            ),
          Expanded(
            child: Stack(
              children: [
                _filteredVacations.isEmpty
                    ? _buildEmptyState()
                    : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        itemCount: _filteredVacations.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              crossAxisCount, // Número de columnas adaptable
                          childAspectRatio:
                              fixedCardAspectRatio, // Relación de aspecto fija
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return _buildVacationCard(_filteredVacations[index]);
                        },
                      ),
                    ),
              ],
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
      backgroundColor: Colors.blue,
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

  // Tarjeta de vacación con estilo similar a la tarjeta de empleado
  Widget _buildVacationCard(Vacation vacation) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navega a la página de detalles de la vacación
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VacationDetailPage(vacation: vacation),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _getStatusColor(
                      vacation.status,
                    ).withOpacity(0.2),
                    child: Icon(
                      _getStatusIcon(vacation.status),
                      color: _getStatusColor(vacation.status),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      vacation.employeeName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(vacation.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      vacation.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(vacation.status),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Detalles de la vacación
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Desde:',
                value: vacation.startDate.toLocal().toString().split(' ')[0],
              ),
              const SizedBox(height: 4),
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Hasta:',
                value: vacation.endDate.toLocal().toString().split(' ')[0],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    minimumSize: const Size(60, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text(
                    'Ver Detalles',
                    style: TextStyle(fontSize: 13),
                  ),
                  onPressed: () {
                    // Navega a la página de detalles de la vacación
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VacationDetailPage(vacation: vacation),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para construir filas de información
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
