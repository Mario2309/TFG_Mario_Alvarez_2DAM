import 'package:flutter/material.dart';
import 'package:nexuserp/features/vacation/data/models/vacation_model.dart';
import 'package:nexuserp/features/vacation/data/repositories/vacation_repository_impl.dart';
import 'package:nexuserp/features/vacation/data/datasources/vacation_service.dart';
import 'package:nexuserp/features/vacation/domain/entities/vacation.dart';
import '../../../../core/utils/vacations_strings.dart';

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
          decoration: BoxDecoration(color: Colors.blue.shade700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    VacationsStrings.options,
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
                  hintText: VacationsStrings.searchHint,
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.blue.shade600,
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
            VacationsStrings.filterByStatus,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        RadioListTile<String>(
          value: VacationsStrings.all,
          groupValue: _filtroEstado,
          title: const Text(VacationsStrings.all),
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
          title: const Text(VacationsStrings.approved),
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
          title: const Text(VacationsStrings.rejected),
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
          title: const Text(VacationsStrings.pending),
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
            VacationsStrings.quickActions,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text(VacationsStrings.reload),
          onTap: () {
            _loadVacations();
            if (showBackButton) Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text(VacationsStrings.about),
          onTap: () {
            if (showBackButton) Navigator.pop(context);
            showAboutDialog(
              context: context,
              applicationName: VacationsStrings.aboutTitle,
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.beach_access),
              children: [const Text(VacationsStrings.aboutDescription)],
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
    final crossAxisCount = (width / 300).floor().clamp(1, 4);
    final double fixedCardAspectRatio = 2.0;
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: isLargeScreen ? null : Drawer(child: _buildFilterOptions(true)),
      body: Row(
        children: [
          if (isLargeScreen)
            Container(
              width: 280,
              color: Colors.blue.shade50,
              child: _buildFilterOptions(false),
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
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: fixedCardAspectRatio,
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
      title: const Text(
        VacationsStrings.pageTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black45,
            ),
          ],
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
      elevation: 12,
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        VacationsStrings.noRequests,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // Tarjeta de vacación con estilo similar a la tarjeta de empleado
  Widget _buildVacationCard(Vacation vacation) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        if (width < 320) {
          // Muy pequeño: columna, fuentes mínimas
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VacationDetailPage(vacation: vacation),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: _getStatusColor(
                            vacation.status,
                          ).withOpacity(0.2),
                          child: Icon(
                            _getStatusIcon(vacation.status),
                            color: _getStatusColor(vacation.status),
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            vacation.employeeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vacation.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(vacation.status),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: VacationsStrings.from,
                      value:
                          vacation.startDate.toLocal().toString().split(' ')[0],
                    ),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: VacationsStrings.to,
                      value:
                          vacation.endDate.toLocal().toString().split(' ')[0],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 1,
                          ),
                          minimumSize: const Size(40, 20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.info_outline, size: 13),
                        label: const Text(
                          VacationsStrings.viewDetails,
                          style: TextStyle(fontSize: 9),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      VacationDetailPage(vacation: vacation),
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
        } else if (width < 500) {
          // Móvil pequeño: columna, fuentes compactas
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VacationDetailPage(vacation: vacation),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: _getStatusColor(
                            vacation.status,
                          ).withOpacity(0.2),
                          child: Icon(
                            _getStatusIcon(vacation.status),
                            color: _getStatusColor(vacation.status),
                            size: 17,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            vacation.employeeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vacation.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(vacation.status),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: VacationsStrings.from,
                      value:
                          vacation.startDate.toLocal().toString().split(' ')[0],
                    ),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: VacationsStrings.to,
                      value:
                          vacation.endDate.toLocal().toString().split(' ')[0],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          minimumSize: const Size(50, 22),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.info_outline, size: 15),
                        label: const Text(
                          VacationsStrings.viewDetails,
                          style: TextStyle(fontSize: 10),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      VacationDetailPage(vacation: vacation),
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
        } else if (width < 900) {
          // Tablet/móvil grande: dos bloques horizontales, usando Wrap
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VacationDetailPage(vacation: vacation),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        CircleAvatar(
                          backgroundColor: _getStatusColor(
                            vacation.status,
                          ).withOpacity(0.2),
                          child: Icon(
                            _getStatusIcon(vacation.status),
                            color: _getStatusColor(vacation.status),
                          ),
                        ),
                        Text(
                          vacation.employeeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              vacation.status,
                            ).withOpacity(0.15),
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
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: VacationsStrings.from,
                          value:
                              vacation.startDate.toLocal().toString().split(
                                ' ',
                              )[0],
                        ),
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: VacationsStrings.to,
                          value:
                              vacation.endDate.toLocal().toString().split(
                                ' ',
                              )[0],
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            minimumSize: const Size(60, 28),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(Icons.info_outline, size: 18),
                          label: const Text(
                            VacationsStrings.viewDetails,
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        VacationDetailPage(vacation: vacation),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Escritorio ancho: todo en fila, mayor separación y alineación central
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VacationDetailPage(vacation: vacation),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: _getStatusColor(
                        vacation.status,
                      ).withOpacity(0.2),
                      child: Icon(
                        _getStatusIcon(vacation.status),
                        color: _getStatusColor(vacation.status),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      flex: 2,
                      child: Text(
                        vacation.employeeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          vacation.status,
                        ).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        vacation.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(vacation.status),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: VacationsStrings.from,
                      value:
                          vacation.startDate.toLocal().toString().split(' ')[0],
                    ),
                    const SizedBox(width: 32),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: VacationsStrings.to,
                      value:
                          vacation.endDate.toLocal().toString().split(' ')[0],
                    ),
                    const SizedBox(width: 32),
                    Flexible(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          minimumSize: const Size(80, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.info_outline, size: 22),
                        label: const Text(
                          VacationsStrings.viewDetails,
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      VacationDetailPage(vacation: vacation),
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
      },
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
