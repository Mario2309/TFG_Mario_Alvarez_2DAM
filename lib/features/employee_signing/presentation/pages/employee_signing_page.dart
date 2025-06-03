import 'package:flutter/material.dart';
import 'package:nexuserp/core/utils/employees_strings.dart';
import 'package:nexuserp/features/employee_signing/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee_signing/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee_signing/domain/entities/employee_signing.dart';
import 'package:nexuserp/features/employee_signing/domain/repositories/employee_signing_repository.dart';

class FichajesPage extends StatefulWidget {
  @override
  _FichajesPageState createState() => _FichajesPageState();
}

class _FichajesPageState extends State<FichajesPage> {
  List<EmployeeSigning> _fichajes = [];
  List<EmployeeSigning> _filteredFichajes = [];
  late final EmployeeSigningRepository _repository;
  late final EmployeeSingingService _fichajeService;

  String _filtroTipo = 'Todos';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fichajeService = EmployeeSingingService();
    _repository = EmployeeSingingRepositoryImpl(_fichajeService);
    _loadFichajes();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
        _applyFilter();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carga los fichajes desde el repositorio y actualiza el estado.
  Future<void> _loadFichajes() async {
    final fichajes = await _repository.getAllAttendances();
    if (!mounted) return;
    setState(() {
      _fichajes = fichajes;
      _applyFilter();
    });
  }

  /// Aplica el filtro de tipo y búsqueda sobre la lista de fichajes.
  void _applyFilter() {
    List<EmployeeSigning> temp = _fichajes;

    if (_filtroTipo != 'Todos') {
      temp =
          temp
              .where((f) => f.tipo.toLowerCase() == _filtroTipo.toLowerCase())
              .toList();
    }

    if (_searchQuery.isNotEmpty) {
      temp =
          temp
              .where(
                (f) => f.empleadoNombre.toLowerCase().contains(_searchQuery),
              )
              .toList();
    }

    _filteredFichajes = temp;
  }

