import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

enum CharactersStatus { initial, loading, success, failure }

class CharactersState extends Equatable {
  final CharactersStatus status;
  final List<Character> characters;
  final bool hasReachedMax;
  final int currentPage;
  final String errorMessage;

  const CharactersState({
    this.status = CharactersStatus.initial,
    this.characters = const <Character>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage = '',
  });

  CharactersState copyWith({
    CharactersStatus? status,
    List<Character>? characters,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, characters, hasReachedMax, currentPage, errorMessage];
}
