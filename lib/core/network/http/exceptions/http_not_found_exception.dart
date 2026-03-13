import 'http_request_exception.dart';

class HttpNotFoundException extends HttpRequestException {
  HttpNotFoundException({
    required super.status,
    required super.title,
    required super.userMessage,
    super.timestamp,
    super.type,
    super.detail,
    super.objects,
  });
}
