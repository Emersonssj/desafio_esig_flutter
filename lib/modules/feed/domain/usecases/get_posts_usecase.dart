import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class GetPostsUseCase {
  final FeedRepository _repository;

  GetPostsUseCase(this._repository);

  AsyncResult<List<PostEntity>, HttpException> call(int page) {
    return _repository.getPosts(page);
  }
}
