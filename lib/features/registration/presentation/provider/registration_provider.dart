import 'package:flutter/foundation.dart';

import '../../../../core/auth/providers/auth_provider.dart';
import '../../domain/entities/registration_model.dart';
import '../../domain/repositories/registration_repository.dart';

class RegistrationProvider extends ChangeNotifier {
  final RegistrationRepository _repository;
  final AuthProvider _authProvider;
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? lastApiResponse;

  // Default values for the registration model
  RegistrationModel _currentModel = RegistrationModel(
    email: '',
    phoneNumber: '',
    name: '',
    company: '',
    crNumber: '',
    nationalId: '',
    dob: '',
    address: AddressModel(
      googleAddress: '',
      city: '',
      state: '',
      country: '',
    ),
  );

  RegistrationModel get currentModel => _currentModel;

  RegistrationProvider(this._repository, this._authProvider) {
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    isLoading = true;
    notifyListeners();

    try {
      final existingData = await _repository.getCurrentRegistration();
      if (existingData != null) {
        _currentModel = existingData;
      }
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> savePersonalDetails({
    required String name,
    required String phoneNumber,
    required String countryCode,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final updatedModel = _currentModel.copyWith(
        name: name,
        phoneNumber: "$countryCode$phoneNumber",
      );

      _currentModel = updatedModel;
      await _repository.saveRegistration(updatedModel);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveLocationDetails({
    required String googleAddress,
    required String city,
    required String state,
    required String country,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final address = AddressModel(
        googleAddress: googleAddress,
        city: city,
        state: state,
        country: country,
      );

      final updatedModel = _currentModel.copyWith(address: address);
      _currentModel = updatedModel;
      await _repository.saveRegistration(updatedModel);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveBusinessDetails({
    required String email,
    required String company,
    required String crNumber,
    required String nationalId,
    required String dob,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final updatedModel = _currentModel.copyWith(
        email: email,
        company: company,
        crNumber: crNumber,
        nationalId: nationalId,
        dob: dob,
      );

      _currentModel = updatedModel;
      await _repository.saveRegistration(updatedModel);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitRegistration() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _repository.submitRegistration(_currentModel);
      // Store the API response for later use
      lastApiResponse = response;

      // If the submission was successful, save auth data
      if (response != null &&
          response['success'] == true &&
          response['data'] != null) {
        await _authProvider.saveAuthData(response);
        return true;
      }

      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
