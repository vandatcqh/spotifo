import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/song/song_cubit.dart';
import '../cubit/song/song_state.dart';
import '../cubit/player/player_cubit.dart';
import '../cubit/player/player_state.dart';
import '../cubit/user/user_info_cubit.dart';
import '../cubit/genre/genre_cubit.dart';
import '../cubit/genre/genre_state.dart';
import 'sign_in_screen.dart';

import '../../../injection_container.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserInfoCubit>(
          create: (_) => sl<UserInfoCubit>()..fetchUser(),
        ),
        BlocProvider<GenreCubit>(
          create: (_) => sl<GenreCubit>()..fetchGenres(),
        ),
        BlocProvider<SongInfoCubit>(
          create: (_) => sl<SongInfoCubit>()..fetchHotSongs(),
        ),
        BlocProvider<PlayerCubit>(
          create: (_) => sl<PlayerCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thông Tin Người Dùng'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<UserInfoCubit>().signOut();
              },
            ),
          ],
        ),
        body: BlocConsumer<UserInfoCubit, UserInfoState>(
          listener: (context, state) {
            if (state is UserInfoNotAuthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => SignInScreen()),
              );
            } else if (state is UserInfoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserInfoLoaded) {
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Họ và Tên: ${user.fullName}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Email: ${user.username}',
                          style: const TextStyle(fontSize: 18)),
                      if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                        Image.network(user.avatarUrl!),
                      const SizedBox(height: 16),
                      const Text(
                        'Thể loại yêu thích:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      BlocBuilder<GenreCubit, GenreState>(
                        builder: (context, genreState) {
                          if (genreState is GenreLoaded) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: genreState.selectedGenres.length,
                              itemBuilder: (context, index) {
                                final genre = genreState.selectedGenres[index];
                                final isSelected =
                                genreState.selectedGenres.contains(genre);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<GenreCubit>()
                                          .toggleFavoriteGenre(genre);
                                    },
                                    child: Text(
                                      genre,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (genreState is GenreError) {
                            return Center(child: Text(genreState.message));
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bài hát nổi bật:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
            BlocBuilder<SongInfoCubit, SongInfoState>(
            builder: (context, songState) {
            if (songState is SongHotSongsLoaded) {
            return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: songState.songs.length,
            itemBuilder: (context, index) {
            final song = songState.songs[index];
            return BlocBuilder<PlayerCubit, AppPlayerState>(
            builder: (context, playerState) {
            final isPlaying = playerState is PlayerPlaying &&
            playerState.currentSong.id == song.id;
            final isPaused = playerState is PlayerPaused &&
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
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 50),
            loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
            width: 50,
            height: 50,
            child: Center(child: CircularProgressIndicator()),
            );
            },
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
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            size: 40,
            color: Colors.blue,
            ),
            onPressed: () {
            context.read<PlayerCubit>().togglePlayPause(song);
            },
            ),
            );
            },
            );
            },
            );
            } else if (songState is SongError) {
            return Center(child: Text(songState.error));
            }
            return const Center(child: CircularProgressIndicator());
            },
            ),
                    ],
                  ),
                ),
              );
            } else if (state is UserInfoNotAuthenticated) {
              return const Center(child: Text('Chưa đăng nhập'));
            } else if (state is UserInfoFailure) {
              return const Center(
                  child: Text('Không thể tải thông tin người dùng'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
