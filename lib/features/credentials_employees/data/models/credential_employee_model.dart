class EmployeeCredentialModel {
  final String employeeDni;
  final String email;
  final String hashedPassword;

  EmployeeCredentialModel({
    required this.employeeDni,
    required this.email,
    required this.hashedPassword,
  });

  factory EmployeeCredentialModel.fromJson(Map<String, dynamic> json) {
    return EmployeeCredentialModel(
      employeeDni: json['empleado_dni'],
      email: json['correo_electronico'],
      hashedPassword: json['contrasena_hashed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empleado_dni': employeeDni,
      'correo_electronico': email,
      'contrasena_hashed': hashedPassword,
    };
  }
}
