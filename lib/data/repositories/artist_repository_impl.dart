import '../../domain/entities/artist_entity.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/artist_repository.dart';
import '../datasources/artist_remote_datasource.dart';
import '../datasources/song_remote_datasource.dart'; // Thêm import này

class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistRemoteDataSource remoteDataSource;
  final SongRemoteDataSource songRemoteDataSource; // Thêm thuộc tính này

  ArtistRepositoryImpl({
    required this.remoteDataSource,
    required this.songRemoteDataSource, // Cập nhật constructor
  });

  @override
  Future<List<ArtistEntity>> getAllArtists() async {
    try {
      // Lấy dữ liệu từ remoteDataSource
      final artistModels = await remoteDataSource.getAllArtists();

      // Chuyển đổi từ ArtistModel sang ArtistEntity nếu cần thiết
      return artistModels.map((model) => ArtistEntity(
        id: model.id,
        artistName: model.artistName,
        artistImageUrl: model.artistImageUrl,
        followers: model.followers,
        description: model.description,
      )).toList();
    } catch (e) {
      throw Exception("Không thể lấy danh sách nghệ sĩ: $e");
    }
  }

  @override
  Future<void> increaseFollower(String artistId) async {
    try {
      // Lấy thông tin nghệ sĩ từ remote
      final artistModels = await remoteDataSource.getAllArtists();
      final artistModel = artistModels.firstWhere((model) => model.id == artistId);

      // Tăng số lượng follower
      final updatedArtist = artistModel.copyWith(followers: artistModel.followers + 1);

      // Cập nhật dữ liệu lên Firestore
      await remoteDataSource.addOrUpdateArtist(updatedArtist);
    } catch (e) {
      throw Exception("Không thể tăng số người theo dõi: $e");
    }
  }

  @override
  Future<void> decreaseFollower(String artistId) async {
    try {
      // Lấy thông tin nghệ sĩ từ remote
      final artistModels = await remoteDataSource.getAllArtists();
      final artistModel = artistModels.firstWhere((model) => model.id == artistId);

      // Giảm số lượng follower
      final updatedArtist = artistModel.copyWith(
        followers: artistModel.followers > 0 ? artistModel.followers - 1 : 0,
      );

      // Cập nhật dữ liệu lên Firestore
      await remoteDataSource.addOrUpdateArtist(updatedArtist);
    } catch (e) {
      throw Exception("Không thể giảm số người theo dõi: $e");
    }
  }

  @override
  Future<List<SongEntity>> getSongsByArtistId(String artistId) async {
    try {

      // Lấy danh sách bài hát từ songRemoteDataSource
      final songModels = await songRemoteDataSource.getSongsByArtist(artistId);

      // Chuyển đổi từ SongModel sang SongEntity nếu cần thiết
      return songModels.map((model) => SongEntity(
        id: model.id,
        songName: model.songName,
        songImageUrl: model.songImageUrl,
        artistId: model.artistId,
        albumId: model.albumId,
        genre: model.genre,
        releaseDate: model.releaseDate,
        lyric: model.lyric,
        audioUrl: model.audioUrl,
        // Lưu ý: Nếu bạn muốn bao gồm playCount, hãy thêm nó vào SongEntity
      )).toList();
    } catch (e) {
      throw Exception("Không thể lấy bài hát cho nghệ sĩ $artistId: $e");
    }
  }
}
