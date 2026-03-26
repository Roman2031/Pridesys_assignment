import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/characters/characters_bloc.dart';
import '../bloc/characters/characters_event.dart';
import '../bloc/characters/characters_state.dart';
import '../widgets/character_card.dart';
import 'character_details_screen.dart';
import 'favorites_screen.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharactersBloc>().add(FetchCharacters());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          )
        ],
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          if (state.status == CharactersStatus.initial || (state.status == CharactersStatus.loading && state.characters.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CharactersStatus.failure && state.characters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => context.read<CharactersBloc>().add(FetchCharacters()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax ? state.characters.length : state.characters.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.characters.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final character = state.characters[index];
              return CharacterCard(
                character: character,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailsScreen(character: character),
                    ),
                  );
                },
                onFavoriteToggle: () {
                  context.read<CharactersBloc>().add(ToggleFavoriteEvent(character.id));
                },
              );
            },
          );
        },
      ),
    );
  }
}
