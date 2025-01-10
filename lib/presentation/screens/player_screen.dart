// lib/presentation/screens/song_player_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';
import '../../../injection_container.dart';

class SongPlayerScreen extends StatelessWidget {
  final SongEntity song;

  const SongPlayerScreen({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerCubit>(
      create: (_) => sl<PlayerCubit>()..togglePlayPause(song),
      child: Scaffold(
        appBar: AppBar(
          title: Text(song.songName),
        ),
        body: PlayerView(song: song),
      ),
    );
  }
}

class PlayerView extends StatelessWidget {
  final SongEntity song;

  const PlayerView({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, AppPlayerState>(
      builder: (context, state) {
        if (state is PlayerLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PlayerPlaying || state is PlayerPaused) {
          final isPlaying = state is PlayerPlaying;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Hiển thị Tiêu đề bài hát và Nghệ sĩ
                Text(
                  song.songName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  song.artistId, // Thay bằng tên nghệ sĩ nếu có
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                // Nút Play/Pause
                IconButton(
                  iconSize: 64,
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                  onPressed: () {
                    context.read<PlayerCubit>().togglePlayPause(song);
                  },
                ),
              ],
            ),
          );
        } else if (state is PlayerError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        } else {
          return const Center(child: Text('Nhấn vào nút Play để bắt đầu bài hát.'));
        }
      },
    );
  }
}
