import 'package:result_dart/result_dart.dart';

abstract interface class AuthDatasource {
  AsyncResult<String> login(String username, String password);
}
