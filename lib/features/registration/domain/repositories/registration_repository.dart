import '../entities/registration_model.dart';

abstract class RegistrationRepository {
  Future<RegistrationModel?> getCurrentRegistration();
  Future<void> saveRegistration(RegistrationModel model);
  Future<Map<String, dynamic>?> submitRegistration(RegistrationModel model);
  Future<void> clearRegistration();
}
