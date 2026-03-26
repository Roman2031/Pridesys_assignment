import '../entities/character.dart';
import '../repository/character_repository.dart';

class GetCharacters {
  final CharacterRepository repository;

  GetCharacters(this.repository);

  Future<List<Character>> call(int page) async {
    return await repository.getCharacters(page);
  }
}

class ToggleFavorite {
  final CharacterRepository repository;

  ToggleFavorite(this.repository);

  Future<void> call(int id) async {
    return await repository.toggleFavorite(id);
  }
}

class GetFavorites {
  final CharacterRepository repository;

  GetFavorites(this.repository);

  Future<List<Character>> call() async {
    return await repository.getFavorites();
  }
}

class SaveLocalEdit {
  final CharacterRepository repository;

  SaveLocalEdit(this.repository);

  Future<void> call(Character character) async {
    return await repository.saveLocalEdit(character);
  }
}
