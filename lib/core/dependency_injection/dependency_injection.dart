import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/auth/auth_di.dart';
import '../../modules/feed/feed_di.dart';
import '../environment/environment.dart';
import '../network/auth_interceptor.dart';
import '../network/http/http_service.dart';
import '../network/http/http_service_impl.dart';

final getIt = GetIt.instance;

Future<void> loadModulesDependencies() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // 2. Interceptors
  final authInterceptor = AuthInterceptor(sharedPrefs);

  // 3. Network (Dio configurado com a URL do Render e o Interceptor)
  getIt.registerLazySingleton<HttpService>(
    () => HttpServiceImpl(baseUrl: Environment.backLinuxBaseUrl, interceptors: [authInterceptor]),
  );

  loadAuthDependencies(getIt);
  loadFeedDependencies(getIt);
}
