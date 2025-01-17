import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injection_container.dart';
import '../cubit/song/song_cubit.dart';
import '../cubit/song/song_state.dart';

// Ví dụ, ta cần SongInfoCubit để fetch
class GenreSongsScreen extends StatelessWidget {
  final String genreName;

  const GenreSongsScreen({
    super.key,
    required this.genreName,
  });

  @override
  Widget build(BuildContext context) {
    // Ở đây, ta dùng MultiBlocProvider hoặc BlocProvider cho SongInfoCubit
    return BlocProvider<SongInfoCubit>(
      create: (_) => sl<SongInfoCubit>()..fetchSongsByGenre(genreName),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bài hát thể loại $genreName'),
        ),
        body: BlocBuilder<SongInfoCubit, SongInfoState>(
          builder: (context, state) {
            if (state is SongInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SongByGenreLoaded) {
              final songs = state.songs;
              if (songs.isEmpty) {
                return Center(child: Text('Chưa có bài hát nào cho thể loại "$genreName"'));
              }
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return ListTile(
                    leading: (song.songImageUrl != null && song.songImageUrl!.isNotEmpty)
                        ? Image.network(song.songImageUrl!)
                        : const Icon(Icons.music_note),
                    title: Text(song.songName),
                    subtitle: Text(song.artistId),
                  );
                },
              );
            } else if (state is SongError) {
              return Center(child: Text('Lỗi: ${state.error}'));
            }
            // Trường hợp SongInfoInitial hoặc khác
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
