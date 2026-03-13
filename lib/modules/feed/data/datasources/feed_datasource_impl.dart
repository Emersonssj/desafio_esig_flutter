import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/network/http/http_service.dart';
import '../dtos/post_dto.dart';
import 'feed_datasource.dart';

class FeedDatasourceImpl implements FeedDatasource {
  final HttpService _httpService;

  FeedDatasourceImpl(this._httpService);

  @override
  AsyncResult<List<PostDto>> getPosts(int page) async {
    final response = await _httpService.get('/api/posts?page=$page&size=10');

    return response.map((res) {
      final data = res.content as Map<String, dynamic>;
      final contentList = data['content'] as List;

      return contentList.map((json) => PostDto.fromJson(json)).toList();
    });
  }

  @override
  AsyncResult<PostDto> createPost(String username, String description, String? imagePath) async {
    final formData = FormData.fromMap({'username': username, 'description': description});

    if (imagePath != null && imagePath.isNotEmpty) {
      formData.files.add(MapEntry('file', await MultipartFile.fromFile(imagePath)));
    }

    final response = await _httpService.upload('/api/posts', formData);

    return response.map((res) {
      return PostDto.fromJson(res.content as Map<String, dynamic>);
    });
  }

  @override
  AsyncResult<Unit> deletePost(int id) async {
    final response = await _httpService.delete('/api/posts/$id');
    return response.map((_) => unit);
  }

  @override
  AsyncResult<PostDto> updatePost(int id, String username, String description, String? imagePath) async {
    final formData = FormData.fromMap({'username': username, 'description': description});

    if (imagePath != null && imagePath.isNotEmpty) {
      formData.files.add(MapEntry('file', await MultipartFile.fromFile(imagePath)));
    }

    final response = await _httpService.put('/api/posts/$id', data: formData);
    return response.map((res) => PostDto.fromJson(res.content as Map<String, dynamic>));
  }
}
