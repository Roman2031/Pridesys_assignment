import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object> get props => [];
}

class FetchCharacters extends CharactersEvent {}

class SearchCharacters extends CharactersEvent {
  final String query;
  const SearchCharacters(this.query);
  
  @override
  List<Object> get props => [query];
}

class ToggleFavoriteEvent extends CharactersEvent {
  final int id;
  const ToggleFavoriteEvent(this.id);
  
  @override
  List<Object> get props => [id];
}

class SaveLocalEditEvent extends CharactersEvent {
  final Character character;
  const SaveLocalEditEvent(this.character);
  
  @override
  List<Object> get props => [character];
}
