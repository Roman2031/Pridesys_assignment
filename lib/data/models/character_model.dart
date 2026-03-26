import 'package:hive/hive.dart';
import '../../domain/entities/character.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String gender;

  @HiveField(6)
  final String originName;

  @HiveField(7)
  final String locationName;

  @HiveField(8)
  final String image;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      originName: json['origin']?['name'] ?? '',
      locationName: json['location']?['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Character toEntity({bool isFavorite = false, LocalEditModel? editOverrides}) {
    return Character(
      id: id,
      name: editOverrides?.name ?? name,
      status: editOverrides?.status ?? status,
      species: editOverrides?.species ?? species,
      type: editOverrides?.type ?? type,
      gender: editOverrides?.gender ?? gender,
      originName: editOverrides?.originName ?? originName,
      locationName: editOverrides?.locationName ?? locationName,
      image: editOverrides?.image ?? image, // usually image is not edited, but kept just in case
      isFavorite: isFavorite,
    );
  }
}

@HiveType(typeId: 1)
class LocalEditModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? status;

  @HiveField(3)
  final String? species;

  @HiveField(4)
  final String? type;

  @HiveField(5)
  final String? gender;

  @HiveField(6)
  final String? originName;

  @HiveField(7)
  final String? locationName;

  @HiveField(8)
  final String? image;

  LocalEditModel({
    required this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.originName,
    this.locationName,
    this.image,
  });

  factory LocalEditModel.fromEntity(Character character) {
    return LocalEditModel(
      id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      type: character.type,
      gender: character.gender,
      originName: character.originName,
      locationName: character.locationName,
      image: character.image,
    );
  }
}
