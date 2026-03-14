import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class CreatePostUseCase {
  final FeedRepository _repository;

  CreatePostUseCase(this._repository);

  AsyncResult<PostEntity, HttpException> call({
    required String username,
    required String description,
    String? imagePath,
  }) {
    if (description.isEmpty) {
      return AsyncResult.error(Exception('A descrição não pode ser vazia.'));
    }
    return _repository.createPost(username, description, imagePath);
  }
}
