import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../data/datasource/local_datasource.dart';
import '../../data/datasource/remote_datasource.dart';
import '../../data/models/character_model.dart';
import '../../data/repository/character_repository_impl.dart';
import '../../domain/repository/character_repository.dart';
import '../../domain/usecases/character_usecases.dart';
import '../../presentation/bloc/characters/characters_bloc.dart';
import '../../presentation/bloc/favorites/favorites_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Hive Boxes
  final pageCacheBox = await Hive.openBox<List>('page_cache_box');
  final charactersBox = await Hive.openBox<CharacterModel>('characters_box');
  final favoritesBox = await Hive.openBox<int>('favorites_box');
  final editsBox = await Hive.openBox<LocalEditModel>('edits_box');

  // Core
  sl.registerLazySingleton(() => Dio());

  // Data sources
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(sl()),
  );
  
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(
      pageCacheBox: pageCacheBox,
      charactersBox: charactersBox,
      favoritesBox: favoritesBox,
      editsBox: editsBox,
    ),
  );

  // Repository
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCharacters(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => SaveLocalEdit(sl()));
  
  // Blocs
  sl.registerFactory(() => CharactersBloc(
        getCharacters: sl(),
        toggleFavorite: sl(),
        saveLocalEdit: sl(),
      ));
  sl.registerFactory(() => FavoritesBloc(
        getFavorites: sl(),
        toggleFavorite: sl(),
      ));
}
