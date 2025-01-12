import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';
import '../../../injection_container.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';

import '../player/mini_player.dart';
import '../player/player_screen.dart';
import '../song_list_screen.dart';

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
                    // Suggested for You Section
                    _buildBoxedSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "Suggested For You",
                            onIconPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SongListScreen(), // Replace with the correct screen
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
                                  child: CircularProgressIndicator());
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
                                  builder: (_) => SongListScreen(), // Replace with the correct screen
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2.h),
                          Wrap(
                            spacing: 4.w,
                            runSpacing: 2.h,
                            children: [
                              _buildGenreChip(context, "Pop", Colors.purple),
                              _buildGenreChip(context, "Blue", Colors.blue),
                              _buildGenreChip(context, "Rock", Colors.red),
                              _buildGenreChip(context, "Jazz", Colors.orange),
                              _buildGenreChip(context, "Romance", Colors.pink),
                              _buildGenreChip(context, "Indie", Colors.green),
                            ],
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
                                  builder: (_) => SongListScreen(), // Replace with the correct screen
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2.h),
                          BlocBuilder<SongInfoCubit, SongInfoState>(
                            builder: (context, state) {
                              if (state is SongInfoLoading) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (state is SongHotSongsLoaded) {
                                final songs = state.songs.take(5).toList(); // Display only 5 songs
                                return BlocBuilder<PlayerCubit, AppPlayerState>(
                                  builder: (context, playerState) {
                                    return Column(
                                      children: songs.map((song) {
                                        bool isPlaying = playerState is PlayerPlaying &&
                                            playerState.currentSong.id == song.id;

                                        return ListTile(
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              song.songImageUrl ?? '',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
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
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(song.artistId),
                                          trailing: IconButton(
                                            icon: Icon(
                                              isPlaying
                                                  ? Icons.pause_circle_filled
                                                  : Icons.play_circle_filled,
                                              size: 40,
                                              color: isPlaying ? Colors.orange : Colors.grey,
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
                                                builder: (context) => SongPlayerScreen(song: song),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                              } else if (state is SongError) {
                                return Center(child: Text('Error: \${state.error}'));
                              }
                              return const Center(child: Text('No songs available.'));
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
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_music), label: 'Library'),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.orange,
          onTap: (index) {
            // Handle bottom navigation
          },
        ),
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGenreChip(BuildContext context, String genre, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        genre,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onIconPressed; // Callback for the icon press

  const SectionHeader({
    Key? key,
    required this.title,
    required this.onIconPressed,
  }) : super(key: key);

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
          onPressed: onIconPressed, // Trigger navigation when pressed
        ),
      ],
    );
  }
}
