import 'http_request_exception.dart';

class HttpUnhandledException extends HttpRequestException {
  HttpUnhandledException({
    required super.status,
    required super.title,
    required super.userMessage,
    super.timestamp,
    super.type,
    super.detail,
    super.objects,
  });

  factory HttpUnhandledException.unknown() {
    return HttpUnhandledException(status: 0, title: '', userMessage: 'unexpected_error');
  }
}
