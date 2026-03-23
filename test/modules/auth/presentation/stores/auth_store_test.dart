import 'package:desafio_esig_flutter/core/network/http/http_exception.dart';
import 'package:desafio_esig_flutter/modules/auth/domain/usecases/usecases.dart';
import 'package:desafio_esig_flutter/modules/auth/presentation/stores/auth_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockCheckCachedAuthUseCase extends Mock implements CheckAuthUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late AuthStore store;
  late MockLoginUseCase mockLoginUseCase;
  late MockCheckCachedAuthUseCase mockCheckCachedAuthUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockCheckCachedAuthUseCase = MockCheckCachedAuthUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockRegisterUseCase = MockRegisterUseCase();

    store = AuthStore(mockLoginUseCase, mockCheckCachedAuthUseCase, mockLogoutUseCase, mockRegisterUseCase);
  });

  group('AuthStore | Action Login |', () {
    const tUsername = 'emerson_dev';
    const tPassword = 'Password123!';
    const tToken = 'fake_jwt_token';

    test('deve alterar o estado do isLoading corretamente durante o fluxo de sucesso', () async {
      // ARRANGE
      when(() => mockLoginUseCase.call(tUsername, tPassword)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return const Success(tToken);
      });

      expect(store.isLoading, false);
      expect(store.errorMessage, isNull);

      // ACT
      final futureCall = store.login(tUsername, tPassword);

      // --- ASSERT
      expect(store.isLoading, true);
      final result = await futureCall;

      expect(result, true);
      expect(store.isLoading, false);
      expect(store.errorMessage, isNull);

      verify(() => mockLoginUseCase.call(tUsername, tPassword)).called(1);
    });

    test('deve preencher a errorMessage e desligar o loading quando o UseCase retornar erro', () async {
      // ARRANGE
      final tException = HttpException(statusCode: 401, message: 'Usuário ou senha incorretos.');

      when(() => mockLoginUseCase.call(tUsername, 'senha_errada')).thenAnswer((_) async => Failure(tException));

      // ACT
      final result = await store.login(tUsername, 'senha_errada');

      // ASSERT
      expect(result, false);
      expect(store.isLoading, false);

      expect(store.errorMessage, 'Usuário ou senha incorretos.');
    });
  });
}
