import '../../domain/models/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({required this.localDatasource});

  @override
  Future<void> saveAuthData(Auth authData) async {
    await localDatasource.cacheAuthData(authData);
  }

  @override
  Future<Auth?> getAuthData() async {
    try {
      return await localDatasource.getLastAuthData();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    await localDatasource.clearAuthData();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await localDatasource.isUserLoggedIn();
  }
}
