import '../../domain/entities/artist_entity.dart';
import '../../domain/repositories/artist_repository.dart';
import '../datasources/artist_remote_datasource.dart';

class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistRemoteDataSource remoteDataSource;

  ArtistRepositoryImpl(this.remoteDataSource);

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
      throw Exception("Failed to fetch artists: $e");
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
      throw Exception("Failed to increase follower: $e");
    }
  }

  @override
  Future<void> decreaseFollower(String artistId) async {
    try {
      // Lấy thông tin nghệ sĩ từ remote
      final artistModels = await remoteDataSource.getAllArtists();
      final artistModel = artistModels.firstWhere((model) => model.id == artistId);

      // Giảm số lượng follower
      final updatedArtist = artistModel.copyWith(followers: artistModel.followers > 0 ? artistModel.followers - 1 : 0);

      // Cập nhật dữ liệu lên Firestore
      await remoteDataSource.addOrUpdateArtist(updatedArtist);
    } catch (e) {
      throw Exception("Failed to decrease follower: $e");
    }
  }
}
