import 'package:result_dart/result_dart.dart';

import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  AsyncResult<Unit, Exception> call() {
    return _repository.logout();
  }
}
