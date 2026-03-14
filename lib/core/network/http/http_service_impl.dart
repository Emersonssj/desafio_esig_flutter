import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import 'http_exception.dart';
import 'http_service.dart';

class HttpServiceImpl implements HttpService {
  HttpServiceImpl({required String baseUrl, List<Interceptor> interceptors = const []}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10)));

    _dio.interceptors.addAll(interceptors);
  }

  late final Dio _dio;

  @override
  AsyncResult<HttpResponse, HttpException> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpException> post(
    String path, {
    Duration? requestTimeout,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers, sendTimeout: requestTimeout, receiveTimeout: requestTimeout),
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpException> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpException> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpException> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParams,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpException> upload(
    String path,
    FormData data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  Failure<HttpResponse, HttpException> _handleHttpException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Failure(HttpException(statusCode: 408, message: 'Tempo de conexão esgotado.'));
    }

    if (e.response != null && e.response!.data != null) {
      // Pega os dados exatos do seu Spring Boot
      final status = e.response!.data['status'] ?? e.response!.statusCode ?? 500;
      final userMessage = e.response!.data['userMessage'] ?? 'Erro interno no servidor.';

      return Failure(HttpException(statusCode: status, message: userMessage));
    }

    return Failure(HttpException(statusCode: 500, message: 'Erro desconhecido.'));
  }
}
