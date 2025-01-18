import 'package:flutter/material.dart';
import 'package:spotifo/presentation/screens/player/player_full_lyric.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';
import 'package:spotifo/core/app_export.dart';

import '../../common_widgets/volume_control.dart';
import '../../cubit/favoriteSongs/favorite_songs_cubit.dart';
import '../../cubit/favoriteSongs/favorite_songs_state.dart';
import '../details/song_detail_screen.dart';
import 'queue_screen.dart';

enum PlayerViewMode { mainPlayer, lyrics, playlist }

class PlayerView extends StatefulWidget {
  final SongEntity song;
  //late final bool isPlaying = false;

  const PlayerView({
    super.key,
    required this.song,
    isPlaying
  });

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  Color _backgroundColor = Colors.blue;
  bool isFavorite = false;
  PlayerViewMode _currentView = PlayerViewMode.mainPlayer;
  late SongEntity currentSong;

  @override
  void initState() {
    super.initState();
    currentSong = widget.song;
    _updateBackgroundColor();
  }

  Future<void> _updateBackgroundColor() async {
    if (currentSong.songImageUrl != null) {
      final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(
        NetworkImage(currentSong.songImageUrl!),
      );
      setState(() {
        _backgroundColor =
            paletteGenerator.dominantColor?.color ?? Colors.blue.shade50;
      });
    }
  }

  void _switchView(PlayerViewMode mode) {
    setState(() {
      _currentView = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, AppPlayerState>(
      builder: (context, state) {



        if(state is PlayerPlaying) {
          currentSong = state.currentSong;
        }

        if(state is PlayerPaused) {
          currentSong = state.currentSong;
        }

        //context.read<PlayerCubit>().listenToPositionStream();

        Duration currentPosition = (state is PlayerPlaying || state is PlayerPaused)
            ? state.position
            : Duration.zero;
        Duration totalDuration = (state is PlayerPlaying || state is PlayerPaused)
            ? state.totalDuration
            : Duration.zero;

        bool isPlaying =  (state is PlayerPlaying && state.currentSong.id == currentSong.id);

        return Scaffold(
          backgroundColor: _backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Close PlayerView
                  },
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.lyrics,
                          color: _currentView == PlayerViewMode.lyrics ? Colors.black : Colors.white,
                        ),
                        onPressed: () => _switchView(PlayerViewMode.lyrics),
                      ),

                      IconButton(
                        icon: Icon(
                            Icons.music_note,
                            color: _currentView == PlayerViewMode.mainPlayer ? Colors.black : Colors.white,
                        ),
                        onPressed: () => _switchView(PlayerViewMode.mainPlayer),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.playlist_play,
                          color: _currentView == PlayerViewMode.playlist ? Colors.black : Colors.white,
                        ),
                        onPressed: () => _switchView(PlayerViewMode.playlist),
                      ),

                    ]
                ),

                // AppBar with Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _getAppBarTitle(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),

