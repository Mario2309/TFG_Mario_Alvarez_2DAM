// lib/services/supplier_service.dart
import 'package:nexuserp/features/supliers/domain/entities/supplier.dart';

class SupplierService {
  // In-memory data simulation (replace with your database logic)
  final List<Supplier> _suppliers = [
    Supplier(id: 1, name: 'Supplier A', taxId: 'A1234567', contactPerson: 'John Doe', phone: '123456789', email: 'john@suppliera.com', address: 'Fake Street 123'),
    Supplier(id: 2, name: 'Supplier B', taxId: 'B9876543', contactPerson: 'Jane Smith', phone: '987654321', email: 'jane@supplierb.com', address: 'Made Up Avenue 456'),
  ];

  List<Supplier> getAllSuppliers() {
    return _suppliers;
  }

  void addSupplier(Supplier supplier) {
    supplier.id = _suppliers.length + 1; // Simulate ID
    _suppliers.add(supplier);
    print('Supplier added: ${supplier.name}');
  }

  // You can add more methods like getSupplierById, updateSupplier, deleteSupplier, etc.
}