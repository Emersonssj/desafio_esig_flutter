import 'package:result_dart/result_dart.dart';

abstract class AuthRepository {
  AsyncResult<String> login(String username, String password);
  AsyncResult<String> checkCachedAuth();
  AsyncResult<Unit> logout();
}
