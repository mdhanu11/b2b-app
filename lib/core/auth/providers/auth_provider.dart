// lib/core/auth/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:muward_b2b/features/auth/domain/models/auth.dart';
import '../../../features/auth/domain/models/user.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  bool _isLoggedIn = false;
  bool _isLoading = true;
  Auth? _authData;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  Auth? get authData => _authData;
  User? get user => _authData?.user;
  String? get token => _authData?.token;
  String? get error => _error;

  AuthProvider(this._repository) {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = await _repository.isUserLoggedIn();
      if (_isLoggedIn) {
        _authData = await _repository.getAuthData();
        // If we have isLoggedIn as true but no auth data, something is wrong
        if (_authData == null) {
          _isLoggedIn = false;
          await _repository.clearAuthData();
        }
      }
    } catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveAuthData(Map<String, dynamic> responseData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authData = Auth.fromJson(responseData['data']);
      await _repository.saveAuthData(authData);
      _authData = authData;
      _isLoggedIn = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.clearAuthData();
      _isLoggedIn = false;
      _authData = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
