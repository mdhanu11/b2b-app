import 'package:muward_b2b/features/auth/domain/models/auth.dart';

abstract class AuthRepository {
  Future<void> saveAuthData(Auth authData);
  Future<Auth?> getAuthData();
  Future<void> clearAuthData();
  Future<bool> isUserLoggedIn();

// For login functionality (when you implement it)
// Future<Auth?> login(String email, String password);
}
