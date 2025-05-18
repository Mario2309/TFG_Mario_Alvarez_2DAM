// lib/models/supplier.dart
class SupplierModel {
  int? id;
  String nombre;
  String nifCif;
  String personaContacto;
  String telefono;
  String correoElectronico;
  String? direccion;

  SupplierModel({
    this.id,
    required this.nombre,
    required this.nifCif,
    required this.personaContacto,
    required this.telefono,
    required this.correoElectronico,
    this.direccion,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'],
      nombre: json['nombre'],
      nifCif: json['nif_cif'],
      personaContacto: json['persona_contacto'],
      telefono: json['telefono'],
      correoElectronico: json['correo_electronico'],
      direccion: json['direccion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'nif_cif': nifCif,
      'persona_contacto': personaContacto,
      'telefono': telefono,
      'correo_electronico': correoElectronico,
      'direccion': direccion,
    };
  }
}
