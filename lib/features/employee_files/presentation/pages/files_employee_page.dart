import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee_files/domain/entities/employee_file.dart';
import 'package:nexuserp/features/employee_files/data/repositories/employee_file_repository_impl.dart';
import 'package:nexuserp/features/employee_files/data/datasources/employee_file_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

import '../../../employee/presentation/pages/employees_page.dart';

// Definición del enum SortingOption
enum SortingOption { name, type, date }

class FilesEmployeePage extends StatefulWidget {
  final int employeeId;
  const FilesEmployeePage({Key? key, required this.employeeId})
    : super(key: key);

  @override
  State<FilesEmployeePage> createState() => _FilesEmployeePageState();
}

class _FilesEmployeePageState extends State<FilesEmployeePage> {
  late final EmployeeFileRepositoryImpl _repository;
  late final EmployeeFileService _service;
  List<EmployeeFile> _files = [];
  List<EmployeeFile> _filteredFiles = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  String? _selectedFileType;
  DateTimeRange? _selectedDateRange;

  // --- Paginación ---
  final int _itemsPerPage = 10;
  int _currentPage = 0;

  // --- Ordenamiento ---
  SortingOption _currentSorting = SortingOption.name;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _service = EmployeeFileService();
    _repository = EmployeeFileRepositoryImpl(_service);
    _loadFiles();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
        _applyFilters();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFiles() async {
    final List<EmployeeFile> files = [];
    final storageList =
        await _service.supabase.storage.from('empleados').list();
    for (final item in storageList) {
      DateTime uploadDate = DateTime.now();
      if (item.createdAt != null &&
          item.createdAt is String &&
          (item.createdAt as String).isNotEmpty) {
        try {
          uploadDate = DateTime.parse(item.createdAt as String);
        } catch (_) {}
      }
      files.add(
        EmployeeFile(
          id: null,
          employeeId: 0,
          fileType: item.name.split('.').last.toLowerCase(),
          fileName: item.name,
          filePath: _service.supabase.storage
              .from('empleados')
              .getPublicUrl(item.name),
          uploadDate: uploadDate,
          notes: '',
        ),
      );
    }
    setState(() {
      _files = files;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<EmployeeFile> temp = _files;

    // Filtrado por búsqueda
    if (_searchQuery.isNotEmpty) {
      temp =
          temp
              .where(
                (f) =>
                    f.fileName.toLowerCase().contains(_searchQuery) ||
                    f.fileType.toLowerCase().contains(_searchQuery) ||
                    f.filePath.toLowerCase().contains(_searchQuery),
              )
              .toList();
    }

    // Filtrado por tipo de archivo
    if (_selectedFileType != null && _selectedFileType != 'Todos') {
      temp = temp.where((f) => f.fileType == _selectedFileType).toList();
    }

    // Filtrado por rango de fechas
    if (_selectedDateRange != null) {
      temp =
          temp
              .where(
                (f) =>
                    f.uploadDate.isAfter(
                      _selectedDateRange!.start.subtract(
                        const Duration(days: 1),
                      ),
                    ) &&
                    f.uploadDate.isBefore(
                      _selectedDateRange!.end.add(const Duration(days: 1)),
                    ),
              )
              .toList();
    }

    _filteredFiles = temp;
    _currentPage = 0; // Resetear la página al aplicar filtros
    _applySorting();
  }

  Future<void> _deleteFile(int? fileId) async {
    if (fileId != null) {
      // Como estamos listando directamente desde Storage, la lógica de eliminación podría ser diferente.
      // Necesitarías saber el nombre del archivo para eliminarlo de Storage.
      // Por ahora, solo recargamos la lista.
      print('Implementar eliminación de Storage para el ID: $fileId');
      _loadFiles();
    }
  }

  void _applySorting() {
    setState(() {
      switch (_currentSorting) {
        case SortingOption.name:
          _filteredFiles.sort(
            (a, b) =>
                _isAscending
                    ? a.fileName.compareTo(b.fileName)
                    : b.fileName.compareTo(a.fileName),
          );
          break;
        case SortingOption.type:
          _filteredFiles.sort(
            (a, b) =>
                _isAscending
                    ? a.fileType.compareTo(b.fileType)
                    : b.fileType.compareTo(a.fileType),
          );
          break;
        case SortingOption.date:
          _filteredFiles.sort(
            (a, b) =>
                _isAscending
                    ? a.uploadDate.compareTo(b.uploadDate)
                    : b.uploadDate.compareTo(a.uploadDate),
          );
          break;
      }
    });
  }

  // --- Iconos por tipo de archivo ---
  final Map<String, IconData> _fileTypeIcons = {
    'pdf': Icons.picture_as_pdf,
    'docx': Icons.description,
    'doc': Icons.description,
    'png': Icons.image,
    'jpg': Icons.image,
    'jpeg': Icons.image,
    'txt': Icons.text_snippet,
    // Añade más tipos de archivo e iconos según necesites
  };

  IconData _getFileIcon(String fileType) {
    return _fileTypeIcons[fileType.toLowerCase()] ?? Icons.insert_drive_file;
  }

  List<EmployeeFile> get _pagedFiles {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(
      0,
      _filteredFiles.length,
    );
    return _filteredFiles.sublist(startIndex, endIndex);
  }

  int get _totalPages => (_filteredFiles.length / _itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    final fileTypes = <String>{
      'Todos',
      ..._files.map((f) => f.fileType).toSet().toList(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Archivos almacenados',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmployeesPage()),
            );
          },
        ),
        actions: [
          PopupMenuButton<SortingOption>(
            onSelected: (SortingOption result) {
              setState(() {
                if (_currentSorting == result) {
                  _isAscending = !_isAscending;
                } else {
                  _currentSorting = result;
                  _isAscending = true;
                }
                _applySorting();
              });
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<SortingOption>>[
                  const PopupMenuItem<SortingOption>(
                    value: SortingOption.name,
                    child: Text(
                      'Nombre',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const PopupMenuItem<SortingOption>(
                    value: SortingOption.type,
                    child: Text(
                      'Tipo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const PopupMenuItem<SortingOption>(
                    value: SortingOption.date,
                    child: Text(
                      'Fecha de subida',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
            icon: const Icon(Icons.sort, color: Colors.white, size: 28),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, tipo o ruta...',
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue.shade700,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Filtrar por tipo',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedFileType,
                        items:
                            fileTypes
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFileType = value;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final DateTimeRange? picked =
                              await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                          if (picked != null && picked != _selectedDateRange) {
                            setState(() {
                              _selectedDateRange = picked;
                              _applyFilters();
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Filtrar por fecha',
                            border: OutlineInputBorder(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              _selectedDateRange == null
                                  ? 'Seleccionar rango'
                                  : '${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadFiles,
              child:
                  _filteredFiles.isEmpty
                      ? const Center(
                        child: Text(
                          'No hay archivos que coincidan con los filtros.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _pagedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _pagedFiles[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: Icon(
                                _getFileIcon(file.fileType),
                                color: Colors.blue.shade700,
                                size: 32,
                              ),
                              title: Text(
                                file.fileName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Tipo: ${file.fileType}\nSubido: ${DateFormat('dd/MM/yyyy').format(file.uploadDate.toLocal())}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text('Eliminar archivo'),
                                          content: const Text(
                                            '¿Estás seguro de que deseas eliminar este archivo?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text(
                                                'Eliminar',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == true) {
                                    await _deleteFile(
                                      null,
                                    ); // Necesitas la lógica correcta para eliminar por nombre/ruta
                                  }
                                },
                              ),
                              onTap: () async {
                                if (file.filePath.startsWith('http')) {
                                  await launchUrl(Uri.parse(file.filePath));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Ruta: ${file.filePath}'),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
            ),
          ),
          if (_totalPages > 1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed:
                        _currentPage > 0
                            ? () => setState(() => _currentPage--)
                            : null,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text('Página ${_currentPage + 1} de $_totalPages'),
                  IconButton(
                    onPressed:
                        _currentPage < _totalPages - 1
                            ? () => setState(() => _currentPage++)
                            : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          if (_filteredFiles.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No hay archivos almacenados.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadFiles,
        child: const Icon(Icons.refresh, size: 30, color: Colors.white),
        backgroundColor: Colors.blue.shade900,
        tooltip: 'Recargar archivos',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
