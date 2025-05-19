import '../../domain/entities/vacation.dart';
import '../../domain/repositories/vacation_repository.dart';
import '../datasources/vacation_service.dart';
import '../models/vacation_model.dart';

class VacationRepositoryImpl implements VacationRepository {
  final VacationService service;

  VacationRepositoryImpl(this.service);

  @override
  Future<void> addVacation(Vacation v) async {
    final model = VacationModel(
      employeeDni: v.employeeDni,
      employeeName: v.employeeName,
      startDate: v.startDate,
      endDate: v.endDate,
      status: v.status,
    );
    await service.addVacation(model);
  }

  @override
  Future<void> deleteVacation(int id) async {
    await service.deleteVacation(id);
  }

  @override
  Future<List<Vacation>> getVacations() async {
    final models = await service.fetchVacations();
    return models.map(_mapModelToEntity).toList();
  }

  Future<bool> addVacationWithoutId(Vacation vacation) async {
    try {
      final model = VacationModel(
        employeeDni: vacation.employeeDni,
        employeeName: vacation.employeeName,
        startDate: vacation.startDate,
        endDate: vacation.endDate,
        status: vacation.status,
      );
      final response = await service.addVacation(model);
      return response;
    } catch (e) {
      return false;
    }
  }

  Vacation _mapModelToEntity(VacationModel m) {
    return Vacation(
      id: m.id,
      employeeDni: m.employeeDni,
      employeeName: m.employeeName,
      startDate: m.startDate,
      endDate: m.endDate,
      status: m.status,
    );
  }

  @override
  Future<void> updateVacation(Vacation vacation) async {
    final model = VacationModel(
      id: vacation.id,
      employeeDni: vacation.employeeDni,
      employeeName: vacation.employeeName,
      startDate: vacation.startDate,
      endDate: vacation.endDate,
      status: vacation.status,
    );
    await service.updateVacation(model);
  }
  
  @override
  Future<void> updateVacationStatus(int id, String newStatus) {
    // TODO: implement updateVacationStatus
    throw UnimplementedError();
  }
}
