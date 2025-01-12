import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../../core/app_export.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';

import '../../common_widgets/volume_control.dart';

class PlayerView extends StatefulWidget {
  final SongEntity song;

  const PlayerView({super.key, required this.song});

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
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
        bool isPlaying = state is PlayerPlaying && state.currentSong.id == widget.song.id;

        Duration currentPosition = (state is PlayerPlaying || state is PlayerPaused)
            ? state.position
            : Duration.zero;
        Duration totalDuration = (state is PlayerPlaying || state is PlayerPaused)
            ? state.totalDuration
            : Duration.zero;

        return Scaffold(
          backgroundColor: _backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Collapse arrow
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(height: 2.h),

                      // Album cover
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: widget.song.songImageUrl != null
                              ? Image.network(
                            widget.song.songImageUrl!,
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                          )
                              : Icon(Icons.music_note,
                              size: 60.w, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Song name and artist
                      Text(
                        widget.song.songName,
                        style: TextStyle(
                          fontSize: 3.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        widget.song.artistId,
                        style: TextStyle(
                          fontSize: 2.h,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),

                      // Playback slider
                      Slider(
                        value: currentPosition.inSeconds.toDouble(),
                        max: totalDuration.inSeconds > 0 ? totalDuration.inSeconds.toDouble() : 1.0,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white38,
                        onChanged: (value) {

                          if(currentPosition >= totalDuration)
                            {
                              context.read<PlayerCubit>().togglePlayPause(widget.song);
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
                              style: TextStyle(color: Colors.white70, fontSize: 2.h),
                            ),
                            Text(
                              _formatDuration(totalDuration),
                              style: TextStyle(color: Colors.white70, fontSize: 2.h),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),

// Speed modifier buttons with Heart and Three-Dot Menu Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          // Speed Modifier Button with Popup Options
                          PopupMenuButton<double>(
                            icon: const Icon(Icons.speed, color: Colors.white), // Use an icon for the button
                            onSelected: (speed) {
                              // Handle speed adjustment logic
                              // For example:
                              print("Selected playback speed: $speed");
                            },
                            itemBuilder: (context) => [0.25, 0.5, 1.0, 1.5, 2.0].map((speed) {
                              return PopupMenuItem<double>(
                                value: speed,
                                child: Text(
                                  '${speed}x', // Display speed with "x" as in "1.0x"
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          ),


                          // Heart Button
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {
                              // Placeholder for favorite action
                            },
                          ),

                          // Three-Dot Menu Button
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {
                              // Placeholder for more options
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Playback controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Backward button
                          IconButton(
                            icon: Icon(Icons.replay_10, size: 4.h),
                            color: (isPlaying && currentPosition < totalDuration) ? Colors.white : Colors.grey,
                            onPressed: (isPlaying && currentPosition < totalDuration)
                                ? () {
                              final playerCubit = context.read<PlayerCubit>();
                              final newPosition = currentPosition - Duration(seconds: 10);
                              playerCubit.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
                            }
                                : null, // Disable button when the song is not playing
                          ),

                          // Play/Pause or Replay button
                          IconButton(
                            icon: Icon(
                              currentPosition >= totalDuration && !context.read<PlayerCubit>().isFirstLoad
                                  ? Icons.replay // Show replay button if not on first load and song has finished
                                  : (isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                              size: 7.h,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final playerCubit = context.read<PlayerCubit>();
                              if (currentPosition >= totalDuration && !playerCubit.isFirstLoad) {
                                // Replay the song
                                playerCubit.replay();
                              } else {
                                // Toggle play/pause
                                playerCubit.togglePlayPause(widget.song);
                              }
                            },
                          ),


                          // Forward button
                          IconButton(
                            icon: Icon(Icons.forward_10, size: 4.h),
                            color: (isPlaying && currentPosition < totalDuration) ? Colors.white : Colors.grey,
                            onPressed: (isPlaying && currentPosition < totalDuration)
                                ? () {
                              final playerCubit = context.read<PlayerCubit>();
                              final newPosition = currentPosition + Duration(seconds: 10);
                              if(newPosition >= totalDuration)
                              {
                                context.read<PlayerCubit>().togglePlayPause(widget.song);
                              }

                              playerCubit.seekTo(newPosition > totalDuration ? totalDuration : newPosition);

                            }
                                : null, // Disable button when the song is not playing
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Volume slider
                      const VolumeControl(), // Include the VolumeControl widget
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
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
