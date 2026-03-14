import 'package:mobx/mobx.dart';
import '../../domain/entities/post_entity.dart';
import 'feed_store.dart';

part 'edit_post_store.g.dart';

class EditPostStore = EditPostStoreBase with _$EditPostStore;

abstract class EditPostStoreBase with Store {
  final FeedStore _feedStore;
  final PostEntity originalPost;

  EditPostStoreBase(this._feedStore, {required this.originalPost}) {
    newDescription = originalPost.description;
  }

  @observable
  bool isLoading = false;

  @observable
  String newDescription = '';

  @observable
  String? newImagePath;

  @observable
  String? errorMessage;

  @action
  void setNewDescription(String value) {
    newDescription = value;
  }

  @action
  void setNewImagePath(String? path) {
    newImagePath = path;
  }

  @computed
  bool get hasChanges {
    final descriptionChanged = newDescription != originalPost.description;
    final imageChanged = newImagePath != null;
    return descriptionChanged || imageChanged;
  }

  @action
  Future<bool> saveChanges() async {
    if (!hasChanges) return false;

    isLoading = true;
    errorMessage = null;

    final username = originalPost.username;

    final success = await _feedStore.updatePost(
      id: originalPost.id,
      username: username,
      description: newDescription,
      imagePath: newImagePath,
    );

    isLoading = false;

    if (!success) {
      errorMessage = 'Erro ao salvar as alterações.';
    }

    return success;
  }
}
