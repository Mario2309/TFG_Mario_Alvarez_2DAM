import 'package:flutter/material.dart';
import 'package:nexuserp/features/supliers/data/models/supplier_model.dart';
import 'package:nexuserp/features/supliers/data/datasources/suppliers_service.dart';
import 'package:nexuserp/features/supliers/data/repositories/supplier_repository_impl.dart';
import 'package:nexuserp/features/supliers/presentation/pages/add_supplier_screen_page.dart';
import 'package:nexuserp/features/supliers/presentation/pages/delete_supplier_page.dart';
import 'package:nexuserp/features/supliers/presentation/pages/edit_supplier_screen.dart';
import 'package:nexuserp/core/utils/suppliers_strings.dart';

/// Página principal para la gestión de proveedores.
class SuppliersPage extends StatefulWidget {
  const SuppliersPage({Key? key}) : super(key: key);

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final SupplierRepositoryImpl _supplierRepository = SupplierRepositoryImpl(
    SupplierService(),
  );

  List<SupplierModel> _suppliers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  /// Carga la lista de proveedores desde el repositorio.
  Future<void> _loadSuppliers() async {
    setState(() => _isLoading = true);
    try {
      final suppliers = await _supplierRepository.getAllSuppliers();
      setState(() => _suppliers = suppliers);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${SuppliersStrings.loadError} $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Navega a la pantalla para agregar un nuevo proveedor.
  void _navigateToAddSupplierScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSupplierScreen()),
    ).then((newSupplier) async {
      if (newSupplier is SupplierModel) {
        final success = await _supplierRepository.addSupplierWithoutId(
          newSupplier,
        );
        if (success) {
          setState(() => _suppliers.add(newSupplier));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${newSupplier.nombre} ${SuppliersStrings.supplierAdded}',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(SuppliersStrings.addError)),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoading() : _buildBody(),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 90,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'deleteSupplier',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DeleteSupplierScreen()),
                ).then((_) => _loadSuppliers());
              },
              backgroundColor: Colors.red.shade400,
              tooltip: SuppliersStrings.deleteSuppliers,
              child: const Icon(Icons.delete),
              mini: true,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'addSupplier',
              onPressed: _navigateToAddSupplierScreen,
              backgroundColor: Colors.blue.shade700,
              tooltip: SuppliersStrings.addSupplier,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 32,
            child: FloatingActionButton(
              heroTag: 'refreshSuppliers',
              onPressed: _loadSuppliers,
              backgroundColor: Colors.blue.shade700,
              tooltip: SuppliersStrings.refresh,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la barra de la aplicación.
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(SuppliersStrings.title),
      backgroundColor: Colors.blue.shade700,
    );
  }

  /// Muestra un indicador de carga mientras se obtienen los proveedores.
  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Construye el cuerpo principal de la página con la lista de proveedores.
  Widget _buildBody() {
    if (_suppliers.isEmpty) {
      return Center(
        child: Text(
          SuppliersStrings.noSuppliers,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _suppliers.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) => _buildSupplierCard(_suppliers[index]),
    );
  }

  /// Construye la tarjeta visual para un proveedor.
  Widget _buildSupplierCard(SupplierModel supplier) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => EditSupplierPage(
                  supplier: supplier,
                  supplierService: SupplierService(),
                ),
          ),
        );
        if (result == true) {
          _loadSuppliers();
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.local_shipping, size: 32, color: Colors.blue.shade700),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (supplier.nifCif.isNotEmpty)
                      _infoLine(
                        '${SuppliersStrings.nifCif}: ${supplier.nifCif}',
                      ),
                    if (supplier.personaContacto.isNotEmpty)
                      _infoLine(
                        '${SuppliersStrings.contact}: ${supplier.personaContacto}',
                      ),
                    if (supplier.telefono.isNotEmpty)
                      _infoLine(
                        '${SuppliersStrings.phone}: ${supplier.telefono}',
                      ),
                    if (supplier.correoElectronico.isNotEmpty)
                      _infoLine(
                        '${SuppliersStrings.email}: ${supplier.correoElectronico}',
                      ),
                    if (supplier.direccion?.isNotEmpty ?? false)
                      _infoLine(
                        '${SuppliersStrings.address}: ${supplier.direccion}',
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye una línea de información para la tarjeta de proveedor.
  Widget _infoLine(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
    );
  }
}
