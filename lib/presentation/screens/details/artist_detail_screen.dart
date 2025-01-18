// presentation/screens/artist_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/artist/artist_cubit.dart'; // Đảm bảo đường dẫn đúng
import '../../cubit/artist/artist_state.dart';
import '../../cubit/favoriteArtists/favorite_artists_cubit.dart';
import '../../../../domain/entities/artist_entity.dart';
import '../../../../domain/entities/song_entity.dart';

class ArtistDetailScreen extends StatefulWidget {
  final ArtistEntity artist;

  const ArtistDetailScreen({Key? key, required this.artist}) : super(key: key);

  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  late ArtistEntity _artist;

  @override
  void initState() {
    super.initState();
    _artist = widget.artist;
    // Gọi fetchSongsByArtistId khi màn hình được khởi tạo
    context.read<ArtistCubit>().fetchSongsByArtistId(_artist.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_artist.artistName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Đảm bảo có thể cuộn nếu nội dung dài
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị hình ảnh nghệ sĩ
              if (_artist.artistImageUrl != null && _artist.artistImageUrl!.isNotEmpty)
                Image.network(
                  _artist.artistImageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                const Icon(Icons.person, size: 200),
              const SizedBox(height: 16),

              // Tên nghệ sĩ
              Text(
                _artist.artistName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Hiển thị số lượng followers
              BlocBuilder<FavoriteArtistsCubit, FavoriteArtistsState>(
                builder: (context, state) {
                  if (state is FavoriteArtistsLoaded) {
                    final updatedArtist = state.favoriteArtists.firstWhere(
                          (a) => a.id == _artist.id,
                      orElse: () => _artist,
                    );
                    return Text(
                      'Followers: ${updatedArtist.followers}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    );
                  }
                  return Text(
                    'Followers: ${_artist.followers}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  );
                },
              ),
              const SizedBox(height: 8),

              // Mô tả nghệ sĩ
              if (_artist.description != null)
                Text(
                  _artist.description!,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 16),

              // Nút Thích/Bỏ Thích
              BlocConsumer<FavoriteArtistsCubit, FavoriteArtistsState>(
                listener: (context, state) {
                  if (state is FavoriteArtistsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is FavoriteArtistsLoaded) {
                    // Cập nhật lại số lượng followers khi trạng thái được cập nhật
                    final updatedArtist = state.favoriteArtists.firstWhere(
                          (a) => a.id == _artist.id,
                      orElse: () => _artist,
                    );
                    setState(() {
                      _artist = updatedArtist;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is FavoriteArtistsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FavoriteArtistsLoaded) {
                    final favoriteArtists = state.favoriteArtists;
                    final isFavorite = favoriteArtists.any((a) => a.id == _artist.id);

                    return ElevatedButton.icon(
                      onPressed: () {
                        final favoriteArtistsCubit = context.read<FavoriteArtistsCubit>();
                        if (isFavorite) {
                          favoriteArtistsCubit.removeFavoriteArtist(_artist);
                        } else {
                          favoriteArtistsCubit.addFavoriteArtist(_artist);
                        }
                      },
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFavorite ? 'Bỏ Thích' : 'Thích'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorite ? Colors.red : Colors.blue,
                      ),
                    );
                  } else if (state is FavoriteArtistsError) {
                    return const Center(child: Text('Không thể tải danh sách nghệ sĩ yêu thích.'));
                  }
                  return const SizedBox.shrink(); // Hiển thị trống nếu không có trạng thái liên quan
                },
              ),
              const SizedBox(height: 24),

              // Tiêu đề danh sách bài hát
              const Text(
                'Danh Sách Bài Hát',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Hiển thị danh sách bài hát
              BlocBuilder<ArtistCubit, ArtistState>(
                builder: (context, state) {
                  if (state is ArtistLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SongsLoaded) {
                    final songs = state.songs;
                    if (songs.isEmpty) {
                      return const Center(child: Text('Không có bài hát nào.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true, // Để ListView không chiếm toàn bộ không gian
                      physics: const NeverScrollableScrollPhysics(), // Ngăn ListView cuộn riêng
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return ListTile(
                          leading: song.songImageUrl != null && song.songImageUrl!.isNotEmpty
                              ? Image.network(
                            song.songImageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.music_note, size: 50),
                          title: Text(song.songName),
                          subtitle: Text('Thể loại: ${song.genre}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow),
                              //Text(song.playCount.toString()),
                            ],
                          ),
                          onTap: () {
                            // Xử lý khi nhấn vào bài hát, ví dụ: phát nhạc
                          },
                        );
                      },
                    );
                  } else if (state is ArtistError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink(); // Hiển thị trống nếu không có trạng thái liên quan
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
