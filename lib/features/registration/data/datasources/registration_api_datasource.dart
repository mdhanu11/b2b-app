import 'package:muward_b2b/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/registration_model.dart';

class RegistrationApiDatasource {
  final APIClient _apiClient;
  static const ApiType apiType = ApiType.talabat;

  RegistrationApiDatasource(this._apiClient);

  Future<Map<String, dynamic>?> submitRegistration(
      RegistrationModel model) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: model.toJson(),
        apiType: apiType,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      // Log error
      return null;
    }
  }
}
