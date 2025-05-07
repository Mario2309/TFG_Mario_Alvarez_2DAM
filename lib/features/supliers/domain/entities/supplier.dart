// lib/models/supplier.dart
class Supplier {
  int? id;
  String name;
  String? taxId; // Corresponds to nif_cif
  String? contactPerson;
  String? phone;
  String? email;
  String? address;

  Supplier({
    this.id,
    required this.name,
    this.taxId,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
  });
}