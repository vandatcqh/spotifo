import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/core/app_export.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';
import 'package:spotifo/presentation/util/hash_gradient.dart';
import '../../../injection_container.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';

import '../../common_widgets/custom_bottom_bar.dart';
import '../player/mini_player.dart';
import '../player/player_screen.dart';
import '../song_list_screen.dart';

// Thêm import cho GenreCubit & GenreState
import '../../cubit/genre/genre_cubit.dart';
import '../../cubit/genre/genre_state.dart';

// Import màn hình hiển thị danh sách bài hát theo genre
import '../genre_song_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        // Thêm GenreCubit
        BlocProvider<GenreCubit>(
          create: (_) => sl<GenreCubit>()..fetchGenres(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Suggested For You Section
                    _buildBoxedSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "Suggested For You",
                            onIconPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SongListScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2.h),
                          BlocBuilder<SongInfoCubit, SongInfoState>(
                            builder: (context, state) {
                              if (state is SongHotSongsLoaded) {
                                final songs = state.songs;
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: songs.map((song) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 3.w),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              child: Image.network(
                                                song.songImageUrl ?? '',
                                                width: 20.w,
                                                height: 20.w,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    width: 20.w,
                                                    height: 20.w,
                                                    color: Colors.grey.shade300,
                                                    child: const Icon(
                                                      Icons.music_note,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 1.h),
                                            Text(
                                              song.songName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.sp,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              song.artistId,
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // By Genre Section
                    _buildBoxedSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "By Genre",
                            onIconPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SongListScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2.h),

                          // BlocBuilder để hiển thị danh sách thể loại
                          BlocBuilder<GenreCubit, GenreState>(
                            builder: (context, genreState) {
                              if (genreState is GenreLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (genreState is GenreLoaded) {
                                final genres = genreState.genres;
                                // genres là danh sách các String (tên thể loại)
                                return Wrap(
                                  spacing: 4.w,
                                  runSpacing: 2.h,
                                  children: genres.map((genre) {
                                    // Bạn có thể tuỳ chọn cách gán màu ở đây
                                    return _buildGenreChip(
                                      context,
                                      genre,
                                      Colors.purple,
                                    );
                                  }).toList(),
                                );
                              } else if (genreState is GenreError) {
                                return Center(
                                  child: Text(
                                    'Lỗi tải thể loại: ${genreState.message}',
                                  ),
                                );
                              }
                              // GenreInitial hoặc những trường hợp khác
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Top Charts Section
                    _buildBoxedSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "Top Charts",
                            onIconPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SongListScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2.h),
                          BlocBuilder<SongInfoCubit, SongInfoState>(
                            builder: (context, state) {
                              if (state is SongInfoLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is SongHotSongsLoaded) {
                                final songs =
                                state.songs.take(5).toList(); // Hiển thị 5 bài
                                return BlocBuilder<PlayerCubit, AppPlayerState>(
                                  builder: (context, playerState) {
                                    return Column(
                                      children: songs.map((song) {
                                        bool isPlaying =
                                            playerState is PlayerPlaying &&
                                                playerState.currentSong.id == song.id;

                                        return ListTile(
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              song.songImageUrl ?? '',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                  stackTrace) {
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.grey.shade300,
                                                  child: const Icon(
                                                    Icons.music_note,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          title: Text(
                                            song.songName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(song.artistId),
                                          trailing: IconButton(
                                            icon: Icon(
                                              isPlaying
                                                  ? Icons.pause_circle_filled
                                                  : Icons.play_circle_filled,
                                              size: 40,
                                              color: isPlaying
                                                  ? Colors.orange
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<PlayerCubit>()
                                                  .togglePlayPause(song);
                                            },
                                          ),
                                          onTap: () {
                                            context
                                                .read<PlayerCubit>()
                                                .listenToPositionStream();

                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (BuildContext context) {
                                                return PlayerView(song: song);
                                              },
                                            );
                                          },
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                              } else if (state is SongError) {
                                return Center(
                                  child: Text('Error: ${state.error}'),
                                );
                              }
                              return const Center(
                                child: Text('No songs available.'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
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
        bottomNavigationBar: CustomBottomBar(type: CustomBottomBarType.home),
      ),
    );
  }

  Widget _buildBoxedSection({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlphaD(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Refactor _buildGenreChip để khi bấm vào, ta chuyển sang GenreSongsScreen
  Widget _buildGenreChip(BuildContext context, String genre, Color color) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GenreSongsScreen(genreName: genre),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          gradient: generateHashGradient(genre),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          genre,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onIconPressed; // Callback cho icon

  const SectionHeader({
    super.key,
    required this.title,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.grey),
          onPressed: onIconPressed, // Khi nhấn vào icon
        ),
      ],
    );
  }
}
