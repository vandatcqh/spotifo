import 'package:flutter/material.dart';
import 'package:spotifo/core/app_export.dart';
import 'package:spotifo/presentation/screens/player/mini_player.dart';
import 'package:spotifo/presentation/screens/player/player_screen.dart';
import '../../../injection_container.dart';
import '../cubit/player/player_cubit.dart';
import '../cubit/player/player_state.dart';
import '../cubit/song/song_cubit.dart';
import '../cubit/song/song_state.dart';

class GenreSongsScreen extends StatelessWidget {
  final String genreName;

  const GenreSongsScreen({
    super.key,
    required this.genreName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SongInfoCubit>(
      create: (_) => sl<SongInfoCubit>()..fetchSongsByGenre(genreName),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bài hát thể loại $genreName'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlphaD(0.5),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<SongInfoCubit, SongInfoState>(
                  builder: (context, state) {
                    if (state is SongInfoLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SongByGenreLoaded) {
                      final songs = state.songs;
                      if (songs.isEmpty) {
                        return Center(
                          child: Text(
                            'Chưa có bài hát nào cho thể loại "$genreName"',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return BlocBuilder<PlayerCubit, AppPlayerState>(
                        builder: (context, playerState) {
                          return ListView.builder(
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              final song = songs[index];
                              bool isPlaying = playerState is PlayerPlaying &&
                                  playerState.currentSong.id == song.id;

                              return Card(
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  leading: (song.songImageUrl != null &&
                                      song.songImageUrl!.isNotEmpty)
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
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return PlayerView(
                                          song: song,
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (state is SongError) {
                      return Center(
                        child: Text(
                          'Lỗi: ${state.error}',
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
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
