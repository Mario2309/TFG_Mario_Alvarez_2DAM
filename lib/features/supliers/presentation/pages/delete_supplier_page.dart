import 'package:flutter/material.dart';
import 'package:nexuserp/features/supliers/data/datasources/suppliers_service.dart';
import 'package:nexuserp/features/supliers/data/models/supplier_model.dart';
import 'package:nexuserp/features/supliers/domain/entities/supplier.dart';
import 'package:nexuserp/features/supliers/presentation/pages/supplier_page.dart';
import 'package:nexuserp/core/utils/suppliers_strings.dart';

/// Pantalla para eliminar proveedores del sistema.
class DeleteSupplierScreen extends StatefulWidget {
  @override
  _DeleteSupplierScreenState createState() => _DeleteSupplierScreenState();
}

class _DeleteSupplierScreenState extends State<DeleteSupplierScreen> {
  final SupplierService _supplierService = SupplierService();
  List<SupplierModel> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  /// Carga la lista de proveedores desde el servicio.
  Future<void> _loadSuppliers() async {
    try {
      final list = await _supplierService.getAllSuppliers();
      if (mounted) {
        setState(() {
          _suppliers = list;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${SuppliersStrings.loadError} $e')),
      );
    }
  }

  /// Muestra un diálogo de confirmación y elimina el proveedor si se acepta.
  Future<void> _deleteSupplier(Supplier supplier) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(SuppliersStrings.confirmDelete),
          content: Text(
            '${SuppliersStrings.confirmDeleteMsg} "${supplier.nombre}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(SuppliersStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _supplierService.deleteSupplier(supplier.nifCif);
                  if (mounted) {
                    setState(() {
                      _suppliers.remove(supplier);
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${supplier.nombre} ${SuppliersStrings.deletedSuccessfully}',
                      ),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SuppliersPage()),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(SuppliersStrings.deleteError)),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SuppliersPage()),
                  );
                }
              },
              child: Text(SuppliersStrings.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SuppliersStrings.deleteSuppliers),
        backgroundColor: Colors.red.shade700,
      ),
      body:
          _suppliers.isEmpty
              ? Center(child: Text(SuppliersStrings.noSuppliersToDelete))
              : ListView.builder(
                itemCount: _suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = _suppliers[index];
                  return ListTile(
                    title: Text(supplier.nombre),
                    subtitle: Text(supplier.nifCif),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteSupplier(supplier as Supplier),
                    ),
                  );
                },
              ),
    );
  }
}
