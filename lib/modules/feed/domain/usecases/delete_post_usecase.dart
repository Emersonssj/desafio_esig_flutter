import 'package:result_dart/result_dart.dart';
import '../repositories/feed_repository.dart';

class DeletePostUsecase {
  final FeedRepository _repository;

  DeletePostUsecase(this._repository);

  AsyncResult<Unit> call(int id) {
    return _repository.deletePost(id);
  }
}
