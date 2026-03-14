// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewPostStore on NewPostStoreBase, Store {
  late final _$isLoadingAtom = Atom(
    name: 'NewPostStoreBase.isLoading',
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

  late final _$appErrorAtom = Atom(
    name: 'NewPostStoreBase.appError',
    context: context,
  );

  @override
  HttpException? get appError {
    _$appErrorAtom.reportRead();
    return super.appError;
  }

  @override
  set appError(HttpException? value) {
    _$appErrorAtom.reportWrite(value, super.appError, () {
      super.appError = value;
    });
  }

  late final _$imagePathAtom = Atom(
    name: 'NewPostStoreBase.imagePath',
    context: context,
  );

  @override
  String? get imagePath {
    _$imagePathAtom.reportRead();
    return super.imagePath;
  }

  @override
  set imagePath(String? value) {
    _$imagePathAtom.reportWrite(value, super.imagePath, () {
      super.imagePath = value;
    });
  }

  late final _$createPostAsyncAction = AsyncAction(
    'NewPostStoreBase.createPost',
    context: context,
  );

  @override
  Future<bool> createPost(String username, String description) {
    return _$createPostAsyncAction.run(
      () => super.createPost(username, description),
    );
  }

  late final _$NewPostStoreBaseActionController = ActionController(
    name: 'NewPostStoreBase',
    context: context,
  );

  @override
  void setImagePath(String? path) {
    final _$actionInfo = _$NewPostStoreBaseActionController.startAction(
      name: 'NewPostStoreBase.setImagePath',
    );
    try {
      return super.setImagePath(path);
    } finally {
      _$NewPostStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
appError: ${appError},
imagePath: ${imagePath}
    ''';
  }
}
