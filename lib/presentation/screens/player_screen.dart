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
    final playerCubit = context.read<PlayerCubit>();

    // Gọi _listenToPositionStream để đảm bảo trạng thái được cập nhật
    playerCubit.listenToPositionStream();

    return BlocProvider<PlayerCubit>.value(
      value: sl<PlayerCubit>(), // Sử dụng PlayerCubit singleton
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
        bool isPlaying = state is PlayerPlaying && state.currentSong.id == song.id;

        Duration currentPosition = (state is PlayerPlaying || state is PlayerPaused)
            ? state.position
            : Duration.zero;
        Duration totalDuration = (state is PlayerPlaying || state is PlayerPaused)
            ? state.totalDuration
            : Duration.zero;

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
              // Thanh kéo
              Slider(
                value: currentPosition.inSeconds.toDouble(),
                max: totalDuration.inSeconds.toDouble(),
                onChanged: (value) {
                  final newPosition = Duration(seconds: value.toInt());
                  context.read<PlayerCubit>().seekTo(newPosition);
                },
              ),
              // Hiển thị thời gian
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(currentPosition)),
                  Text(_formatDuration(totalDuration)),
                ],
              ),
              const SizedBox(height: 20),
              // Nút Play/Pause
              IconButton(
                iconSize: 64,
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                ),
                onPressed: () {
                  context.read<PlayerCubit>().togglePlayPause(song);
                },
              ),
              const SizedBox(height: 20),
              // Hiển thị lỗi
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
