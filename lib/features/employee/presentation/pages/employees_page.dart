import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/data/models/employee_model.dart';
import 'package:nexuserp/features/employee/presentation/pages/add_employee_screen.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee/presentation/pages/edit_employee_page.dart'
    show EditEmployeePage;
import 'package:nexuserp/features/employee/presentation/pages/employee_options_page.dart';
import 'package:nexuserp/presentation/pages/search_page.dart';
// Importa la nueva página de búsqueda si estuviera en un archivo separado.
// Para este ejemplo, la SearchPage se define en el mismo archivo al final.
// import 'package:nexuserp/features/employee/presentation/pages/search_page.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<Employee> _employees = [];
  List<Employee> _filteredEmployees = [];
  late final EmployeeRepositoryImpl _repository;
  late final EmployeeService _employeeService;

  String _filtroEstado = 'Todos';
  String _searchQuery =
      ''; // Esta variable se vuelve a usar para la búsqueda en línea

  final TextEditingController _searchController =
      TextEditingController(); // Este controlador se vuelve a usar para la búsqueda en línea

  @override
  void initState() {
    super.initState();
    _employeeService = EmployeeService();
    _repository = EmployeeRepositoryImpl(_employeeService);
    _loadEmployees();

    // Se vuelve a añadir el listener del _searchController
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
        _applyFilter();
      });
    });
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Es necesario disponer de este controlador aquí
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    final employees = await _repository.getEmployees();
    setState(() {
      _employees = employees;
      _applyFilter();
    });
  }

  void _applyFilter() {
    List<Employee> temp = _employees;

    // Filtrar por estado
    if (_filtroEstado == 'Activos') {
      temp = temp.where((e) => e.activo).toList();
    } else if (_filtroEstado == 'Inactivos') {
      temp = temp.where((e) => !e.activo).toList();
    }

    // Se vuelve a añadir la lógica de filtrado por búsqueda
    if (_searchQuery.isNotEmpty) {
      temp =
          temp
              .where(
                (e) => e.nombreCompleto.toLowerCase().contains(_searchQuery),
              )
              .toList();
    }

    _filteredEmployees = temp;
  }

  void _navigateToAddEmployeeScreen() {
    Navigator.push<Employee>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEmployeePage(employeeService: _repository),
      ),
    ).then((newEmployee) {
      if (newEmployee != null && mounted) {
        _loadEmployees();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newEmployee.nombreCompleto} agregado con éxito'),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    });
  }

  // Se añadió un parámetro 'showBackButton' para controlar la visibilidad del botón de retroceso.
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
                // Contenedor para el título y el botón de retroceso
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
                  // Muestra el botón de retroceso solo si showBackButton es true
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
              // Se ha vuelto a añadir el TextField de búsqueda aquí
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre...',
                  hintStyle: TextStyle(color: Colors.white70),
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
          value: 'Activos',
          groupValue: _filtroEstado,
          title: const Text("Activos"),
          onChanged: (value) {
            setState(() {
              _filtroEstado = value!;
              _applyFilter();
            });
          },
        ),
        RadioListTile<String>(
          value: 'Inactivos',
          groupValue: _filtroEstado,
          title: const Text("Inactivos"),
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
        // Se ha eliminado el ListTile de "Buscar empleados" de aquí
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Recargar empleados'),
          onTap: () {
            _loadEmployees();
            if (showBackButton)
              Navigator.pop(context); // Cierra el Drawer al recargar
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Agregar empleado'),
          onTap: () {
            // Ya se cierra el Drawer aquí, pero se mantiene la lógica para claridad
            Navigator.pop(context);
            _navigateToAddEmployeeScreen();
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Acerca de'),
          onTap: () {
            // Cierra el Drawer antes de mostrar el diálogo
            if (showBackButton) Navigator.pop(context);
            showAboutDialog(
              context: context,
              applicationName: 'Gestión de Empleados',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.people),
              children: [
                const Text(
                  'Aplicación para gestionar empleados, con filtros y búsqueda.',
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
    final crossAxisCount = (width / 300).floor().clamp(1, 4); // adaptable

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Empleados'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
      ),
      // Pasa 'true' a _buildFilterOptions si es una pantalla pequeña para mostrar el botón de retroceso
      drawer: isLargeScreen ? null : Drawer(child: _buildFilterOptions(true)),
      body: Row(
        children: [
          if (isLargeScreen)
            Container(
              width: 280,
              color: Colors.grey.shade100,
              // Pasa 'false' a _buildFilterOptions si es una pantalla grande (no necesita botón de retroceso)
              child: _buildFilterOptions(false),
            ),
          Expanded(
            child: Stack(
              children: [
                _filteredEmployees.isEmpty
                    ? const Center(
                      child: Text(
                        'No hay empleados registrados.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        itemCount: _filteredEmployees.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.0,
                        ),
                        itemBuilder: (context, index) {
                          return _buildEmployeeCard(_filteredEmployees[index]);
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

  Widget _buildEmployeeCard(Employee employee) {
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
                  radius: 20,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    employee.nombreCompleto,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        employee.activo
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    employee.activo ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color:
                          employee.activo
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (employee.correoElectronico.isNotEmpty)
              Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      employee.correoElectronico,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    minimumSize: const Size(60, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar', style: TextStyle(fontSize: 13)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => EditEmployeePage(
                              employee: employee,
                              employeeService: _employeeService,
                            ),
                      ),
                    ).then((updatedEmployee) {
                      if (updatedEmployee != null && mounted) {
                        _loadEmployees();
                      }
                    });
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    minimumSize: const Size(60, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.more_vert, size: 18),
                  label: const Text('Opciones', style: TextStyle(fontSize: 13)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => EmployeeOptionsPage(
                              employee: employee,
                              employeeService: _repository,
                            ),
                      ),
                    ).then((_) {
                      _loadEmployees();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