                // View Content
                Expanded(
                  child: _buildActiveView(
                    isPlaying: isPlaying,
                    currentPosition: currentPosition,
                    totalDuration: totalDuration,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getAppBarTitle() {
    switch (_currentView) {
      case PlayerViewMode.lyrics:
        return 'Lyrics';
      case PlayerViewMode.playlist:
        return 'Playlist';
      default:
        return 'Now Playing';
    }
  }

  Widget _buildActiveView({
    required bool isPlaying,
    required Duration currentPosition,
    required Duration totalDuration,
  }) {
    switch (_currentView) {
      case PlayerViewMode.lyrics:
        return PlayerFullLyric(song: currentSong);
      case PlayerViewMode.playlist:
        return QueueScreen(song: currentSong);
      default:
        return _buildMainPlayerView(
          isPlaying: isPlaying,
          currentPosition: currentPosition,
          totalDuration: totalDuration,
        );
    }
  }

  Widget _buildMainPlayerView({
    required bool isPlaying,
    required Duration currentPosition,
    required Duration totalDuration,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [

          SizedBox(height: 2.h),
          // Album cover
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: currentSong.songImageUrl != null
                  ? Image.network(
                currentSong.songImageUrl!,
                width: 60.w,
                height: 60.w,
                fit: BoxFit.cover,
              )
                  : Icon(Icons.music_note, size: 60.w, color: Colors.white),
            ),
          ),
          SizedBox(height: 4.h),

          // Song name and artist
          Text(
            currentSong.songName,
            style: TextStyle(
              fontSize: 3.h,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            currentSong.artistId,
            style: TextStyle(
              fontSize: 2.h,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),

          // Playback slider
          Slider(
            value: currentPosition.inSeconds.toDouble(),
            max: totalDuration.inSeconds > 0 ? totalDuration.inSeconds.toDouble() : 1.0,
            activeColor: Colors.white,
            inactiveColor: Colors.white38,
            onChanged: (value) {

              if(currentPosition >= totalDuration)
              {
                context.read<PlayerCubit>().togglePlayPause(currentSong);
              }

              // Update the duration in real-time while dragging the slider
              final newPosition = Duration(seconds: value.toInt());
              context.read<PlayerCubit>().seekTo(newPosition);
            },
          ),

          // Time labels
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(currentPosition),
                  style: TextStyle(color: Colors.white70, fontSize: 2.h),
                ),
                Text(
                  _formatDuration(totalDuration),
                  style: TextStyle(color: Colors.white70, fontSize: 2.h),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Speed modifier buttons with Heart and Three-Dot Menu Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // Speed Modifier Button with Popup Options
              PopupMenuButton<double>(
                icon: const Icon(Icons.speed, color: Colors.white), // Use an icon for the button
                onSelected: (speed) {
                  // Handle speed adjustment logic
                  // For example:
                  print("Selected playback speed: $speed");
                },
                itemBuilder: (context) => [0.25, 0.5, 1.0, 1.5, 2.0].map((speed) {
                  return PopupMenuItem<double>(
                    value: speed,
                    child: Text(
                      '${speed}x', // Display speed with "x" as in "1.0x"
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ),


              BlocConsumer<FavoriteSongsCubit, FavoriteSongsState>(
                listener: (context, state) {
                  if (state is FavoriteSongsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is FavoriteSongsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FavoriteSongsLoaded) {
                    final favoriteSongs = state.favoriteSongs;
                    final isFavorite = favoriteSongs.any((s) => s.id == currentSong.id);

                    return ElevatedButton.icon(
                      onPressed: () {
                        final favoriteSongsCubit = context.read<FavoriteSongsCubit>();
                        if (isFavorite) {
                          favoriteSongsCubit.removeFavoriteSong(currentSong.id);
                        } else {
                          favoriteSongsCubit.addFavoriteSong(currentSong.id);
                        }
                      },
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFavorite ? 'Bỏ Thích' : 'Thích'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorite ? Colors.red : Colors.blue,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Three-Dot Menu Button
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SongDetailScreen(song: currentSong),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 5.h),

          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Backward button
              IconButton(
                icon: Icon(Icons.replay_10, size: 4.h),
                color: (isPlaying && currentPosition < totalDuration) ? Colors.white : Colors.grey,
                onPressed: (isPlaying && currentPosition < totalDuration)
                    ? () {
                  final playerCubit = context.read<PlayerCubit>();
                  final newPosition = currentPosition - Duration(seconds: 10);
                  playerCubit.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
                }
                    : null, // Disable button when the song is not playing
              ),

              // Play/Pause or Replay button
              IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 7.h,
                  color: Colors.white,
                ),
                onPressed: () {
                  final playerCubit = context.read<PlayerCubit>();
                  if (currentPosition >= totalDuration && !playerCubit.isFirstLoad) {
                    // Replay the song
                    playerCubit.replay();
                  } else {
                    // Toggle play/pause
                    playerCubit.togglePlayPause(currentSong);
                  }
                },
              ),


              // Forward button
              IconButton(
                icon: Icon(Icons.forward_10, size: 4.h),
                color: (isPlaying && currentPosition < totalDuration) ? Colors.white : Colors.grey,
                onPressed: (isPlaying && currentPosition < totalDuration)
                    ? () {
                  final playerCubit = context.read<PlayerCubit>();
                  final newPosition = currentPosition + Duration(seconds: 10);
                  if(newPosition >= totalDuration)
                  {
                    context.read<PlayerCubit>().togglePlayPause(currentSong);
                  }

                  playerCubit.seekTo(newPosition > totalDuration ? totalDuration : newPosition);

                }
                    : null, // Disable button when the song is not playing
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Volume slider
          const VolumeControl(), // Include the VolumeControl widget
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

}
