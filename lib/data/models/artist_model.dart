// data/models/artist_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/artist_entity.dart';

class ArtistModel extends ArtistEntity {
  ArtistModel({
    required super.id,
    required super.artistName,
    super.artistImageUrl,
    super.followers,
    super.description,
  });

  // Từ Firestore DocumentSnapshot sang ArtistModel
  factory ArtistModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArtistModel(
      id: doc.id,
      artistName: data['artistName'],
      artistImageUrl: data['artistImageUrl'],
      followers: data['followers'] ?? 0,
      description: data['description'],
    );
  }

  // Từ ArtistModel sang JSON để lưu vào Firestore
  Map<String, dynamic> toDocument() {
    return {
      'artistName': artistName,
      'artistImageUrl': artistImageUrl,
      'followers': followers,
      'description': description,
    };
  }

  // Hàm copyWith để tạo bản sao với các thuộc tính có thể được cập nhật
  ArtistModel copyWith({
    String? id,
    String? artistName,
    String? artistImageUrl,
    int? followers,
    String? description,
  }) {
    return ArtistModel(
      id: id ?? this.id,
      artistName: artistName ?? this.artistName,
      artistImageUrl: artistImageUrl ?? this.artistImageUrl,
      followers: followers ?? this.followers,
      description: description ?? this.description,
    );
  }
}
