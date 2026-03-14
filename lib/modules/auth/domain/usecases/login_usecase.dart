import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  AsyncResult<String, HttpException> call(String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      return AsyncResult.error(Exception('Usuário e senha são obrigatórios.'));
    }
    return _repository.login(username, password);
  }
}
