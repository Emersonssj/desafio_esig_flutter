import '../../../../core/mapper/mapper.dart';
import '../../domain/entities/post_entity.dart';
import '../dtos/post_dto.dart';

class PostMapper extends Mapper<PostEntity, PostDto> {
  @override
  PostDto toDto(PostEntity entity) {
    return PostDto(
      id: entity.id,
      username: entity.username,
      description: entity.description,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
    );
  }

  @override
  PostEntity toEntity(PostDto dto) {
    return PostEntity(
      id: dto.id,
      username: dto.username,
      description: dto.description,
      imageUrl: dto.imageUrl,
      createdAt: dto.createdAt,
    );
  }
}
