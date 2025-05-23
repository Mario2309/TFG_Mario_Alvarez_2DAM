class EmployeeCredential {
  final String employeeDni;
  final String email;
  final String hashedPassword;

  EmployeeCredential({
    required this.employeeDni,
    required this.email,
    required this.hashedPassword,
  });
}
