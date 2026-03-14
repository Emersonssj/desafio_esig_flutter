import 'package:result_dart/result_dart.dart';
import '../../../../core/network/http/http_exception.dart';
import '../dtos/post_dto.dart';

abstract interface class FeedDatasource {
  AsyncResult<List<PostDto>, HttpException> getPosts(int page);
  AsyncResult<PostDto, HttpException> createPost(String username, String description, String? imagePath);
  AsyncResult<Unit, HttpException> deletePost(int id);
  AsyncResult<PostDto, HttpException> updatePost(int id, String username, String description, String? imagePath);
}
