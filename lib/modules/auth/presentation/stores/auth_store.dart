import 'package:mobx/mobx.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final LoginUseCase _loginUseCase;
  final CheckAuthUseCase _checkAuthUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthStoreBase(this._loginUseCase, this._checkAuthUseCase, this._logoutUseCase);

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> logout() async {
    await _logoutUseCase();
  }

  @action
  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;

    final result = await _loginUseCase(username, password);

    isLoading = false;

    return result.fold(
      (token) => true, // Sucesso, redireciona para o Feed
      (error) {
        errorMessage = error.toString();
        return false; // Erro, mostra snackbar
      },
    );
  }

  @action
  Future<bool> checkIsLoggedIn() async {
    final result = await _checkAuthUseCase();
    return result.isSuccess();
  }
}
