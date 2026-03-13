import 'package:result_dart/result_dart.dart';
import '../dtos/post_dto.dart';

abstract interface class FeedDatasource {
  AsyncResult<List<PostDto>> getPosts(int page);
  AsyncResult<PostDto> createPost(String username, String description, String? imagePath);
  AsyncResult<Unit> deletePost(int id);
  AsyncResult<PostDto> updatePost(int id, String username, String description, String? imagePath);
}
