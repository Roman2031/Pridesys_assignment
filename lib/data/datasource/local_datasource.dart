import 'package:hive/hive.dart';
import '../models/character_model.dart';

abstract class LocalDataSource {
  Future<void> cacheCharacters(int page, List<CharacterModel> characters);
  Future<List<CharacterModel>> getCachedCharacters(int page);
  Future<CharacterModel?> getCharacterById(int id);
  
  Future<void> toggleFavorite(int id);
  Future<List<int>> getFavorites();
  
  Future<void> saveLocalEdit(LocalEditModel edit);
  Future<LocalEditModel?> getLocalEdit(int id);
}

class LocalDataSourceImpl implements LocalDataSource {
  final Box<List> pageCacheBox; // Maps Page -> List<int> (Character IDs)
  final Box<CharacterModel> charactersBox; // Maps ID -> CharacterModel
  final Box<int> favoritesBox;
  final Box<LocalEditModel> editsBox;

  LocalDataSourceImpl({
    required this.pageCacheBox,
    required this.charactersBox,
    required this.favoritesBox,
    required this.editsBox,
  });

  @override
  Future<void> cacheCharacters(int page, List<CharacterModel> characters) async {
    final ids = characters.map((e) => e.id).toList();
    await pageCacheBox.put(page, ids);
    
    // Save each character by ID for fast lookup
    for (var char in characters) {
      await charactersBox.put(char.id, char);
    }
  }

  @override
  Future<List<CharacterModel>> getCachedCharacters(int page) async {
    final cachedPageIds = pageCacheBox.get(page);
    if (cachedPageIds != null) {
      final List<int> ids = cachedPageIds.cast<int>();
      return ids.map((id) => charactersBox.get(id)).whereType<CharacterModel>().toList();
    }
    return [];
  }

  @override
  Future<CharacterModel?> getCharacterById(int id) async {
    return charactersBox.get(id);
  }

  @override
  Future<void> toggleFavorite(int id) async {
    if (favoritesBox.containsKey(id)) {
      await favoritesBox.delete(id);
    } else {
      await favoritesBox.put(id, id);
    }
  }

  @override
  Future<List<int>> getFavorites() async {
    return favoritesBox.values.toList();
  }

  @override
  Future<void> saveLocalEdit(LocalEditModel edit) async {
    await editsBox.put(edit.id, edit);
  }

  @override
  Future<LocalEditModel?> getLocalEdit(int id) async {
    return editsBox.get(id);
  }
}
