import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favoriteArtists/favorite_artists_cubit.dart';
import '../../../domain/entities/artist_entity.dart';

class ArtistDetailScreen extends StatelessWidget {
  final ArtistEntity artist;

  const ArtistDetailScreen({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artist.artistName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hiển thị hình ảnh nghệ sĩ
            if (artist.artistImageUrl != null && artist.artistImageUrl!.isNotEmpty)
              Image.network(
                artist.artistImageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              const Icon(Icons.person, size: 200),
            const SizedBox(height: 16),

            // Tên nghệ sĩ
            Text(
              artist.artistName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Mô tả nghệ sĩ
            if (artist.description != null)
              Text(
                artist.description!,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16),

            // Nút Thích/Bỏ Thích
            BlocConsumer<FavoriteArtistsCubit, FavoriteArtistsState>(
              listener: (context, state) {
                if (state is FavoriteArtistsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is FavoriteArtistsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FavoriteArtistsLoaded) {
                  final favoriteArtists = state.favoriteArtists;
                  final isFavorite = favoriteArtists.any((a) => a.id == artist.id);

                  return ElevatedButton.icon(
                    onPressed: () {
                      final favoriteArtistsCubit = context.read<FavoriteArtistsCubit>();
                      if (isFavorite) {
                        favoriteArtistsCubit.removeFavoriteArtist(artist.id);
                      } else {
                        favoriteArtistsCubit.addFavoriteArtist(artist);
                      }
                    },
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    label: Text(isFavorite ? 'Bỏ Thích' : 'Thích'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFavorite ? Colors.red : Colors.blue,
                    ),
                  );
                } else if (state is FavoriteArtistsError) {
                  return const Center(child: Text('Không thể tải danh sách nghệ sĩ yêu thích.'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
