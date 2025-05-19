import '../../domain/entities/vacation.dart';

abstract class VacationRepository {
  Future<void> addVacation(Vacation vacation);

  Future<List<Vacation>> getVacations();

  Future<void> updateVacationStatus(int id, String newStatus);
}
