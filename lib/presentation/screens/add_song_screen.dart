import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favoriteSongs/favorite_songs_cubit.dart';
import '../cubit/favoriteSongs/favorite_songs_state.dart';

// Ở chỗ bạn, có 1 cubit SongInfoCubit (dành cho Hot Songs).
// Nếu bạn muốn lấy "toàn bộ" bài hát, bạn có thể tạo 1 cubit khác (SongFetchAllCubit),
// hoặc tái sử dụng SongInfoCubit nếu nó có hàm fetchAllSongs().
// Mình ví dụ dưới đây tạo tạm SongAllCubit cho minh hoạ.
import '../cubit/song/song_cubit.dart';
import '../cubit/song/song_state.dart'; // Xem code bạn có sẵn

class AddSongScreen extends StatelessWidget {
  const AddSongScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Giả sử SongInfoCubit có hàm fetchHotSongs() / fetchAllSongs()
    // tuỳ theo bạn đang fetch list nào
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Bài Hát Yêu Thích'),
      ),
      body: BlocBuilder<SongInfoCubit, SongInfoState>(
        builder: (context, songState) {
          return BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
            builder: (context, favoriteState) {
              // Loading
              if (songState is SongInfoLoading || favoriteState is FavoriteSongsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // HotSongsLoaded hoặc AllSongsLoaded
              else if (songState is SongHotSongsLoaded && favoriteState is FavoriteSongsLoaded) {
                final allSongs = songState.songs;
                final favoriteSongs = favoriteState.favoriteSongs;

                // Lọc ra bài chưa yêu thích
                final availableSongs = allSongs.where((song) {
                  return !favoriteSongs.any((fav) => fav.id == song.id);
                }).toList();

                if (availableSongs.isEmpty) {
                  return const Center(
                    child: Text('Tất cả bài hát đã có trong danh sách yêu thích!'),
                  );
                }

                return ListView.builder(
                  itemCount: availableSongs.length,
                  itemBuilder: (context, index) {
                    final song = availableSongs[index];
                    return ListTile(
                      leading: (song.songImageUrl != null && song.songImageUrl!.isNotEmpty)
                          ? Image.network(
                        song.songImageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : const Icon(Icons.music_note, size: 50),
                      title: Text(song.songName),
                      subtitle: Text('Tác giả: ${song.artistId}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () async {
                          // Gọi cubit để thêm bài hát vào DS yêu thích
                          await BlocProvider.of<FavoriteSongsCubit>(context)
                              .addFavoriteSong(song.id);

                          // Quay lại màn hình trước
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              }
              // Error
              else if (songState is SongError) {
                return Center(child: Text(songState.error));
              } else if (favoriteState is FavoriteSongsError) {
                return Center(child: Text(favoriteState.message));
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
