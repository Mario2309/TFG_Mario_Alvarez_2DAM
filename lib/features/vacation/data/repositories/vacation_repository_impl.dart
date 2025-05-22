import '../../domain/entities/vacation.dart';
import '../../domain/repositories/vacation_repository.dart';
import '../datasources/vacation_service.dart';
import '../models/vacation_model.dart';

class VacationRepositoryImpl implements VacationRepository {
  final VacationService service;

  VacationRepositoryImpl(this.service);

  @override
  Future<void> addVacation(Vacation vacation) async {
    final model = VacationModel(
      employeeDni: vacation.employeeDni,
      employeeName: vacation.employeeName,
      startDate: vacation.startDate,
      endDate: vacation.endDate,
      status: vacation.status,
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

  @override
  Future<List<Vacation>> getAllVacations() async {
    final models = await service.fetchVacations();
    return models.map(_mapModelToEntity).toList();
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
  Future<void> updateVacationStatus(int id, String newStatus) async {
    await service.updateVacationStatus(id, newStatus);
  }

  Vacation _mapModelToEntity(VacationModel model) {
    return Vacation(
      id: model.id,
      employeeDni: model.employeeDni,
      employeeName: model.employeeName,
      startDate: model.startDate,
      endDate: model.endDate,
      status: model.status,
    );
  }
}
