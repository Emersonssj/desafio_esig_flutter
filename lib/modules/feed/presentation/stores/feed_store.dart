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
  bool hasMore = true; // Indica se ainda existem posts no backend

  @observable
  String? errorMessage;

  int currentPage = 0;

  // ... adicione as injeções dos UseCases no construtor da FeedStore

  @action
  Future<bool> deletePost(int id) async {
    final result = await _deletePostUseCase(id);
    return result.fold((success) {
      posts.removeWhere((post) => post.id == id); // Remove da lista visual
      return true;
    }, (error) => false);
  }

  @action
  Future<bool> updatePost(int id, String username, String description) async {
    final result = await _updatePostUseCase(id: id, username: username, description: description);
    return result.fold((updatedPost) {
      // Encontra o post na lista e substitui pela versão nova
      final index = posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        posts[index] = updatedPost;
      }
      return true;
    }, (error) => false);
  }

  @action
  Future<void> fetchPosts({bool isRefresh = false}) async {
    if (isLoading) return; // Evita múltiplas chamadas simultâneas

    if (isRefresh) {
      currentPage = 0;
      hasMore = true;
      posts.clear();
      errorMessage = null;
    }

    if (!hasMore) return;

    isLoading = true;

    final result = await _getPostsUseCase(currentPage);

    isLoading = false;

    result.fold(
      (newPosts) {
        if (newPosts.isEmpty) {
          hasMore = false; // Se a API retornar vazio, acabaram os posts
        } else {
          posts.addAll(newPosts);
          currentPage++; // Prepara para a próxima página
        }
      },
      (error) {
        errorMessage = 'Erro ao carregar os posts.';
      },
    );
  }
}
