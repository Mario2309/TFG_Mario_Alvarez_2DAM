import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../domain/repositories/credential_employee_repository.dart';
import '../datasources/vacation_service.dart';
import '../models/credential_employee_model.dart';

class EmployeeCredentialRepositoryImpl implements CredentialEmployeeRepository {
  final CredentialService credentialService;

  EmployeeCredentialRepositoryImpl({required this.credentialService});

  // --- Credenciales ---

  @override
  Future<void> addCredential(EmployeeCredentialModel credential) async {
    // Hash de la contraseña antes de guardar
    final String plainPassword = credential.hashedPassword;
    final String hashedPassword = hashPassword(plainPassword);
    final model = EmployeeCredentialModel(
      employeeDni: credential.employeeDni,
      email: credential.email,
      hashedPassword: hashedPassword,
    );
    await credentialService.addCredential(model);
  }

  /// Convierte una contraseña en un hash seguro usando sha256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<EmployeeCredentialModel> getCredentialByDni(String dni) async {
    final credential = await credentialService.getCredentialByDni(dni);
    if (credential == null) {
      throw Exception('Credential not found for DNI: $dni');
    }
    return credential;
  }

  @override
  Future<void> updateCredentialEmail(String dni, String newEmail) async {
    await credentialService.updateEmail(dni, newEmail);
  }

  @override
  Future<void> updateCredentialPassword(
    String dni,
    String newHashedPassword,
  ) async {
    await credentialService.updatePassword(dni, newHashedPassword);
  }

  @override
  Future<void> deleteCredential(String dni) async {
    await credentialService.deleteCredential(dni);
  }
}
