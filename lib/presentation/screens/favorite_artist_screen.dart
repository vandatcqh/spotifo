import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favoriteArtists/favorite_artists_cubit.dart';
import '../cubit/artist/artist_cubit.dart';
import '../cubit/artist/artist_state.dart';
import 'artist_detail_screen.dart';
import 'add_artist_screen.dart';

class FavoriteArtistScreen extends StatelessWidget {
  const FavoriteArtistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Nghệ Sĩ Yêu Thích'),
      ),
      body: BlocBuilder<FavoriteArtistsCubit, FavoriteArtistsState>(
        builder: (context, state) {
          if (state is FavoriteArtistsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteArtistsLoaded) {
            final favoriteArtists = state.favoriteArtists;
            if (favoriteArtists.isEmpty) {
              return const Center(child: Text('Không có nghệ sĩ yêu thích nào.'));
            }
            return ListView.builder(
              itemCount: favoriteArtists.length,
              itemBuilder: (context, index) {
                final artist = favoriteArtists[index];
                return ListTile(
                  leading: artist.artistImageUrl != null
                      ? Image.network(
                    artist.artistImageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.person, size: 50),
                  title: Text(artist.artistName),
                  subtitle: Text('${artist.followers} người theo dõi'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArtistDetailScreen(artist: artist),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is FavoriteArtistsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<ArtistCubit>(context)..fetchArtists(),
                child: const AddArtistScreen(),
              ),
            ),
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
                BlocProvider.of<FavoriteArtistsCubit>(context).sortArtistsAscending();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sắp xếp A → Z'),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<FavoriteArtistsCubit>(context).sortArtistsDescending();
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
