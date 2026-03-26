import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/character.dart';
import '../bloc/characters/characters_bloc.dart';
import '../bloc/characters/characters_event.dart';

class EditCharacterDialog extends StatefulWidget {
  final Character character;

  const EditCharacterDialog({super.key, required this.character});

  @override
  State<EditCharacterDialog> createState() => _EditCharacterDialogState();
}

class _EditCharacterDialogState extends State<EditCharacterDialog> {
  late TextEditingController _nameController;
  late TextEditingController _statusController;
  late TextEditingController _speciesController;
  late TextEditingController _typeController;
  late TextEditingController _genderController;
  late TextEditingController _originController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.character.name);
    _statusController = TextEditingController(text: widget.character.status);
    _speciesController = TextEditingController(text: widget.character.species);
    _typeController = TextEditingController(text: widget.character.type);
    _genderController = TextEditingController(text: widget.character.gender);
    _originController = TextEditingController(text: widget.character.originName);
    _locationController = TextEditingController(text: widget.character.locationName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _speciesController.dispose();
    _typeController.dispose();
    _genderController.dispose();
    _originController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveEdits() {
    final updatedCharacter = widget.character.copyWith(
      name: _nameController.text.trim(),
      status: _statusController.text.trim(),
      species: _speciesController.text.trim(),
      type: _typeController.text.trim(),
      gender: _genderController.text.trim(),
      originName: _originController.text.trim(),
      locationName: _locationController.text.trim(),
    );

    context.read<CharactersBloc>().add(SaveLocalEditEvent(updatedCharacter));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Character Locally'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _statusController, decoration: const InputDecoration(labelText: 'Status')),
            TextField(controller: _speciesController, decoration: const InputDecoration(labelText: 'Species')),
            TextField(controller: _typeController, decoration: const InputDecoration(labelText: 'Type')),
            TextField(controller: _genderController, decoration: const InputDecoration(labelText: 'Gender')),
            TextField(controller: _originController, decoration: const InputDecoration(labelText: 'Origin')),
            TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveEdits,
          child: const Text('Save Override'),
        ),
      ],
    );
  }
}
