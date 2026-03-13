import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

abstract class HttpService {
  AsyncResult<HttpResponse> get(String path, {Map<String, dynamic>? headers, Map<String, dynamic>? queryParams});

  AsyncResult<HttpResponse> post(
    String path, {
    Duration? requestTimeout,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    void Function(int, int)? onReceiveProgress,
  });

  AsyncResult<HttpResponse> upload(
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
