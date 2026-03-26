import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/character_usecases.dart';
import 'characters_event.dart';
import 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final GetCharacters getCharacters;
  final ToggleFavorite toggleFavorite;
  final SaveLocalEdit saveLocalEdit;

  CharactersBloc({
    required this.getCharacters,
    required this.toggleFavorite,
    required this.saveLocalEdit,
  }) : super(const CharactersState()) {
    on<FetchCharacters>(_onFetchCharacters);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SaveLocalEditEvent>(_onSaveLocalEdit);
  }

  Future<void> _onFetchCharacters(FetchCharacters event, Emitter<CharactersState> emit) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == CharactersStatus.initial) {
        emit(state.copyWith(status: CharactersStatus.loading));
        final characters = await getCharacters(state.currentPage);
        return emit(state.copyWith(
          status: CharactersStatus.success,
          characters: characters,
          hasReachedMax: characters.isEmpty,
          currentPage: state.currentPage + 1,
        ));
      }

      final characters = await getCharacters(state.currentPage);
      emit(characters.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: CharactersStatus.success,
              characters: List.of(state.characters)..addAll(characters),
              hasReachedMax: false,
              currentPage: state.currentPage + 1,
            ));
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<CharactersState> emit) async {
    await toggleFavorite(event.id);
    
    // Update local state instantly instead of re-fetching
    final updatedCharacters = state.characters.map((char) {
      if (char.id == event.id) {
        return char.copyWith(isFavorite: !char.isFavorite);
      }
      return char;
    }).toList();
    
    emit(state.copyWith(characters: updatedCharacters));
  }

  Future<void> _onSaveLocalEdit(SaveLocalEditEvent event, Emitter<CharactersState> emit) async {
    await saveLocalEdit(event.character);
    
    // Update local state instantly
    final updatedCharacters = state.characters.map((char) {
      if (char.id == event.character.id) {
        return event.character;
      }
      return char;
    }).toList();
    
    emit(state.copyWith(characters: updatedCharacters));
  }
}
