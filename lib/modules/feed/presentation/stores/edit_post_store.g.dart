// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditPostStore on EditPostStoreBase, Store {
  Computed<bool>? _$hasChangesComputed;

  @override
  bool get hasChanges => (_$hasChangesComputed ??= Computed<bool>(
    () => super.hasChanges,
    name: 'EditPostStoreBase.hasChanges',
  )).value;

  late final _$isLoadingAtom = Atom(
    name: 'EditPostStoreBase.isLoading',
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

  late final _$newDescriptionAtom = Atom(
    name: 'EditPostStoreBase.newDescription',
    context: context,
  );

  @override
  String get newDescription {
    _$newDescriptionAtom.reportRead();
    return super.newDescription;
  }

  @override
  set newDescription(String value) {
    _$newDescriptionAtom.reportWrite(value, super.newDescription, () {
      super.newDescription = value;
    });
  }

  late final _$newImagePathAtom = Atom(
    name: 'EditPostStoreBase.newImagePath',
    context: context,
  );

  @override
  String? get newImagePath {
    _$newImagePathAtom.reportRead();
    return super.newImagePath;
  }

  @override
  set newImagePath(String? value) {
    _$newImagePathAtom.reportWrite(value, super.newImagePath, () {
      super.newImagePath = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'EditPostStoreBase.errorMessage',
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

  late final _$saveChangesAsyncAction = AsyncAction(
    'EditPostStoreBase.saveChanges',
    context: context,
  );

  @override
  Future<bool> saveChanges() {
    return _$saveChangesAsyncAction.run(() => super.saveChanges());
  }

  late final _$EditPostStoreBaseActionController = ActionController(
    name: 'EditPostStoreBase',
    context: context,
  );

  @override
  void setNewDescription(String value) {
    final _$actionInfo = _$EditPostStoreBaseActionController.startAction(
      name: 'EditPostStoreBase.setNewDescription',
    );
    try {
      return super.setNewDescription(value);
    } finally {
      _$EditPostStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNewImagePath(String? path) {
    final _$actionInfo = _$EditPostStoreBaseActionController.startAction(
      name: 'EditPostStoreBase.setNewImagePath',
    );
    try {
      return super.setNewImagePath(path);
    } finally {
      _$EditPostStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
newDescription: ${newDescription},
newImagePath: ${newImagePath},
errorMessage: ${errorMessage},
hasChanges: ${hasChanges}
    ''';
  }
}
