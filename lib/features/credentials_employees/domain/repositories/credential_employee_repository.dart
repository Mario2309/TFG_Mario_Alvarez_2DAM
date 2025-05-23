import '../../data/models/credential_employee_model.dart';
import '../entities/credential_employess.dart';

abstract class CredentialEmployeeRepository {
  Future<void> addCredential(EmployeeCredentialModel credential);
  Future<EmployeeCredentialModel> getCredentialByDni(String employeeDni);
  Future<void> updateCredentialEmail(String employeeDni, String newEmail);
  Future<void> updateCredentialPassword(
    String employeeDni,
    String newHashedPassword,
  );
}
