import 'package:result_dart/result_dart.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class UpdatePostUsecase {
  final FeedRepository _repository;

  UpdatePostUsecase(this._repository);

  AsyncResult<PostEntity> call({
    required int id,
    required String username,
    required String description,
    String? imagePath,
  }) {
    if (description.isEmpty) {
      return AsyncResult.error(Exception('A descrição não pode ser vazia.'));
    }
    return _repository.updatePost(id, username, description, imagePath);
  }
}
