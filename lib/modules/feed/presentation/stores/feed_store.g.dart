// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FeedStore on FeedStoreBase, Store {
  late final _$postsAtom = Atom(name: 'FeedStoreBase.posts', context: context);

  @override
  ObservableList<PostEntity> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(ObservableList<PostEntity> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: 'FeedStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$hasMoreAtom = Atom(
    name: 'FeedStoreBase.hasMore',
    context: context,
  );

  @override
  bool get hasMore {
    _$hasMoreAtom.reportRead();
    return super.hasMore;
  }

  @override
  set hasMore(bool value) {
    _$hasMoreAtom.reportWrite(value, super.hasMore, () {
      super.hasMore = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'FeedStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$deletePostAsyncAction = AsyncAction(
    'FeedStoreBase.deletePost',
    context: context,
  );

  @override
  Future<bool> deletePost(int id) {
    return _$deletePostAsyncAction.run(() => super.deletePost(id));
  }

  late final _$updatePostAsyncAction = AsyncAction(
    'FeedStoreBase.updatePost',
    context: context,
  );

  @override
  Future<bool> updatePost(int id, String username, String description) {
    return _$updatePostAsyncAction.run(
      () => super.updatePost(id, username, description),
    );
  }

  late final _$fetchPostsAsyncAction = AsyncAction(
    'FeedStoreBase.fetchPosts',
    context: context,
  );

  @override
  Future<void> fetchPosts({bool isRefresh = false}) {
    return _$fetchPostsAsyncAction.run(
      () => super.fetchPosts(isRefresh: isRefresh),
    );
  }

  @override
  String toString() {
    return '''
posts: ${posts},
isLoading: ${isLoading},
hasMore: ${hasMore},
errorMessage: ${errorMessage}
    ''';
  }
}
