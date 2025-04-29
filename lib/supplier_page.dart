// lib/suppliers_page.dart
import 'package:flutter/material.dart';
import 'package:myapp/add_supplier_screen_page.dart';
import 'package:myapp/models/supplier.dart';
import 'package:myapp/services/suppliers_service.dart'; // Make sure to create this service

class SuppliersPage extends StatefulWidget {
  @override
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  List<Supplier> _suppliers = [];
  final SupplierService _supplierService = SupplierService(); // Make sure to create this service

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    // Simulation of loading suppliers (replace with your actual logic using the service)
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _suppliers = _supplierService.getAllSuppliers(); // Make sure getAllSuppliers() returns the list
    });
  }

  void _navigateToAddSupplierScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSupplierScreen()),
    ).then((newSupplier) {
      if (newSupplier is Supplier) {
        setState(() {
          _suppliers.add(newSupplier);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newSupplier.name} added successfully!')),
          );
        });
        // Here you should call the service to save the new supplier
        // _supplierService.addSupplier(newSupplier);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        backgroundColor: const Color.fromARGB(255, 210, 25, 25),
      ),
      body: _suppliers.isEmpty
          ? const Center(
              child: Text(
                'No suppliers registered.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _suppliers.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final supplier = _suppliers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        if (supplier.taxId != null && supplier.taxId!.isNotEmpty)
                          Text('Tax ID: ${supplier.taxId}', style: TextStyle(color: Colors.grey.shade600)),
                        if (supplier.contactPerson != null && supplier.contactPerson!.isNotEmpty)
                          Text('Contact: ${supplier.contactPerson}', style: TextStyle(color: Colors.grey.shade600)),
                        if (supplier.phone != null && supplier.phone!.isNotEmpty)
                          Text('Phone: ${supplier.phone}', style: TextStyle(color: Colors.grey.shade600)),
                        if (supplier.email != null && supplier.email!.isNotEmpty)
                          Text('Email: ${supplier.email}', style: TextStyle(color: Colors.grey.shade600)),
                        if (supplier.address != null && supplier.address!.isNotEmpty)
                          Text('Address: ${supplier.address}', style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSupplierScreen,
        backgroundColor: Colors.green.shade400,
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 4,
      ),
    );
  }
}