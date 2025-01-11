import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favoriteSongs/favorite_songs_cubit.dart';
import '../cubit/favoriteSongs/favorite_songs_state.dart';
import '../../../injection_container.dart'; // Import `sl`

class FavoriteSongsPage extends StatelessWidget {
  const FavoriteSongsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FavoriteSongsCubit>(), // Inject `FavoriteSongsCubit` từ GetIt
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Songs'),
        ),
        body: BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
          builder: (context, state) {
            if (state is FavoriteSongsInitial) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<FavoriteSongsCubit>().fetchFavoriteSongs();
                  },
                  child: const Text('Load Favorite Songs'),
                ),
              );
            } else if (state is FavoriteSongsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FavoriteSongsLoaded) {
              final favoriteSongs = state.favoriteSongs;
              if (favoriteSongs.isEmpty) {
                return const Center(
                  child: Text('No favorite songs found.'),
                );
              }
              return ListView.builder(
                itemCount: favoriteSongs.length,
                itemBuilder: (context, index) {
                  final song = favoriteSongs[index];
                  return ListTile(
                    title: Text(song.songName),
                    subtitle: Text(song.artistId),
                    leading: const Icon(Icons.music_note),
                  );
                },
              );
            } else if (state is FavoriteSongsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FavoriteSongsCubit>().fetchFavoriteSongs();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
