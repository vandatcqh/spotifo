import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favoriteSongs/favorite_songs_cubit.dart';
import '../cubit/favoriteSongs/favorite_songs_state.dart';
import 'add_song_screen.dart';
import 'song_detail_screen.dart';

class FavoriteSongsScreen extends StatelessWidget {
  const FavoriteSongsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chú ý: bạn nên gọi fetchFavoriteSongs() trong initState của StatefulWidget
    // hoặc khi khởi tạo BlocProvider. Ví dụ:
    // BlocProvider.of<FavoriteSongsCubit>(context).fetchFavoriteSongs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Bài Hát Yêu Thích'),
      ),
      body: BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
        builder: (context, state) {
          if (state is FavoriteSongsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteSongsLoaded) {
            final favoriteSongs = state.favoriteSongs;
            if (favoriteSongs.isEmpty) {
              return const Center(child: Text('Không có bài hát yêu thích nào.'));
            }
            return ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = favoriteSongs[index];
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
                  subtitle: Text('Lượt nghe:'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SongDetailScreen(song: song),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is FavoriteSongsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Điều hướng sang màn hình "Thêm bài hát yêu thích"
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<FavoriteSongsCubit>(context),
                child: const AddSongScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
