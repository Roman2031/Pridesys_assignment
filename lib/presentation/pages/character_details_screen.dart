import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/character.dart';
import '../bloc/characters/characters_bloc.dart';
import '../bloc/characters/characters_event.dart';
import '../bloc/characters/characters_state.dart';
import '../widgets/edit_character_dialog.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        // Find the freshest character instance from state (handles live edits/favorites)
        final liveCharacter = state.characters.firstWhere(
          (c) => c.id == character.id,
          orElse: () => character,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(liveCharacter.name),
            actions: [
              IconButton(
                icon: Icon(
                  liveCharacter.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: liveCharacter.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<CharactersBloc>().add(ToggleFavoriteEvent(liveCharacter.id));
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EditCharacterDialog(character: liveCharacter),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Locally'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedNetworkImage(
                  imageUrl: liveCharacter.image,
                  height: 300,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 300,
                    child: Icon(Icons.error, size: 50),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow('Name', liveCharacter.name),
                      _buildInfoRow('Status', liveCharacter.status),
                      _buildInfoRow('Species', liveCharacter.species),
                      _buildInfoRow('Type', liveCharacter.type.isEmpty ? 'Unknown' : liveCharacter.type),
                      _buildInfoRow('Gender', liveCharacter.gender),
                      _buildInfoRow('Origin', liveCharacter.originName),
                      _buildInfoRow('Location', liveCharacter.locationName),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
