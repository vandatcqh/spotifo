import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/artist/artist_cubit.dart';
import '../../../domain/entities/artist_entity.dart';
import '../../../injection_container.dart';
import '../cubit/user/user_info_cubit.dart';

class ArtistDetailScreen extends StatelessWidget {
  final ArtistEntity artist;

  const ArtistDetailScreen({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserInfoCubit>(
      create: (_) => sl<UserInfoCubit>()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(artist.artistName),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              Text(
                artist.artistName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (artist.description != null)
                Text(
                  artist.description!,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 16),
              BlocConsumer<UserInfoCubit, UserInfoState>(
                listener: (context, state) {
                  if (state is UserInfoFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UserInfoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserInfoLoaded) {
                    final userInfoCubit = context.read<UserInfoCubit>();
                    final isFavorite = state.user.favoriteArtists.contains(artist.id);

                    return ElevatedButton.icon(
                      onPressed: () {
                        if (isFavorite) {
                          userInfoCubit.removeFavoriteArtist(artist.id);
                        } else {
                          userInfoCubit.addFavoriteArtist(artist.id);
                        }
                      },
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFavorite ? 'Bỏ Thích' : 'Thích'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorite ? Colors.red : Colors.blue,
                      ),
                    );
                  } else if (state is UserInfoFailure) {
                    return const Center(child: Text('Không thể tải thông tin người dùng.'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
