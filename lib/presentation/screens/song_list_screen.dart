import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';
import 'package:spotifo/presentation/screens/player/mini_player.dart';
import 'player/player_screen.dart';
import '../../../injection_container.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';


class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SongInfoCubit>(
          create: (_) => sl<SongInfoCubit>()..fetchHotSongs(),
        ),
        BlocProvider<PlayerCubit>.value(
          value: sl<PlayerCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bài Hát Nổi Bật'),
        ),
        body: Stack(
          children: [
            BlocBuilder<SongInfoCubit, SongInfoState>(
              builder: (context, state) {
                if (state is SongInfoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SongHotSongsLoaded) {
                  final songs = state.songs;
                  return BlocBuilder<PlayerCubit, AppPlayerState>(
                    builder: (context, playerState) {
                      return ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          bool isPlaying = playerState is PlayerPlaying &&
                              playerState.currentSong.id == song.id;

                          return ListTile(
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
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(song.artistId),
                            trailing: IconButton(
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                size: 40,
                                color: isPlaying ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () {
                                context.read<PlayerCubit>().togglePlayPause(song);
                              },
                            ),
                            onTap: () {
                              context.read<PlayerCubit>().listenToPositionStream();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayerView(song: song),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                } else if (state is SongError) {
                  return Center(child: Text('Lỗi: \${state.error}'));
                }
                return const Center(child: Text('Không có bài hát nào.'));
              },
            ),

            // Mini Player
            BlocBuilder<PlayerCubit, AppPlayerState>(
              builder: (context, state) {
                if (state is PlayerPlaying) {
                  final song = state.currentSong;
                  final isPlaying = true;
                  return MiniPlayer(
                    currentSong: song,
                    isPlaying: isPlaying,
                  );
                } else if (state is PlayerPaused) {
                  final song = state.currentSong;
                  final isPlaying = false;
                  return MiniPlayer(
                    currentSong: song,
                    isPlaying: isPlaying,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
