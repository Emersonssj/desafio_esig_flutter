import 'package:result_dart/result_dart.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase {
  final AuthRepository _repository;

  CheckAuthUseCase(this._repository);

  AsyncResult<String> call() => _repository.checkCachedAuth();
}
