import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_service.dart';
import 'auth_datasource.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final HttpService _httpService;

  AuthDatasourceImpl(this._httpService);

  @override
  AsyncResult<String> login(String username, String password) async {
    final response = await _httpService.post('/auth/login', data: {'login': username, 'password': password});

    // Mapeia a resposta de Sucesso para pegar apenas o Token
    return response.map((res) {
      final data = res.content as Map<String, dynamic>;
      return data['token'] as String;
    });
  }
}
