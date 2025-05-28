import 'package:flutter/material.dart';
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

  Future<void> _loadFichajes() async {
    final fichajes = await _repository.getAllAttendances();
    setState(() {
      _fichajes = fichajes;
      _applyFilter();
    });
  }

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

  Widget _buildFilterOptions() {
    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue.shade700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Opciones",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre...',
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
          value: 'Todos',
          groupValue: _filtroTipo,
          title: const Text("Todos"),
          onChanged:
              (value) => setState(() {
                _filtroTipo = value!;
                _applyFilter();
              }),
        ),
        RadioListTile<String>(
          value: 'Entrada',
          groupValue: _filtroTipo,
          title: const Text("Entradas"),
          onChanged:
              (value) => setState(() {
                _filtroTipo = value!;
                _applyFilter();
              }),
        ),
        RadioListTile<String>(
          value: 'Salida',
          groupValue: _filtroTipo,
          title: const Text("Salidas"),
          onChanged:
              (value) => setState(() {
                _filtroTipo = value!;
                _applyFilter();
              }),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Recargar fichajes'),
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
        title: const Text('Fichajes'),
        backgroundColor: Colors.blue,
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
                    ? const Center(child: Text('No hay fichajes registrados.'))
                    : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        itemCount: _filteredFichajes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
        ],
      ),
    );
  }

  Widget _buildFichajeCard(EmployeeSigning fichaje) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getTipoColor(fichaje.tipo).withOpacity(0.2),
                  child: Icon(
                    _getTipoIcon(fichaje.tipo),
                    color: _getTipoColor(fichaje.tipo),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fichaje.empleadoNombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
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
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  fichaje.fechaHora != null
                      ? '${fichaje.fechaHora.day.toString().padLeft(2, '0')}/${fichaje.fechaHora.month.toString().padLeft(2, '0')}/${fichaje.fechaHora.year}  ${fichaje.fechaHora.hour.toString().padLeft(2, '0')}:${fichaje.fechaHora.minute.toString().padLeft(2, '0')}'
                      : 'Sin fecha',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.badge, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'ID Empleado: ${fichaje.empleadoId}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
          "$label ",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
