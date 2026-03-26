import 'package:dio/dio.dart';
import '../models/character_model.dart';

abstract class RemoteDataSource {
  Future<List<CharacterModel>> fetchCharacters(int page);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl(this.dio);

  @override
  Future<List<CharacterModel>> fetchCharacters(int page) async {
    try {
      final response = await dio.get('https://rickandmortyapi.com/api/character/?page=$page');
      
      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((e) => CharacterModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
