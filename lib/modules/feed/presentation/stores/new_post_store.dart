import 'package:mobx/mobx.dart';
import '../../domain/usecases/create_post_usecase.dart';

part 'new_post_store.g.dart';

class NewPostStore = NewPostStoreBase with _$NewPostStore;

abstract class NewPostStoreBase with Store {
  final CreatePostUseCase _createPostUseCase;

  NewPostStoreBase(this._createPostUseCase);

  @observable
  bool isLoading = false;

  @observable
  String? imagePath;

  @observable
  String? errorMessage;

  @action
  void setImagePath(String? path) {
    imagePath = path;
  }

  @action
  Future<bool> createPost(String username, String description) async {
    isLoading = true;
    errorMessage = null;

    final result = await _createPostUseCase(username: username, description: description, imagePath: imagePath);

    isLoading = false;

    return result.fold(
      (post) {
        imagePath = null;
        return true;
      },
      (error) {
        errorMessage = 'Erro ao publicar: ${error.toString()}';
        return false;
      },
    );
  }
}
