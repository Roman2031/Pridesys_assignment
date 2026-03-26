import '../entities/character.dart';

abstract class CharacterRepository {
  /// Fetches characters with pagination.
  /// Falls back to local cache if offline.
  /// Applies local edits and favorites automatically.
  Future<List<Character>> getCharacters(int page);

  /// Get details for a specific character (including local overrides)
  Future<Character?> getCharacterDetails(int id);

  /// Toggles whether a character is favorited or not.
  Future<void> toggleFavorite(int id);

  /// Retrieves list of favorited characters.
  Future<List<Character>> getFavorites();

  /// Saves a local edit overriding network values.
  Future<void> saveLocalEdit(Character character);
}
