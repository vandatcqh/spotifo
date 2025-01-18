// presentation/screens/artist_detail_screen.dart

import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../domain/entities/artist_entity.dart';
import '../../components/svg.dart';
import '../../cubit/artist/artist_cubit.dart';
import '../../cubit/artist/artist_state.dart';
import '../../cubit/favoriteArtists/favorite_artists_cubit.dart';

class ArtistDetailScreen extends StatefulWidget {
  final ArtistEntity artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  late ArtistEntity _artist;

  @override
  void initState() {
    super.initState();
    _artist = widget.artist;
    // Gọi fetchSongsByArtistId khi màn hình được khởi tạo
    context.read<ArtistCubit>().fetchSongsByArtistId(_artist.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_artist.artistName),
      ),
      body: SingleChildScrollView(
        // Đảm bảo có thể cuộn nếu nội dung dài
        child: Column(
          children: [
            // Hiển thị hình ảnh nghệ sĩ
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.network(_artist.artistImageUrl ?? '', width: double.infinity, height: 75.w, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 75.w,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.person,
                      size: 200,
                      color: Colors.grey,
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _artist.artistName,
                        style: textTheme.headlineLarge?.withColor(Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          BlocConsumer<FavoriteArtistsCubit, FavoriteArtistsState>(
                            listener: (context, state) {
                              if (state is FavoriteArtistsError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              } else if (state is FavoriteArtistsLoaded) {
                                // Cập nhật lại số lượng followers khi trạng thái được cập nhật
                                final updatedArtist = state.favoriteArtists.firstWhere(
                                  (a) => a.id == _artist.id,
                                  orElse: () => _artist,
                                );
                                setState(() {
                                  _artist = updatedArtist;
                                });
                              }
                            },
                            builder: (context, state) {
                              if (state is FavoriteArtistsLoading) {
                                return const Center(child: CircularProgressIndicator(color: Colors.white));
                              } else if (state is FavoriteArtistsLoaded) {
                                final favoriteArtists = state.favoriteArtists;
                                final isFavorite = favoriteArtists.any((a) => a.id == _artist.id);

                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    final favoriteArtistsCubit = context.read<FavoriteArtistsCubit>();
                                    if (isFavorite) {
                                      favoriteArtistsCubit.removeFavoriteArtist(_artist);
                                    } else {
                                      favoriteArtistsCubit.addFavoriteArtist(_artist);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                                    decoration: BoxDecoration(color: colorTheme.surface.withAlphaD(0.6), borderRadius: BorderRadius.circular(100)),
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        SVG(isFavorite ? "assets/svgs/heroicons-solid/star.svg" : "assets/svgs/heroicons-outline/star.svg",
                                            size: 20, color: Colors.white),
                                        Text("Follow", style: textTheme.titleMedium?.withColor(Colors.white)),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (state is FavoriteArtistsError) {
                                return const Center(child: Text('Không thể tải danh sách nghệ sĩ yêu thích.'));
                              }
                              return const SizedBox.shrink(); // Hiển thị trống nếu không có trạng thái liên quan
                            },
                          ),
                          BlocBuilder<FavoriteArtistsCubit, FavoriteArtistsState>(
                            builder: (context, state) {
                              if (state is FavoriteArtistsLoaded) {
                                final updatedArtist = state.favoriteArtists.firstWhere(
                                  (a) => a.id == _artist.id,
                                  orElse: () => _artist,
                                );
                                return Text(
                                  'Followers: ${updatedArtist.followers}',
                                  style: textTheme.titleMedium?.withColor(Colors.white),
                                );
                              }
                              return Text(
                                'Followers: ${_artist.followers}',
                                style: textTheme.titleMedium?.withColor(Colors.white),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Mô tả nghệ sĩ
                  if (_artist.description != null)
                    Text(
                      _artist.description!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 16),

                  // Tiêu đề danh sách bài hát
                  const Text(
                    'Danh Sách Bài Hát',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Hiển thị danh sách bài hát
                  BlocBuilder<ArtistCubit, ArtistState>(
                    builder: (context, state) {
                      if (state is ArtistLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SongsLoaded) {
                        final songs = state.songs;
                        if (songs.isEmpty) {
                          return const Center(child: Text('Không có bài hát nào.'));
                        }
                        return ListView.builder(
                          shrinkWrap: true, // Để ListView không chiếm toàn bộ không gian
                          physics: const NeverScrollableScrollPhysics(), // Ngăn ListView cuộn riêng
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return ListTile(
                              leading: song.songImageUrl != null && song.songImageUrl!.isNotEmpty
                                  ? Image.network(
                                      song.songImageUrl!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.music_note, size: 50),
                              title: Text(song.songName),
                              subtitle: Text('Thể loại: ${song.genre}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.play_arrow),
                                  //Text(song.playCount.toString()),
                                ],
                              ),
                              onTap: () {
                                // Xử lý khi nhấn vào bài hát, ví dụ: phát nhạc
                              },
                            );
                          },
                        );
                      } else if (state is ArtistError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink(); // Hiển thị trống nếu không có trạng thái liên quan
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
