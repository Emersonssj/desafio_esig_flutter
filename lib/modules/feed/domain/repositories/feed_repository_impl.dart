import 'package:result_dart/result_dart.dart';

import '../../../../core/mapper/mapper.dart';
import '../../../../core/network/http/http_exception.dart';
import '../../data/datasources/feed_datasource.dart';
import '../../data/dtos/post_dto.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedDatasource _datasource;
  final Mapper<PostEntity, PostDto> _postMapper;

  FeedRepositoryImpl(this._datasource, this._postMapper);

  @override
  AsyncResult<List<PostEntity>, HttpException> getPosts(int page) {
    var result = _datasource.getPosts(page);

    return result.flatMap((success) {
      final list = _postMapper.toDtoList(success);
      return Success(list);
    });
  }

  @override
  AsyncResult<PostEntity, HttpException> createPost(String username, String description, String? imagePath) {
    var result = _datasource.createPost(username, description, imagePath);

    return result.flatMap((success) {
      final newPost = _postMapper.toDto(success);
      return Success(newPost);
    });
  }

  @override
  AsyncResult<Unit, HttpException> deletePost(int id) => _datasource.deletePost(id);

  @override
  AsyncResult<PostEntity, HttpException> updatePost(int id, String username, String description, String? imagePath) {
    return _datasource.updatePost(id, username, description, imagePath);
  }
}
