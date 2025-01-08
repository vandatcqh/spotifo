// data/models/genre_model.dart
import '../../domain/entities/genre_entity.dart';

class GenreModel extends GenreEntity {
  const GenreModel({
    required String id,
    required String name,
  }) : super(id: id, name: name);

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
  @override
  String toString() {
    return 'GenreModel(id: $id, name: $name)';
  }
}
