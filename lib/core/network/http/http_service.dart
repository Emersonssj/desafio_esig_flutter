import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import 'http_exception.dart';

abstract class HttpService {
  AsyncResult<HttpResponse, HttpException> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse, HttpException> post(
    String path, {
    Duration? requestTimeout,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse, HttpException> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse, HttpException> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse, HttpException> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    void Function(int, int)? onReceiveProgress,
  });

  AsyncResult<HttpResponse, HttpException> upload(
    String path,
    FormData data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });
}

class HttpResponse {
  HttpResponse(this.content);
  final dynamic content;
}
