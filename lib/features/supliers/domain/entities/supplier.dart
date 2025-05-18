class Supplier {
  int? id;
  String nombre;
  String nifCif;
  String personaContacto;
  String telefono;
  String correoElectronico;
  String? direccion;

  Supplier({
    this.id,
    required this.nombre,
    required this.nifCif,
    required this.personaContacto,
    required this.telefono,
    required this.correoElectronico,
    this.direccion,
  });
}
