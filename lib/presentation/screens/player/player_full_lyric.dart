import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotifo/presentation/screens/player/player_full_playlist.dart';
import 'package:spotifo/presentation/screens/player/player_screen.dart';
import '../../../core/app_export.dart';
import 'package:spotifo/domain/entities/song_entity.dart';

import '../../cubit/player/player_cubit.dart';
import '../../cubit/player/player_state.dart';

class PlayerFullLyric extends StatefulWidget {
  final SongEntity song;

  const PlayerFullLyric({Key? key, required this.song}) : super(key: key);

  @override
  _PlayerFullLyricState createState() => _PlayerFullLyricState();
}

class _PlayerFullLyricState extends State<PlayerFullLyric> {
  Color _backgroundColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _updateBackgroundColor();
  }

  Future<void> _updateBackgroundColor() async {
    if (widget.song.songImageUrl != null) {
      final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(
        NetworkImage(widget.song.songImageUrl!),
      );
      setState(() {
        _backgroundColor =
            paletteGenerator.dominantColor?.color ?? Colors.blue.shade50;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, AppPlayerState>(
      builder: (context, state) {
        bool isPlaying =
            state is PlayerPlaying && state.currentSong.id == widget.song.id;

        Duration currentPosition =
        (state is PlayerPlaying || state is PlayerPaused)
            ? state.position
            : Duration.zero;
        Duration totalDuration =
        (state is PlayerPlaying || state is PlayerPaused)
            ? state.totalDuration
            : Duration.zero;

        return Scaffold(
          backgroundColor: _backgroundColor,
          body: SafeArea(
            child: Column(
              children: [

                // Album cover
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: widget.song.songImageUrl != null
                        ? Image.network(
                      widget.song.songImageUrl!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.music_note,
                        size: 300, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),

                // Song name and artist
                Text(
                  widget.song.songName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.song.artistId,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Scrollable Lyrics Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: (widget.song.lyric ?? "No lyrics available")
                            .split(RegExp(r'[.?!]')) // Split by ".", "?", "!"
                            .map((line) => Text(
                          line.trim(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                ),

                // Playback slider
                Slider(
                  value: currentPosition.inSeconds.toDouble(),
                  max: totalDuration.inSeconds > 0
                      ? totalDuration.inSeconds.toDouble()
                      : 1.0,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white38,
                  onChanged: (value) {
                    if (currentPosition >= totalDuration) {
                      context
                          .read<PlayerCubit>()
                          .togglePlayPause(widget.song);
                    }

                    // Update the duration in real-time while dragging the slider
                    final newPosition = Duration(seconds: value.toInt());
                    context.read<PlayerCubit>().seekTo(newPosition);
                  },
                ),

                // Time labels
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(currentPosition),
                        style: TextStyle(
                            color: Colors.white70, fontSize: 2.h),
                      ),
                      Text(
                        _formatDuration(totalDuration),
                        style: TextStyle(
                            color: Colors.white70, fontSize: 2.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                // Playback controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_10, size: 4.h),
                      color: (isPlaying && currentPosition < totalDuration)
                          ? Colors.white
                          : Colors.grey,
                      onPressed: (isPlaying &&
                          currentPosition < totalDuration)
                          ? () {
                        final playerCubit = context.read<PlayerCubit>();
                        final newPosition = currentPosition -
                            const Duration(seconds: 10);
                        playerCubit.seekTo(newPosition < Duration.zero
                            ? Duration.zero
                            : newPosition);
                      }
                          : null,
                    ),
                    IconButton(
                      icon: Icon(
                        currentPosition >= totalDuration &&
                            !context.read<PlayerCubit>().isFirstLoad
                            ? Icons.replay
                            : (isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled),
                        size: 7.h,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        final playerCubit = context.read<PlayerCubit>();
                        if (currentPosition >= totalDuration &&
                            !playerCubit.isFirstLoad) {
                          playerCubit.replay();
                        } else {
                          playerCubit.togglePlayPause(widget.song);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_10, size: 4.h),
                      color: (isPlaying && currentPosition < totalDuration)
                          ? Colors.white
                          : Colors.grey,
                      onPressed: (isPlaying &&
                          currentPosition < totalDuration)
                          ? () {
                        final playerCubit = context.read<PlayerCubit>();
                        final newPosition = currentPosition +
                            const Duration(seconds: 10);
                        playerCubit.seekTo(newPosition >
                            totalDuration
                            ? totalDuration
                            : newPosition);
                      }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
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
