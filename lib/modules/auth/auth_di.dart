import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/http/http_service.dart';
import 'data/datasources/auth_datasource.dart';
import 'data/datasources/auth_datasource_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/auth_repository_impl.dart';
import 'domain/usecases/usecases.dart';
import 'presentation/stores/auth_store.dart';

Future<void> loadAuthDependencies(GetIt getIt) async {
  // Datasources
  getIt.registerLazySingleton<AuthDatasource>(() => AuthDatasourceImpl(getIt<HttpService>()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthDatasource>(), getIt<SharedPreferences>()),
  );

  // UseCases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CheckAuthUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));

  // Stores
  getIt.registerLazySingleton(
    () => AuthStore(getIt<LoginUseCase>(), getIt<CheckAuthUseCase>(), getIt<LogoutUseCase>(), getIt<RegisterUseCase>()),
  );
}
