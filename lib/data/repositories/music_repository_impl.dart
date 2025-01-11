import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotifo/data/datasources/song_remote_datasource.dart';
import '../../domain/repositories/music_repository.dart';
import '../models/song_model.dart';

class MusicRepositoryImpl implements MusicRepository {
  final SongRemoteDataSource songRemoteDataSource;
  final FirebaseFirestore firestore;

  MusicRepositoryImpl(this.firestore, {
    required this.songRemoteDataSource,
  });
  @override
  Future<List<SongModel>> getHotSongs({int limit = 5}) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Songs')
          .orderBy('playCount', descending: true)
          .limit(limit)
          .get();
      return querySnapshot.docs.map((doc) => SongModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception("Get Hot Songs Failed: $e");
    }
  }
}