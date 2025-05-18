import 'package:flutter/material.dart';
import 'package:nexuserp/features/supliers/data/datasources/suppliers_service.dart';
import 'package:nexuserp/features/supliers/data/models/supplier_model.dart';
import 'package:nexuserp/features/supliers/domain/entities/supplier.dart';
import 'package:nexuserp/features/supliers/presentation/pages/supplier_page.dart';

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
        SnackBar(content: Text('Error al cargar los proveedores: $e')),
      );
    }
  }

  Future<void> _deleteSupplier(Supplier supplier) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text(
            '¿Estás seguro de que deseas eliminar "${supplier.nombre}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar diálogo
                try {
                  await _supplierService.deleteSupplier(supplier.nifCif);
                  if (mounted) {
                    setState(() {
                      _suppliers.remove(supplier);
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${supplier.nombre} eliminado.')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SuppliersPage()),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar el proveedor.')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SuppliersPage()),
                  );
                }
              },
              child: const Text('Eliminar'),
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
        title: Text('Eliminar proveedores'),
        backgroundColor: Colors.red.shade700,
      ),
      body:
          _suppliers.isEmpty
              ? Center(child: Text('No hay proveedores para eliminar.'))
              : ListView.builder(
                itemCount: _suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = _suppliers[index];
                  return ListTile(
                    title: Text(supplier.nombre),
                    subtitle: Text(supplier.nifCif ?? 'Sin NIF/CIF'),
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
