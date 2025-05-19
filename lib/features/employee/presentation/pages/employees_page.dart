import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/data/models/employee_model.dart';
import 'package:nexuserp/features/employee/presentation/pages/add_employee_screen.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee/presentation/pages/edit_employee_page.dart'
    show EditEmployeePage;
import 'package:nexuserp/features/employee/presentation/pages/employee_options_page.dart';

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
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _employeeService = EmployeeService();
    _repository = EmployeeRepositoryImpl(_employeeService);
    _loadEmployees();

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

    // Filtrar por búsqueda
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

  Widget _buildFilterOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue.shade700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Opciones",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
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
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Recargar empleados'),
          onTap: () {
            _loadEmployees();
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Agregar empleado'),
          onTap: () {
            Navigator.pop(context);
            _navigateToAddEmployeeScreen();
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Acerca de'),
          onTap: () {
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
      drawer: isLargeScreen ? null : Drawer(child: _buildFilterOptions()),
      body: Row(
        children: [
          if (isLargeScreen)
            Container(
              width: 280,
              color: Colors.grey.shade100,
              child: _buildFilterOptions(),
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
