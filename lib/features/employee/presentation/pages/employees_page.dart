import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/presentation/pages/add_employee_screen.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/employee/presentation/pages/employee_options_page.dart';
import 'package:nexuserp/presentation/pages/main_page.dart';
import 'package:nexuserp/presentation/pages/search_page.dart';
import 'package:nexuserp/features/employee_files/presentation/pages/files_employee_page.dart';
import '../../../../core/utils/employees_strings.dart';

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

  /// Inicializa servicios y carga empleados al iniciar la página
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

  /// Obtiene la lista de empleados desde el repositorio y aplica el filtro actual
  Future<void> _loadEmployees() async {
    final employees = await _repository.getEmployees();
    setState(() {
      _employees = employees;
      _applyFilter();
    });
  }

  /// Aplica los filtros de estado y búsqueda sobre la lista de empleados
  void _applyFilter() {
    List<Employee> temp = _employees;
    if (_filtroEstado == 'Activos') {
      temp = temp.where((e) => e.activo).toList();
    } else if (_filtroEstado == 'Inactivos') {
      temp = temp.where((e) => !e.activo).toList();
    }
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

  /// Navega a la pantalla para agregar un nuevo empleado y recarga la lista si se agrega uno
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

  /// Construye el Drawer de filtros y acciones rápidas
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
                    EmployeesStrings.options,
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
                  hintText: EmployeesStrings.searchHint,
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
            EmployeesStrings.filterByStatus,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        RadioListTile<String>(
          value: EmployeesStrings.all,
          groupValue: _filtroEstado,
          title: const Text(EmployeesStrings.all),
          onChanged: (value) {
            setState(() {
              _filtroEstado = value!;
              _applyFilter();
            });
          },
        ),
        RadioListTile<String>(
          value: EmployeesStrings.active,
          groupValue: _filtroEstado,
          title: const Text(EmployeesStrings.active),
          onChanged: (value) {
            setState(() {
              _filtroEstado = value!;
              _applyFilter();
            });
          },
        ),
        RadioListTile<String>(
          value: EmployeesStrings.inactive,
          groupValue: _filtroEstado,
          title: const Text(EmployeesStrings.inactive),
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
            EmployeesStrings.quickActions,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text(EmployeesStrings.reloadEmployees),
          onTap: () {
            _loadEmployees();
            if (showBackButton) Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text(EmployeesStrings.addEmployee),
          onTap: () {
            Navigator.pop(context);
            _navigateToAddEmployeeScreen();
          },
        ),
        ListTile(
          leading: const Icon(Icons.folder_shared),
          title: const Text(EmployeesStrings.employeeFiles),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FilesEmployeePage(employeeId: 0),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text(EmployeesStrings.about),
          onTap: () {
            if (showBackButton) Navigator.pop(context);
            showAboutDialog(
              context: context,
              applicationName: EmployeesStrings.aboutAppName,
              applicationVersion: EmployeesStrings.aboutAppVersion,
              applicationIcon: const Icon(Icons.people),
              children: [const Text(EmployeesStrings.aboutAppDescription)],
            );
          },
        ),
      ],
    );
  }

  /// Construye la interfaz principal de la página de empleados
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width >= 800;
    final crossAxisCount = (width / 300).floor().clamp(1, 4);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          EmployeesStrings.title,
          style: const TextStyle(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
        ),
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
        centerTitle: true,
      ),
      drawer: isLargeScreen ? null : Drawer(child: _buildFilterOptions(true)),
      body: Row(
        children: [
          if (isLargeScreen)
            Container(
              width: 280,
              color: Colors.grey.shade100,
              child: _buildFilterOptions(false),
            ),
          Expanded(
            child: Stack(
              children: [
                _filteredEmployees.isEmpty
                    ? const Center(
                      child: Text(
                        EmployeesStrings.noEmployees,
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

  /// Construye la tarjeta visual para cada empleado
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
                    employee.activo
                        ? EmployeesStrings.activeLabel
                        : EmployeesStrings.inactiveLabel,
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
                  label: const Text(
                    EmployeesStrings.optionsButton,
                    style: TextStyle(fontSize: 13),
                  ),
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
