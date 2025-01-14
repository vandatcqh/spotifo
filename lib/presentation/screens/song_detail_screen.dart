import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favoriteSongs/favorite_songs_cubit.dart';
import '../cubit/favoriteSongs/favorite_songs_state.dart';
import '../../../domain/entities/song_entity.dart';

class SongDetailScreen extends StatelessWidget {
  final SongEntity song;

  const SongDetailScreen({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.songName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ảnh bài hát
            if (song.songImageUrl != null && song.songImageUrl!.isNotEmpty)
              Image.network(
                song.songImageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              const Icon(Icons.music_note, size: 200),
            const SizedBox(height: 16),

            // Tên bài hát
            Text(
              song.songName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Mô tả
            if (song.lyric != null)
              Text(song.lyric!, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 16),

            // Nút thích / bỏ thích
            BlocConsumer<FavoriteSongsCubit, FavoriteSongsState>(
              listener: (context, state) {
                if (state is FavoriteSongsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is FavoriteSongsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FavoriteSongsLoaded) {
                  final favoriteSongs = state.favoriteSongs;
                  final isFavorite = favoriteSongs.any((s) => s.id == song.id);

                  return ElevatedButton.icon(
                    onPressed: () {
                      final favoriteSongsCubit = context.read<FavoriteSongsCubit>();
                      if (isFavorite) {
                        favoriteSongsCubit.removeFavoriteSong(song.id);
                      } else {
                        favoriteSongsCubit.addFavoriteSong(song.id);
                      }
                    },
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    label: Text(isFavorite ? 'Bỏ Thích' : 'Thích'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFavorite ? Colors.red : Colors.blue,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
