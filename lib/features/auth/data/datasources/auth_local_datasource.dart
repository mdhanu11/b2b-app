import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../domain/models/auth.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheAuthData(Auth authData);
  Future<Auth?> getLastAuthData();
  Future<void> clearAuthData();
  Future<bool> isUserLoggedIn();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  @override
  Future<void> cacheAuthData(Auth authData) async {
    final jsonString = jsonEncode(authData.toJson());
    await SharedPrefsHelper.setString(AppConstants.authDataKey, jsonString);
    await SharedPrefsHelper.setBool(AppConstants.isLoggedInKey, true);
  }

  @override
  Future<Auth?> getLastAuthData() async {
    final jsonString =
        await SharedPrefsHelper.getString(AppConstants.authDataKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return Auth.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    await SharedPrefsHelper.remove(AppConstants.authDataKey);
    await SharedPrefsHelper.setBool(AppConstants.isLoggedInKey, false);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return SharedPrefsHelper.getBool(AppConstants.isLoggedInKey) ?? false;
  }
}
