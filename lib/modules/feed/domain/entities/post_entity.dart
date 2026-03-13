class PostEntity {
  final int id;
  final String username;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;

  PostEntity({
    required this.id,
    required this.username,
    required this.description,
    this.imageUrl,
    required this.createdAt,
  });
}
