import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';
import 'package:spotifo/presentation/cubit/queue/queue_cubit.dart';
import 'package:spotifo/presentation/cubit/queue/queue_state.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';
import '../../../injection_container.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({Key? key}) : super(key: key);

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
        appBar: AppBar(
          title: const Text("Now Playing & Queue"),
          actions: [
            IconButton(
              icon: const Icon(Icons.shuffle),
              onPressed: () {
                context.read<QueueCubit>().shuffleQueueSongs();
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                context
                    .read<QueueCubit>()
                    .playNextInQueue(context.read<PlayerCubit>());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Hiển thị bài hát đang phát
            BlocBuilder<PlayerCubit, AppPlayerState>(
              builder: (context, state) {
                if (state is PlayerPlaying || state is PlayerPaused) {
                  final currentSong = (state as dynamic).currentSong;
                  if (currentSong != null) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Now Playing",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          currentSong.songImageUrl != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              currentSong.songImageUrl!,
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          )
                              : const Icon(Icons.music_note, size: 180),
                          const SizedBox(height: 16),
                          Text(
                            currentSong.songName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            currentSong.artistId,
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
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
                                icon: Icon(
                                  state is PlayerPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                ),
                                iconSize: 64,
                                onPressed: () {
                                  context
                                      .read<PlayerCubit>()
                                      .togglePlayPause(currentSong);
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
                              final updatedQueue =
                              List<SongEntity>.from(queue);
                              final song = updatedQueue.removeAt(oldIndex);
                              updatedQueue.insert(newIndex, song);

                              // Cập nhật trạng thái hàng đợi trong QueueCubit
                              context
                                  .read<QueueCubit>()
                                  .updateQueueSongs(updatedQueue);

                              // Kiểm tra bài hát hiện tại và cập nhật index
                              final currentSong =
                                  (context.read<PlayerCubit>().state
                                  as PlayerPlaying)
                                      .currentSong;
                              if (currentSong != null &&
                                  updatedQueue.contains(currentSong)) {
                                final currentIndex =
                                updatedQueue.indexOf(currentSong);
                                context
                                    .read<QueueCubit>()
                                    .updateCurrentIndex(currentIndex);
                              }
                            },
                            children: queue
                                .map((song) => ListTile(
                              key: ValueKey(song.id),
                              leading: song.songImageUrl != null
                                  ? ClipRRect(
                                borderRadius:
                                BorderRadius.circular(8),
                                child: Image.network(
                                  song.songImageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : const Icon(Icons.music_note,
                                  size: 50),
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
                                context
                                    .read<QueueCubit>()
                                    .selectAndPlaySong(song,
                                    context.read<PlayerCubit>());
                              },
                            ))
                                .toList(),
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
          ],
        ),
      ),
    );
  }
}
