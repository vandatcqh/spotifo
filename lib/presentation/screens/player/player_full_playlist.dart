import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotifo/presentation/screens/player/player_full_lyric.dart';
import 'package:spotifo/presentation/screens/player/player_screen.dart';
import '../../../core/app_export.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';

import '../../../injection_container.dart';

class PlayerFullPlaylist extends StatefulWidget {
  final SongEntity song;

  const PlayerFullPlaylist({Key? key, required this.song})
      : super(key: key);

  @override
  _PlayerFullPlaylistState createState() => _PlayerFullPlaylistState();
}

class _PlayerFullPlaylistState extends State<PlayerFullPlaylist> {
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
    return MultiBlocProvider(
        providers: [
          BlocProvider<SongInfoCubit>(
            create: (_) =>
            sl<SongInfoCubit>()
              ..fetchHotSongs(),
          ),
          BlocProvider<PlayerCubit>.value(
            value: sl<PlayerCubit>(),
          ),
        ],
        child: BlocBuilder<PlayerCubit, AppPlayerState>(
          builder: (context, state) {
            bool isPlaying = state is PlayerPlaying &&
                state.currentSong.id == widget.song.id;

            Duration currentPosition = (state is PlayerPlaying ||
                state is PlayerPaused)
                ? state.position
                : Duration.zero;
            Duration totalDuration = (state is PlayerPlaying ||
                state is PlayerPaused)
                ? state.totalDuration
                : Duration.zero;

            return Scaffold(
              backgroundColor: _backgroundColor,
              body: SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery
                        .of(context)
                        .size
                        .height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Scrollable song list
                        Expanded(
                          child: BlocBuilder<SongInfoCubit, SongInfoState>(
                            builder: (context, state) {
                              if (state is SongInfoLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is SongHotSongsLoaded) {
                                final songs = state.songs;
                                return ListView.builder(
                                  itemCount: songs.length,
                                  itemBuilder: (context, index) {
                                    final song = songs[index];
                                    return ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: song.songImageUrl != null
                                            ? Image.network(
                                          song.songImageUrl!,
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                        )
                                            : const Icon(Icons.music_note,
                                            size: 48, color: Colors.white),
                                      ),
                                      title: Text(
                                        song.songName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        song.artistId,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.play_arrow,
                                            color: Colors.white),
                                        onPressed: () {
                                          context
                                              .read<PlayerCubit>()
                                              .togglePlayPause(song);
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else if (state is SongError) {
                                return Center(
                                  child: Text(
                                    'Error: ${state.error}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                              return const Center(
                                child: Text(
                                  'No songs available.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),

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
                        SizedBox(height: 5.h),

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

                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
