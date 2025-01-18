import 'package:flutter/material.dart';

import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';
import 'package:spotifo/presentation/cubit/queue/queue_cubit.dart';
import 'package:spotifo/presentation/cubit/queue/queue_state.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';
import '../../../core/app_export.dart';
import '../../../../injection_container.dart';


class QueueScreen extends StatefulWidget {
  final SongEntity song;

  const QueueScreen({super.key, required this.song});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
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
        BlocProvider<QueueCubit>.value(
          value: sl<QueueCubit>(),
        ),
        BlocProvider<PlayerCubit>.value(
          value: sl<PlayerCubit>(),
        ),
        BlocProvider<SongInfoCubit>(
          create: (_) => sl<SongInfoCubit>()..fetchHotSongs(),
        ),
      ],
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: Column(
          children: [
            // Hiển thị bài hát đang phát
            BlocBuilder<PlayerCubit, AppPlayerState>(
              builder: (context, state) {

                Duration currentPosition = (state is PlayerPlaying ||
                    state is PlayerPaused)
                    ? state.position
                    : Duration.zero;
                Duration totalDuration = (state is PlayerPlaying ||
                    state is PlayerPaused)
                    ? state.totalDuration
                    : Duration.zero;

                bool isPlaying = (state is PlayerPlaying) ? true : false;

                if (state is PlayerPlaying || state is PlayerPaused) {
                  final currentSong = (state as dynamic).currentSong;
                  if (currentSong != null) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Playback slider
                          Slider(
                            value: currentPosition.inSeconds.toDouble(),
                            max: totalDuration.inSeconds > 0 ? totalDuration.inSeconds.toDouble() : 9999.0,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white38,
                            onChanged: (value) {

                              if(Duration(seconds: value.toInt()) >= totalDuration)
                              {
                                print("Play next song ?");
                                context
                                    .read<QueueCubit>()
                                    .playNextInQueue(
                                    context.read<PlayerCubit>());
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
                                  isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  size: 7.h,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final playerCubit = context.read<PlayerCubit>();
                                  if (currentPosition >= totalDuration && !playerCubit.isFirstLoad) {
                                    // Replay the song
                                    playerCubit.replay();
                                  } else {
                                    context.read<PlayerCubit>().listenToPositionStream();
                                    playerCubit.togglePlayPause(currentSong);
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
                                    context.read<PlayerCubit>().togglePlayPause(currentSong);
                                  }

                                  playerCubit.seekTo(newPosition > totalDuration ? totalDuration : newPosition);

                                }
                                    : null, // Disable button when the song is not playing
                              ),
                            ],
                          ),

                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.skip_previous),
                                iconSize: 48,
                                onPressed: () {
                                  context
                                      .read<QueueCubit>()
                                      .playPreviousInQueue(
                                      context.read<PlayerCubit>());
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.shuffle),
                                onPressed: () {
                                  context.read<QueueCubit>().shuffleQueueSongs();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.skip_next),
                                iconSize: 48,
                                onPressed: () {
                                  context
                                      .read<QueueCubit>()
                                      .playNextInQueue(
                                      context.read<PlayerCubit>());
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                }
                return const Center(child: Text("No song playing"));
              },
            ),
            Divider(),
            // Hiển thị danh sách queue
            Expanded(
              child: BlocBuilder<SongInfoCubit, SongInfoState>(
                builder: (context, songState) {
                  if (songState is SongHotSongsLoaded) {
                    final songs = songState.songs;

                    // Tự động thêm bài hát vào queue nếu chưa có
                    final queueCubit = context.read<QueueCubit>();
                    if (songs.isNotEmpty && queueCubit.state is QueueInitial) {
                      queueCubit.addSongsToQueue(songs);
                    }

                    return BlocBuilder<QueueCubit, QueueState>(
                      builder: (context, queueState) {
                        if (queueState is QueueLoaded) {
                          final queue = queueState.queue;

                          return ReorderableListView(
                            onReorder: (oldIndex, newIndex) {
                              if (newIndex > oldIndex) newIndex--;
                              final updatedQueue = List<SongEntity>.from(queue);
                              final song = updatedQueue.removeAt(oldIndex);
                              updatedQueue.insert(newIndex, song);

                              // Update queue in QueueCubit
                              context.read<QueueCubit>().updateQueueSongs(updatedQueue);

                              // Check and update current song index
                              final currentSong = (context.read<PlayerCubit>().state as PlayerPlaying).currentSong;
                              if (updatedQueue.contains(currentSong)) {
                                final currentIndex = updatedQueue.indexOf(currentSong);
                                context.read<QueueCubit>().updateCurrentIndex(currentIndex);
                              }
                            },
                            children: queue.map((song) {
                              // Get the current song from the PlayerCubit
                              final isPlaying = context.read<PlayerCubit>().state is PlayerPlaying &&
                                  (context.read<PlayerCubit>().state as PlayerPlaying).currentSong.id == song.id;

                              return Container(
                                key: ValueKey(song.id),
                                color: isPlaying ? Colors.blue.shade100 : Colors.transparent, // Change background color
                                child: ListTile(
                                  leading: song.songImageUrl != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      song.songImageUrl!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.music_note, size: 50),
                                  title: Text(
                                    song.songName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    song.artistId,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  trailing: const Icon(Icons.drag_handle),
                                  onTap: () {
                                    context.read<QueueCubit>().selectAndPlaySong(
                                      song,
                                      context.read<PlayerCubit>(),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          );

                        }
                        return const Center(child: Text("Queue is empty"));
                      },
                    );
                  } else if (songState is SongInfoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text("Failed to fetch songs"));
                  }
                },
              ),
            ),

            // Playback slider

          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
