import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee_files/domain/entities/employee_file.dart';
import 'package:nexuserp/features/employee_files/data/repositories/employee_file_repository_impl.dart';
import 'package:nexuserp/features/employee_files/data/datasources/employee_file_service.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    _service = EmployeeFileService();
    _repository = EmployeeFileRepositoryImpl(_service);
    _loadFiles();
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

  Future<void> _loadFiles() async {
    // Obtener la lista de archivos directamente desde Supabase Storage
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
          id: null, // No hay id en Storage
          employeeId: 0, // No hay relación directa, puedes dejarlo en 0 o null
          fileType: item.name.split('.').last,
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
      _applyFilter();
    });
  }

  void _applyFilter() {
    List<EmployeeFile> temp = _files;
    if (_searchQuery.isNotEmpty) {
      temp =
          temp
              .where(
                (f) =>
                    f.fileName.toLowerCase().contains(_searchQuery) ||
                    (f.fileType.toLowerCase().contains(_searchQuery)) ||
                    (f.filePath.toLowerCase().contains(_searchQuery)),
              )
              .toList();
    }
    _filteredFiles = temp;
  }

  Future<void> _deleteFile(int fileId) async {
    await _repository.deleteFile(fileId);
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Archivos almacenados',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                ),
                filled: true,
                fillColor: Colors.blue.shade50.withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadFiles,
              child:
                  _filteredFiles.isEmpty
                      ? const Center(
                        child: Text(
                          'No hay archivos almacenados.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredFiles.length,
                        itemBuilder: (context, index) {
                          final file = _filteredFiles[index];
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
                                Icons.insert_drive_file,
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
                                'Tipo: ${file.fileType}\nSubido: ${file.uploadDate.toLocal().toString().split(' ')[0]}',
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
                                    await _deleteFile(file.id!);
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadFiles,
        child: const Icon(Icons.refresh, size: 28),
        backgroundColor: Colors.blue.shade700,
        tooltip: 'Recargar archivos',
      ),
    );
  }
}
