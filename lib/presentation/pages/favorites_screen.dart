import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import '../widgets/character_card.dart';
import 'character_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet.\nGo back and heart some characters!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final character = state.favorites[index];
              return CharacterCard(
                character: character,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailsScreen(character: character),
                    ),
                  ).then((_) {
                    // Reload favorites when coming back just in case they unfavorited in details
                    if (context.mounted) {
                      context.read<FavoritesBloc>().add(LoadFavorites());
                    }
                  });
                },
                onFavoriteToggle: () {
                  context.read<FavoritesBloc>().add(RemoveFavorite(character.id));
                },
              );
            },
          );
        },
      ),
    );
  }
}
