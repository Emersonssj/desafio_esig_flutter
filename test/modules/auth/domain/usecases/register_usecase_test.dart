import 'package:desafio_esig_flutter/modules/auth/domain/repositories/auth_repository.dart' show AuthRepository;
import 'package:desafio_esig_flutter/modules/auth/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase |', () {
    test('deve chamar o repository e retornar sucesso quando os dados forem validos', () async {
      // ARRANGE
      final validUsername = 'emerson_dev';
      final password = 'Password123!';

      when(() => mockRepository.register(validUsername, password)).thenAnswer((_) async => Success(unit));

      // ACT
      final result = await usecase(validUsername, password);

      // ASSERT
      expect(result.isSuccess(), true);

      verify(() => mockRepository.register(validUsername, password)).called(1);
    });
  });
}
