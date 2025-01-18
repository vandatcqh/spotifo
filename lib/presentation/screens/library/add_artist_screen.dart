import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/artist/artist_cubit.dart';
import '../../cubit/artist/artist_state.dart';
import '../../cubit/favoriteArtists/favorite_artists_cubit.dart';

class AddArtistScreen extends StatelessWidget {
  const AddArtistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Nghệ Sĩ Yêu Thích'),
      ),
      body: BlocBuilder<ArtistCubit, ArtistState>(
        builder: (context, artistState) {
          return BlocBuilder<FavoriteArtistsCubit, FavoriteArtistsState>(
            builder: (context, favoriteState) {
              if (artistState is ArtistLoading || favoriteState is FavoriteArtistsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (artistState is ArtistLoaded && favoriteState is FavoriteArtistsLoaded) {
                // Danh sách tất cả các nghệ sĩ
                final allArtists = artistState.artists;

                // Danh sách nghệ sĩ yêu thích
                final favoriteArtists = favoriteState.favoriteArtists;

                // Lọc ra các nghệ sĩ không nằm trong danh sách yêu thích
                final availableArtists = allArtists.where((artist) {
                  return !favoriteArtists.any((fav) => fav.id == artist.id);
                }).toList();

                // Kiểm tra nếu không có nghệ sĩ nào khả dụng
                if (availableArtists.isEmpty) {
                  return const Center(
                    child: Text('Tất cả nghệ sĩ đã nằm trong danh sách yêu thích.'),
                  );
                }

                return ListView.builder(
                  itemCount: availableArtists.length,
                  itemBuilder: (context, index) {
                    final artist = availableArtists[index];
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
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          // Thêm nghệ sĩ vào danh sách yêu thích
                          BlocProvider.of<FavoriteArtistsCubit>(context)
                              .addFavoriteArtist(artist);

                          // Quay lại màn hình trước
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              } else if (artistState is ArtistError) {
                return Center(child: Text(artistState.message));
              } else if (favoriteState is FavoriteArtistsError) {
                return Center(child: Text(favoriteState.message));
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
