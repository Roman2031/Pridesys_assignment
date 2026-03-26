import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection_container.dart' as di;
import 'data/models/character_model.dart';
import 'presentation/bloc/characters/characters_bloc.dart';
import 'presentation/bloc/characters/characters_event.dart';
import 'presentation/bloc/favorites/favorites_bloc.dart';

import 'presentation/pages/character_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(CharacterModelAdapter());
  Hive.registerAdapter(LocalEditModelAdapter());
  
  // Initialize DI
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<CharactersBloc>()..add(FetchCharacters()),
        ),
        BlocProvider(
          create: (_) => di.sl<FavoritesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Rick and Morty',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const CharacterListScreen(),
      ),
    );
  }
}
