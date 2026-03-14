import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../entities/post_entity.dart';

abstract interface class FeedRepository {
  AsyncResult<List<PostEntity>, HttpException> getPosts(int page);
  AsyncResult<PostEntity, HttpException> createPost(String username, String description, String? imagePath);
  AsyncResult<Unit, HttpException> deletePost(int id);
  AsyncResult<PostEntity, HttpException> updatePost(int id, String username, String description, String? imagePath);
}
