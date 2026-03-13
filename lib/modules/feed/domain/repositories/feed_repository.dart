import 'package:result_dart/result_dart.dart';
import '../entities/post_entity.dart';

abstract interface class FeedRepository {
  AsyncResult<List<PostEntity>> getPosts(int page);
  AsyncResult<PostEntity> createPost(String username, String description, String? imagePath);
  AsyncResult<Unit> deletePost(int id);
  AsyncResult<PostEntity> updatePost(int id, String username, String description, String? imagePath);
}
