import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/favoriteSongs/favorite_songs_cubit.dart';
import '../../cubit/favoriteSongs/favorite_songs_state.dart';
import 'add_song_screen.dart';
import '../details/song_detail_screen.dart';

class FavoriteSongsScreen extends StatelessWidget {
  const FavoriteSongsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch favorite songs when the screen is built
    context.read<FavoriteSongsCubit>().fetchFavoriteSongs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Bài Hát Yêu Thích'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
            builder: (context, state) {
              if (state is FavoriteSongsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FavoriteSongsLoaded) {
                final favoriteSongs = state.favoriteSongs;
                if (favoriteSongs.isEmpty) {
                  return const Center(child: Text('Không có bài hát yêu thích nào.'));
                }
                return ListView.builder(
                  itemCount: favoriteSongs.length,
                  itemBuilder: (context, index) {
                    final song = favoriteSongs[index];
                    return Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: (song.songImageUrl != null && song.songImageUrl!.isNotEmpty)
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
                        subtitle: Text('Tác giả: ${song.artistId}'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SongDetailScreen(song: song),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else if (state is FavoriteSongsError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return BlocProvider.value(
                value: BlocProvider.of<FavoriteSongsCubit>(context),
                child: const AddSongScreen(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<FavoriteSongsCubit>(context).sortSongsAscending();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sắp xếp A → Z'),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<FavoriteSongsCubit>(context).sortSongsDescending();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sắp xếp Z → A'),
            ),
          ],
        ),
      ),
    );
  }
}
