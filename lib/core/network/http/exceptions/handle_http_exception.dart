import 'http_exceptions.dart';

HttpRequestException handleHttpException({
  required int status,
  required DateTime timestamp,
  required String title,
  required String userMessage,
  String? type,
  String? detail,
  ObjectErrors? objects,
}) {
  switch (status) {
    case 400:
      return HttpBadRequestException(
        title: title,
        userMessage: userMessage,
        timestamp: timestamp,
        type: type,
        detail: detail,
        objects: objects,
        status: status,
      );
    case 401:
      return HttpUnauthorizedException(
        title: title,
        userMessage: userMessage,
        timestamp: timestamp,
        type: type,
        detail: detail,
        objects: objects,
        status: status,
      );
    case 404:
      return HttpNotFoundException(
        title: title,
        userMessage: userMessage,
        timestamp: timestamp,
        type: type,
        detail: detail,
        objects: objects,
        status: status,
      );
    case 408:
      return HttpTimeoutException(
        title: title,
        userMessage: userMessage,
        timestamp: timestamp,
        type: type,
        detail: detail,
        objects: objects,
        status: status,
      );
    case 500:
      return HttpInternalException(
        title: title,
        userMessage: userMessage,
        timestamp: timestamp,
        type: type,
        detail: detail,
        objects: objects,
        status: status,
      );
    default:
      return HttpUnhandledException(
        title: title,
        userMessage: userMessage,
        timestamp: DateTime.now(),
        type: type,
        detail: detail,
        objects: objects,
        status: status,
      );
  }
}
