import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _sharedPreferences;

  AuthInterceptor(this._sharedPreferences);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Busca o token salvo localmente
    final token = _sharedPreferences.getString('jwt_token');

    // Se o token existir, injeta no cabeçalho Authorization
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continua a requisição normalmente
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Opcional: Aqui você pode tratar erros de Token Expirado (Status 401 ou 403)
    // para forçar o usuário a ir para a tela de login.
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Limpar token e redirecionar (pode usar um event bus ou callback global)
      _sharedPreferences.remove('jwt_token');
    }

    super.onError(err, handler);
  }
}
