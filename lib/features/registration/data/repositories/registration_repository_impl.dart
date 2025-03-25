import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/registration_model.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_api_datasource.dart';
import '../datasources/registration_local_datasource.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationLocalDatasource _localDatasource;
  final RegistrationApiDatasource _apiDatasource;

  RegistrationRepositoryImpl(this._localDatasource, this._apiDatasource);

  @override
  Future<RegistrationModel?> getCurrentRegistration() async {
    return await _localDatasource.getRegistrationData();
  }

  @override
  Future<void> saveRegistration(RegistrationModel model) async {
    await _localDatasource.saveRegistrationData(model);
  }

  @override
  Future<Map<String, dynamic>?> submitRegistration(
      RegistrationModel model) async {
    try {
      final response = await _apiDatasource.submitRegistration(model);
      if (response != null && response['success'] == true) {
        await clearRegistration();
      }
      return response;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearRegistration() async {
    await _localDatasource.clearRegistrationData();
  }
}
