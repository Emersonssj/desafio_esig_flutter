import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  AsyncResult<Unit, HttpException> call(String username, String password) {
    if (username.length > 32) {
      return AsyncResult.error(Exception('O usuário não pode ter mais de 32 caracteres.'));
    }
    return _repository.register(username, password);
  }
}
