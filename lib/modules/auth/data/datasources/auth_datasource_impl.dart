import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../../../../core/network/http/http_service.dart';
import 'auth_datasource.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final HttpService _httpService;

  AuthDatasourceImpl(this._httpService);

  @override
  AsyncResult<String, HttpException> login(String username, String password) async {
    final result = await _httpService.post('/auth/login', data: {'login': username, 'password': password});

    return result.flatMap((success) {
      final data = success.content as Map<String, dynamic>;
      return Success(data['token']);
    });
  }

  @override
  AsyncResult<Unit, HttpException> register(String username, String password) async {
    final response = await _httpService.post('/auth/register', data: {'login': username, 'password': password});
    return response.map((_) => unit);
  }
}
