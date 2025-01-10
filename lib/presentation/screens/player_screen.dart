import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';

class SongPlayerScreen extends StatelessWidget {
  final SongEntity song;

  const SongPlayerScreen({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.songName),
      ),
      body: PlayerView(song: song),
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
        bool isPlaying = state is PlayerPlaying && state.currentSong.id == song.id;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hiển thị hình ảnh bài hát
              song.songImageUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  song.songImageUrl!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(Icons.music_note, size: 200),
              const SizedBox(height: 20),
              // Hiển thị tên bài hát
              Text(
                song.songName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Hiển thị tên nghệ sĩ
              Text(
                song.artistId,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Nút Play/Pause
              IconButton(
                iconSize: 64,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                ),
                onPressed: () {
                  context.read<PlayerCubit>().togglePlayPause(song);
                },
              ),
              const SizedBox(height: 20),
              if (state is PlayerError)
                Text(
                  'Lỗi: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        );
      },
    );
  }
}
