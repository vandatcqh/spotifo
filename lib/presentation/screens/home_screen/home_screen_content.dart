import 'package:flutter/material.dart';
import 'package:spotifo/core/app_export.dart';
import 'package:spotifo/injection_container.dart';
import 'package:spotifo/presentation/components/music_display_item.dart';
import 'package:spotifo/presentation/components/section_header.dart';
import 'package:spotifo/presentation/cubit/artist/artist_cubit.dart';
import 'package:spotifo/presentation/cubit/genre/genre_cubit.dart';
import 'package:spotifo/presentation/cubit/genre/genre_state.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';
import 'package:spotifo/presentation/screens/genre_song_screen.dart';
import 'package:spotifo/presentation/screens/player/mini_player.dart';
import 'package:spotifo/presentation/screens/player/player_screen.dart';
import 'package:spotifo/presentation/screens/song_list_screen.dart';
import 'package:spotifo/presentation/util/hash_gradient.dart';

import '../../cubit/artist/artist_state.dart';
import '../details/artist_detail_screen.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

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
        BlocProvider<GenreCubit>(
          create: (_) => sl<GenreCubit>()..fetchGenres(),
        ),
        BlocProvider<ArtistCubit>(
          create: (_) => sl<ArtistCubit>()..fetchArtists(),
        ),
      ],
      child: Stack(
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
                          showIcon: true,
                        ),
                        SizedBox(height: 2.h),
                        BlocBuilder<SongInfoCubit, SongInfoState>(
                          builder: (context, state) {
                            if (state is SongHotSongsLoaded) {
                              final songs = state.songs;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: 8,
                                  children: songs.map((song) {
                                    return MusicDisplayItem(
                                      imageUrl: song.songImageUrl,
                                      label: song.songName,
                                      description: song.artistId,
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

                  _buildBoxedSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: "On The Rise",
                          onIconPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SongListScreen(),
                              ),
                            );
                          },
                          showIcon: false,
                        ),
                        SizedBox(height: 2.h),
                        BlocBuilder<ArtistCubit, ArtistState>(
                          builder: (context, state) {
                            if (state is ArtistLoaded) {
                              final artists = state.artists;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: 8,
                                  children: artists.map((artist) {
                                    return MusicDisplayItem(
                                      imageUrl: artist.artistImageUrl,
                                      label: artist.artistName,
                                      onPressed: () {
                                        print("Hello");
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ArtistDetailScreen(artist: artist),
                                          ),
                                        );
                                      },
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
                          showIcon: false,
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
                                spacing: 8,
                                runSpacing: 8,
                                children: genres.map((genre) {
                                  // Bạn có thể tuỳ chọn cách gán màu ở đây
                                  return _buildGenreChip(context, genre);
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
                          showIcon: false,
                        ),
                        SizedBox(height: 2.h),
                        BlocBuilder<SongInfoCubit, SongInfoState>(
                          builder: (context, state) {
                            if (state is SongInfoLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is SongHotSongsLoaded) {
                              final songs = state.songs.take(5).toList(); // Hiển thị 5 bài
                              return BlocBuilder<PlayerCubit, AppPlayerState>(
                                builder: (context, playerState) {
                                  return Column(
                                    children: songs.map((song) {
                                      bool isPlaying = playerState is PlayerPlaying && playerState.currentSong.id == song.id;

                                      return Container(
                                          color: isPlaying ? colorTheme.onPrimary : colorTheme.surface,
                                          child: ListTile(
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
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(song.artistId),
                                            trailing: IconButton(
                                              icon: Icon(
                                                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                                size: 40,
                                                color: isPlaying ? Colors.orange : Colors.grey,
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
                                                  return PlayerView(song: song);
                                                },
                                              );
                                            },
                                          ));
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

                  // Additional sections can be added here.
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
  Widget _buildGenreChip(BuildContext context, String genre) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GenreSongsScreen(genreName: genre),
          ),
        );
      },
      child: Container(
        width: 122,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: generateHashGradient(genre),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            genre,
            style: textTheme.labelLarge?.withColor(Colors.white),
          ),
        ),
      ),
    );
  }
}
