import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<Character> favorites;
  final String errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const <Character>[],
    this.errorMessage = '',
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Character>? favorites,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, favorites, errorMessage];
}
