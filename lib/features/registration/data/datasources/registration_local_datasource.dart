import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/registration_model.dart';

class RegistrationLocalDatasource {
  final SharedPreferences _prefs;

  RegistrationLocalDatasource(this._prefs);

  Future<RegistrationModel?> getRegistrationData() async {
    final dataJson = _prefs.getString('registration_data');
    if (dataJson == null) return null;

    try {
      final Map<String, dynamic> data = json.decode(dataJson);

      // Build address model
      final addressData = data['address'] as Map<String, dynamic>;
      final address = AddressModel(
        googleAddress: addressData['google_address'] ?? '',
        city: addressData['city'] ?? '',
        state: addressData['state'] ?? '',
        country: addressData['country'] ?? '',
      );

      return RegistrationModel(
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        name: data['name'] ?? '',
        company: data['company'] ?? '',
        crNumber: data['crNumber'] ?? '',
        nationalId: data['nationalId'] ?? '',
        dob: data['dob'] ?? '',
        address: address,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> saveRegistrationData(RegistrationModel model) async {
    final dataJson = json.encode(model.toJson());
    await _prefs.setString('registration_data', dataJson);
  }

  Future<void> clearRegistrationData() async {
    await _prefs.remove('registration_data');
  }
}
