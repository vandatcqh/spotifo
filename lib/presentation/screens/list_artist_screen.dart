// presentation/screens/list_artist_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/artist/artist_cubit.dart';
import '../cubit/artist/artist_state.dart';
import '../cubit/user/user_info_cubit.dart';
import 'artist_detail_screen.dart';
import '../../../injection_container.dart';

class ListArtistScreen extends StatelessWidget {
  const ListArtistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArtistCubit>(
          create: (_) => sl<ArtistCubit>()..fetchArtists(),
        ),
        BlocProvider<UserInfoCubit>(
          create: (_) => sl<UserInfoCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh Sách Nghệ Sĩ'),
        ),
        body: BlocBuilder<ArtistCubit, ArtistState>(
          builder: (context, state) {
            if (state is ArtistLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ArtistLoaded) {
              final artists = state.artists;
              if (artists.isEmpty) {
                return const Center(child: Text('Không có nghệ sĩ nào.'));
              }
              return ListView.builder(
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  final artist = artists[index];
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
            } else if (state is ArtistError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

