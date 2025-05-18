import 'package:flutter/material.dart';
import 'package:nexuserp/features/supliers/data/models/supplier_model.dart';
import 'package:nexuserp/features/supliers/data/datasources/suppliers_service.dart';
import 'package:nexuserp/features/supliers/data/repositories/supplier_repository_impl.dart';
import 'package:nexuserp/features/supliers/presentation/pages/add_supplier_screen_page.dart';
import 'package:nexuserp/features/supliers/presentation/pages/delete_supplier_page.dart';
import 'package:nexuserp/features/supliers/presentation/pages/edit_supplier_screen.dart';

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

  Future<void> _loadSuppliers() async {
    setState(() => _isLoading = true);
    try {
      final suppliers = await _supplierRepository.getAllSuppliers();
      setState(() => _suppliers = suppliers);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar proveedores: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
              content: Text('${newSupplier.nombre} agregado correctamente.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al agregar proveedor.')),
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
              tooltip: 'Eliminar proveedores',
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
              backgroundColor: Colors.green.shade400,
              tooltip: 'Agregar proveedor',
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
              tooltip: 'Refrescar',
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Proveedores'),
      backgroundColor: Colors.orange.shade700,
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBody() {
    if (_suppliers.isEmpty) {
      return const Center(
        child: Text(
          'No hay proveedores registrados.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _suppliers.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) => _buildSupplierCard(_suppliers[index]),
    );
  }

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
              Icon(
                Icons.local_shipping,
                size: 32,
                color: Colors.orange.shade400,
              ),
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
                    if (supplier.nifCif?.isNotEmpty ?? false)
                      _infoLine('NIF/CIF: ${supplier.nifCif}'),
                    if (supplier.personaContacto?.isNotEmpty ?? false)
                      _infoLine('Contacto: ${supplier.personaContacto}'),
                    if (supplier.telefono?.isNotEmpty ?? false)
                      _infoLine('Teléfono: ${supplier.telefono}'),
                    if (supplier.correoElectronico?.isNotEmpty ?? false)
                      _infoLine('Correo: ${supplier.correoElectronico}'),
                    if (supplier.direccion?.isNotEmpty ?? false)
                      _infoLine('Dirección: ${supplier.direccion}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoLine(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
    );
  }
}
