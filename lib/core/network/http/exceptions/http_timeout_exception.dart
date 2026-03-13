import 'http_request_exception.dart';

class HttpTimeoutException extends HttpRequestException {
  HttpTimeoutException({
    required super.status,
    required super.title,
    required super.userMessage,
    super.timestamp,
    super.type,
    super.detail,
    super.objects,
  });
}
