import 'package:mobx/mobx.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/usecases.dart';

part 'feed_store.g.dart';

class FeedStore = FeedStoreBase with _$FeedStore;

abstract class FeedStoreBase with Store {
  final GetPostsUseCase _getPostsUseCase;
  final DeletePostUsecase _deletePostUseCase;
  final UpdatePostUsecase _updatePostUseCase;

  FeedStoreBase(this._getPostsUseCase, this._deletePostUseCase, this._updatePostUseCase);

  @observable
  ObservableList<PostEntity> posts = ObservableList<PostEntity>();

  @observable
  bool isLoading = false;

  @observable
  bool hasMore = true;

  @observable
  String? errorMessage;

  int currentPage = 0;

  @action
  Future<bool> deletePost(int id) async {
    final result = await _deletePostUseCase(id);
    return result.fold((success) {
      posts.removeWhere((post) => post.id == id);
      return true;
    }, (error) => false);
  }

  @action
  Future<bool> updatePost(int id, String username, String description) async {
    final result = await _updatePostUseCase(id: id, username: username, description: description);
    return result.fold((updatedPost) {
      final index = posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        posts[index] = updatedPost;
      }
      return true;
    }, (error) => false);
  }

  @action
  Future<void> fetchPosts({bool isRefresh = false}) async {
    if (isLoading) return;

    if (isRefresh) {
      currentPage = 0;
      hasMore = true;
      posts.clear();
      errorMessage = null;
    }

    if (!hasMore) return;

    isLoading = true;

    final result = await _getPostsUseCase(currentPage);

    result.fold(
      (newPosts) {
        posts.addAll(newPosts);
        if (newPosts.length < 10) {
          hasMore = false;
        } else {
          currentPage++;
        }
      },
      (error) {
        errorMessage = 'Erro ao carregar os posts.';
      },
    );

    isLoading = false;
  }
}
