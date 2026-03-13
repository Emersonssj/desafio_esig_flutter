import 'package:get_it/get_it.dart';

import '../../core/mapper/mapper.dart';
import '../../core/network/http/http_service.dart';
import 'data/datasources/datasources.dart';
import 'data/dtos/post_dto.dart';
import 'data/mappers/post_mapper.dart';
import 'domain/entities/post_entity.dart';
import 'domain/repositories/repositories.dart';
import 'domain/usecases/usecases.dart';
import 'presentation/stores/feed_store.dart';
import 'presentation/stores/new_post_store.dart';

Future<void> loadFeedDependencies(GetIt getIt) async {
  // Mappers
  getIt.registerLazySingleton<Mapper<PostEntity, PostDto>>(() => PostMapper());

  // Datasources
  getIt.registerLazySingleton<FeedDatasource>(() => FeedDatasourceImpl(getIt<HttpService>()));

  // Repositories
  getIt.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(getIt<FeedDatasource>(), getIt<Mapper<PostEntity, PostDto>>()),
  );

  // UseCases
  getIt.registerLazySingleton(() => GetPostsUseCase(getIt<FeedRepository>()));
  getIt.registerLazySingleton(() => CreatePostUseCase(getIt<FeedRepository>()));
  getIt.registerLazySingleton(() => DeletePostUsecase(getIt<FeedRepository>()));
  getIt.registerLazySingleton(() => UpdatePostUsecase(getIt<FeedRepository>()));

  // Stores
  getIt.registerLazySingleton(
    () => FeedStore(getIt<GetPostsUseCase>(), getIt<DeletePostUsecase>(), getIt<UpdatePostUsecase>()),
  );
  getIt.registerLazySingleton(() => NewPostStore(getIt<CreatePostUseCase>()));
}
