import '../../domain/entities/character.dart';
import '../../domain/repository/character_repository.dart';
import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';
import '../models/character_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Character>> getCharacters(int page) async {
    List<CharacterModel> models = [];
    try {
      models = await remoteDataSource.fetchCharacters(page);
      await localDataSource.cacheCharacters(page, models);
    } catch (e) {
      // Offline fallback
      models = await localDataSource.getCachedCharacters(page);
    }

    final favorites = await localDataSource.getFavorites();
    final List<Character> finalCharacters = [];

    for (var model in models) {
      final isFav = favorites.contains(model.id);
      final localEdit = await localDataSource.getLocalEdit(model.id);
      finalCharacters.add(model.toEntity(
        isFavorite: isFav,
        editOverrides: localEdit,
      ));
    }
    return finalCharacters;
  }

  @override
  Future<Character?> getCharacterDetails(int id) async {
    final model = await localDataSource.getCharacterById(id);
    if (model == null) return null;

    final favorites = await localDataSource.getFavorites();
    final isFav = favorites.contains(id);
    final localEdit = await localDataSource.getLocalEdit(id);
    
    return model.toEntity(
      isFavorite: isFav,
      editOverrides: localEdit,
    );
  }

  @override
  Future<List<Character>> getFavorites() async {
    final favoriteIds = await localDataSource.getFavorites();
    final List<Character> favoriteCharacters = [];

    for (var id in favoriteIds) {
      final model = await localDataSource.getCharacterById(id);
      if (model != null) {
        final localEdit = await localDataSource.getLocalEdit(id);
        favoriteCharacters.add(model.toEntity(
          isFavorite: true,
          editOverrides: localEdit,
        ));
      }
    }
    return favoriteCharacters;
  }

  @override
  Future<void> toggleFavorite(int id) async {
    await localDataSource.toggleFavorite(id);
  }

  @override
  Future<void> saveLocalEdit(Character character) async {
    final editModel = LocalEditModel.fromEntity(character);
    await localDataSource.saveLocalEdit(editModel);
  }
}
