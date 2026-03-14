import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../repositories/feed_repository.dart';

class DeletePostUsecase {
  final FeedRepository _repository;

  DeletePostUsecase(this._repository);

  AsyncResult<Unit, HttpException> call(int id) {
    return _repository.deletePost(id);
  }
}
