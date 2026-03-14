import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class UpdatePostUsecase {
  final FeedRepository _repository;

  UpdatePostUsecase(this._repository);

  Future<Result<PostEntity, HttpException>> call({
    required int id,
    required String username,
    required String description,
    String? imagePath, // <-- PARÂMETRO ADICIONADO AQUI
  }) {
    // Repassa para o repositório
    return _repository.updatePost(id, username, description, imagePath);
  }
}
