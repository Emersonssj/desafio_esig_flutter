import '../../domain/entities/post_entity.dart';

class PostDto extends PostEntity {
  PostDto({
    required super.id,
    required super.username,
    required super.description,
    super.imageUrl,
    required super.createdAt,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      id: json['id'],
      username: json['username'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
