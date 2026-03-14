import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/http/http_exception.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;
  final SharedPreferences _sharedPrefs;

  static const _tokenKey = 'jwt_token';

  AuthRepositoryImpl(this._datasource, this._sharedPrefs);

  @override
  AsyncResult<String, HttpException> login(String username, String password) async {
    final result = await _datasource.login(username, password);

    if (result.isSuccess()) {
      final token = result.getOrNull()!;
      await _sharedPrefs.setString(_tokenKey, token);
      await _sharedPrefs.setString('logged_username', username);
    }

    return result;
  }

  @override
  AsyncResult<String, Exception> checkCachedAuth() async {
    final token = _sharedPrefs.getString(_tokenKey);

    if (token != null && token.isNotEmpty) {
      return Success(token);
    }

    return Failure(Exception('Usuário não logado'));
  }

  @override
  AsyncResult<Unit, Exception> logout() async {
    await _sharedPrefs.remove(_tokenKey);
    await _sharedPrefs.remove('logged_username');
    return Success(unit);
  }

  @override
  AsyncResult<Unit, HttpException> register(String username, String password) async {
    return await _datasource.register(username, password);
  }
}
