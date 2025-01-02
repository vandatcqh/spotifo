import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotifo/data/datasources/album_remote_datasource.dart';
import 'package:spotifo/data/datasources/artist_remote_datasource.dart';
import 'package:spotifo/data/datasources/song_remote_datasource.dart';

import '../../domain/repositories/music_repository.dart';
import '../models/album_model.dart';
import '../models/artist_model.dart';
import '../models/song_model.dart';
class AlbumWithPlayCount {
  final AlbumModel album;
  final int totalPlayCount;

  AlbumWithPlayCount({
    required this.album,
    required this.totalPlayCount,
  });
}
class ArtistWithPlayCount {
  final ArtistModel artist;
  final int totalPlayCount;

  ArtistWithPlayCount({
    required this.artist,
    required this.totalPlayCount,
  });
}
class MusicRepositoryImpl implements MusicRepository {
  final SongRemoteDataSource songRemoteDataSource;
  final AlbumRemoteDataSource albumRemoteDataSource;
  final ArtistRemoteDataSource artistRemoteDataSource;
  final FirebaseFirestore firestore;

  MusicRepositoryImpl(this.firestore, {
    required this.songRemoteDataSource,
    required this.artistRemoteDataSource,
    required this.albumRemoteDataSource
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
  @override
  Future<List<AlbumModel>> getHotAlbums({int limit = 5}) async {
    try {
      // Bước 1: Lấy tất cả các album
      List<AlbumModel> allAlbums = await albumRemoteDataSource.getAllAlbums();

      // Bước 2: Lấy tất cả các bài hát
      QuerySnapshot songsSnapshot = await firestore.collection('Songs').get();
      List<SongModel> allSongs = songsSnapshot.docs.map((doc) => SongModel.fromDocument(doc)).toList();

      // Bước 3: Tính tổng playCount cho từng album
      Map<String, int> albumPlayCounts = {};
      for (var album in allAlbums) {
        albumPlayCounts[album.id] = 0;
      }

      for (var song in allSongs) {
        if (albumPlayCounts.containsKey(song.albumId)) {
          albumPlayCounts[song.albumId] = albumPlayCounts[song.albumId]! + song.playCount;
        }
      }

      // Bước 4: Gán tổng playCount vào AlbumModel
      List<AlbumWithPlayCount> albumsWithPlayCount = allAlbums.map((album) {
        return AlbumWithPlayCount(
          album: album,
          totalPlayCount: albumPlayCounts[album.id] ?? 0,
        );
      }).toList();

      // Bước 5: Sắp xếp các album theo tổng playCount giảm dần
      albumsWithPlayCount.sort((a, b) => b.totalPlayCount.compareTo(a.totalPlayCount));

      // Bước 6: Lấy top 'limit' album
      List<AlbumModel> hotAlbums = albumsWithPlayCount
          .take(limit)
          .map((item) => item.album)
          .toList();

      return hotAlbums;
    } catch (e) {
      throw Exception("Get Hot Albums Failed: $e");
    }
  }
  /// Lấy Top 5 Hot Artists (tổng playCount nhiều nhất)
  @override
  Future<List<ArtistModel>> getHotArtists({int limit = 5}) async {
    try {
      // Bước 1: Lấy tất cả các nghệ sĩ
      List<ArtistModel> allArtists = await artistRemoteDataSource.getAllArtists();

      // Bước 2: Lấy tất cả các bài hát
      QuerySnapshot songsSnapshot = await firestore.collection('Songs').get();
      List<SongModel> allSongs = songsSnapshot.docs.map((doc) => SongModel.fromDocument(doc)).toList();

      // Bước 3: Tính tổng playCount cho từng nghệ sĩ
      Map<String, int> artistPlayCounts = {};
      for (var artist in allArtists) {
        artistPlayCounts[artist.id] = 0;
      }

      for (var song in allSongs) {
        if (artistPlayCounts.containsKey(song.artistId)) {
          artistPlayCounts[song.artistId] = artistPlayCounts[song.artistId]! + song.playCount;
        }
      }

      // Bước 4: Gán tổng playCount vào ArtistModel
      List<ArtistWithPlayCount> artistsWithPlayCount = allArtists.map((artist) {
        return ArtistWithPlayCount(
          artist: artist,
          totalPlayCount: artistPlayCounts[artist.id] ?? 0,
        );
      }).toList();

      // Bước 5: Sắp xếp các nghệ sĩ theo tổng playCount giảm dần
      artistsWithPlayCount.sort((a, b) => b.totalPlayCount.compareTo(a.totalPlayCount));

      // Bước 6: Lấy top 'limit' nghệ sĩ
      List<ArtistModel> hotArtists = artistsWithPlayCount
          .take(limit)
          .map((item) => item.artist)
          .toList();

      return hotArtists;
    } catch (e) {
      throw Exception("Get Hot Artists Failed: $e");
    }
  }

  @override
  Future<SongModel> getSongById(String songId) async {
    return songRemoteDataSource.getSong(songId);
  }

  @override
  Future<AlbumModel> getAlbumById(String albumId) async{
    return albumRemoteDataSource.getAlbum(albumId);
  }

  @override
  Future<ArtistModel> getArtistById(String artistId) async{
    return artistRemoteDataSource.getArtist(artistId);
  }
}