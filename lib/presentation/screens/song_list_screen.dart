// lib/presentation/screens/song_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'player_screen.dart';
import '../../../injection_container.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cung cấp SongInfoCubit cho màn hình này
    return BlocProvider<SongInfoCubit>(
      create: (_) => sl<SongInfoCubit>()..fetchHotSongs(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bài Hát Nổi Bật'),
        ),
        body: BlocBuilder<SongInfoCubit, SongInfoState>(
          builder: (context, state) {
            if (state is SongInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SongHotSongsLoaded) {
              final songs = state.songs;
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return ListTile(
                    leading: song.songImageUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        song.songImageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 50),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    )
                        : const Icon(Icons.music_note, size: 50),
                    title: Text(
                      song.songName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(song.artistId), // Thay bằng tên nghệ sĩ nếu có
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.play_circle_filled,
                        size: 40,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongPlayerScreen(song: song),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is SongError) {
              return Center(child: Text('Lỗi: ${state.error}'));
            }
            return const Center(child: Text('Không có bài hát nào.'));
          },
        ),
      ),
    );
  }
}