  /// Devuelve el color asociado al tipo de fichaje (entrada/salida).
  Color _getTipoColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'entrada':
        return Colors.green.shade400;
      case 'salida':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  /// Devuelve el icono asociado al tipo de fichaje (entrada/salida).
  IconData _getTipoIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'entrada':
        return Icons.login;
      case 'salida':
        return Icons.logout;
      default:
        return Icons.info_outline;
    }
  }

  /// Construye el panel lateral de filtros y búsqueda.
  Widget _buildFilterOptions() {
    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue.shade700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                EmployeesStrings.options,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: EmployeesStrings.searchHint,
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
        RadioListTile<String>(
          value: EmployeesStrings.all,
          groupValue: _filtroTipo,
          title: Text(EmployeesStrings.all),
          onChanged:
              (value) => setState(() {
                _filtroTipo = value!;
                _applyFilter();
              }),
        ),
        RadioListTile<String>(
          value: EmployeesStrings.signingTypeIn,
          groupValue: _filtroTipo,
          title: Text(EmployeesStrings.signingTypeInPlural),
          onChanged:
              (value) => setState(() {
                _filtroTipo = value!;
                _applyFilter();
              }),
        ),
        RadioListTile<String>(
          value: EmployeesStrings.signingTypeOut,
          groupValue: _filtroTipo,
          title: Text(EmployeesStrings.signingTypeOutPlural),
          onChanged:
              (value) => setState(() {
                _filtroTipo = value!;
                _applyFilter();
              }),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: Text(EmployeesStrings.reloadSignings),
          onTap: () {
            _loadFichajes();
            Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text(
          EmployeesStrings.signingsTitle,
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
      ),
      drawer: isLargeScreen ? null : Drawer(child: _buildFilterOptions()),
      body: Row(
        children: [
          if (isLargeScreen)
            Container(
              width: 280,
              color: Colors.blue.shade50,
              child: _buildFilterOptions(),
            ),
          Expanded(
            child:
                _filteredFichajes.isEmpty
                    ? Center(child: Text(EmployeesStrings.noSignings))
                    : Padding(
                      padding: const EdgeInsets.all(12),
                      child: RefreshIndicator(
                        onRefresh: _loadFichajes,
                        child: GridView.builder(
                          itemCount: _filteredFichajes.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: fixedCardAspectRatio,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemBuilder: (context, index) {
                            return _buildFichajeCard(_filteredFichajes[index]);
                          },
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  /// Construye la tarjeta visual para un fichaje individual.
  Widget _buildFichajeCard(EmployeeSigning fichaje) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        if (width < 320) {
          // Pantalla muy pequeña: todo en columna, fuentes pequeñas
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: _getTipoColor(
                          fichaje.tipo,
                        ).withOpacity(0.2),
                        child: Icon(
                          _getTipoIcon(fichaje.tipo),
                          color: _getTipoColor(fichaje.tipo),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          fichaje.empleadoNombre,
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
                    fichaje.tipo.toUpperCase(),
                    style: TextStyle(
                      color: _getTipoColor(fichaje.tipo),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${fichaje.fechaHora.day.toString().padLeft(2, '0')}/${fichaje.fechaHora.month.toString().padLeft(2, '0')}/${fichaje.fechaHora.year}  ${fichaje.fechaHora.hour.toString().padLeft(2, '0')}:${fichaje.fechaHora.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.badge, size: 12, color: Colors.grey),
                      const SizedBox(width: 3),
                      Text(
                        'ID: ${fichaje.empleadoId}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (width < 400) {
          // Pantalla móvil pequeña: columna, fuentes compactas
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: _getTipoColor(
                          fichaje.tipo,
                        ).withOpacity(0.2),
                        child: Icon(
                          _getTipoIcon(fichaje.tipo),
                          color: _getTipoColor(fichaje.tipo),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fichaje.empleadoNombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fichaje.tipo.toUpperCase(),
                    style: TextStyle(
                      color: _getTipoColor(fichaje.tipo),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 13,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${fichaje.fechaHora.day.toString().padLeft(2, '0')}/${fichaje.fechaHora.month.toString().padLeft(2, '0')}/${fichaje.fechaHora.year}  ${fichaje.fechaHora.hour.toString().padLeft(2, '0')}:${fichaje.fechaHora.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.badge, size: 13, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'ID: ${fichaje.empleadoId}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (width < 800) {
          // Pantalla móvil grande/tablet: dos filas principales, usando Wrap para evitar desbordes
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                        backgroundColor: _getTipoColor(
                          fichaje.tipo,
                        ).withOpacity(0.2),
                        child: Icon(
                          _getTipoIcon(fichaje.tipo),
                          color: _getTipoColor(fichaje.tipo),
                        ),
                      ),
                      Text(
                        fichaje.empleadoNombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getTipoColor(fichaje.tipo).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          fichaje.tipo.toUpperCase(),
                          style: TextStyle(
                            color: _getTipoColor(fichaje.tipo),
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 15,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${fichaje.fechaHora.day.toString().padLeft(2, '0')}/${fichaje.fechaHora.month.toString().padLeft(2, '0')}/${fichaje.fechaHora.year}  ${fichaje.fechaHora.hour.toString().padLeft(2, '0')}:${fichaje.fechaHora.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.badge, size: 15, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            'ID: ${fichaje.empleadoId}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          // Pantalla muy ancha: todo en fila, más separación y alineación central
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
                    backgroundColor: _getTipoColor(
                      fichaje.tipo,
                    ).withOpacity(0.2),
                    child: Icon(
                      _getTipoIcon(fichaje.tipo),
                      color: _getTipoColor(fichaje.tipo),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    flex: 2,
                    child: Text(
                      fichaje.empleadoNombre,
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
                      color: _getTipoColor(fichaje.tipo).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      fichaje.tipo.toUpperCase(),
                      style: TextStyle(
                        color: _getTipoColor(fichaje.tipo),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${fichaje.fechaHora.day.toString().padLeft(2, '0')}/${fichaje.fechaHora.month.toString().padLeft(2, '0')}/${fichaje.fechaHora.year}  ${fichaje.fechaHora.hour.toString().padLeft(2, '0')}:${fichaje.fechaHora.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Row(
                    children: [
                      const Icon(Icons.badge, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'ID Empleado: ${fichaje.empleadoId}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
