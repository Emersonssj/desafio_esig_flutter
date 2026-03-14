import 'package:result_dart/result_dart.dart';

import '../../../../core/network/http/http_exception.dart';

abstract interface class AuthDatasource {
  AsyncResult<String, HttpException> login(String username, String password);
  AsyncResult<Unit, HttpException> register(String username, String password);
}
