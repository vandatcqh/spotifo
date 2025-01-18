import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../cubit/favoriteSongs/favorite_songs_cubit.dart';
import '../../cubit/favoriteSongs/favorite_songs_state.dart';
import '../../../../domain/entities/song_entity.dart';

class SongDetailScreen extends StatelessWidget {
  final SongEntity song;

  const SongDetailScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          song.songName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Song Image
              if (song.songImageUrl != null && song.songImageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    song.songImageUrl!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const Icon(Icons.music_note, size: 200, color: Colors.grey),
              const SizedBox(height: 24),

              // Song Name
              Text(
                song.songName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Artist Name (if available)
              if (song.artistId.isNotEmpty)
                Text(
                  "Artist: ${song.artistId}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

              const SizedBox(height: 8),

              // Genre and Release Date on the same row
              if (song.releaseDate != null || song.genre.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (song.genre.isNotEmpty)
                      Text(
                        "Genre: ${song.genre}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    if (song.genre.isNotEmpty && song.releaseDate != null)
                       SizedBox(width: 5.w),
                    if (song.releaseDate != null)
                      Text(
                        song.releaseDate!.toLocal().toString().split(' ')[0],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),

              const SizedBox(height: 16),

              // Song Lyrics (if available)
              if (song.lyric != null && song.lyric!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlphaD(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 200, // Limit height for scrolling
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: song.lyric!
                          .split(RegExp(r'[.?!]')) // Split by '.', '?', '!'
                          .map((line) => Text(
                        line.trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ))
                          .toList(),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Favorite Button
              BlocConsumer<FavoriteSongsCubit, FavoriteSongsState>(
                listener: (context, state) {
                  if (state is FavoriteSongsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
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
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      label: Text(
                        isFavorite ? 'Bỏ Thích' : 'Thích',
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorite ? Colors.red : Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
