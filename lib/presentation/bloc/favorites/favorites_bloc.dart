import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/character_usecases.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    try {
      final characters = await getFavorites();
      emit(state.copyWith(
        status: FavoritesStatus.success,
        favorites: characters,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoritesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRemoveFavorite(RemoveFavorite event, Emitter<FavoritesState> emit) async {
    await toggleFavorite(event.id);
    
    // Remove from local list to update UI instantly
    final updatedFavorites = state.favorites.where((c) => c.id != event.id).toList();
    emit(state.copyWith(favorites: updatedFavorites));
  }
}
