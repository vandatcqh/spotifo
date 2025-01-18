import 'package:flutter/material.dart';

import 'package:spotifo/presentation/screens/player/mini_player.dart';
import 'package:spotifo/core/app_export.dart';
import '../../cubit/player/player_cubit.dart';
import '../../cubit/player/player_state.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                // Playlist Button
                // _buildLibraryItem(
                //   context,
                //   title: 'Playlist',
                //   gradientColors: [Colors.red, Colors.pink],
                //   route: '/favorite_playlist',
                // ),
                // Songs Button
                _buildLibraryItem(
                  context,
                  title: 'Songs',
                  gradientColors: [Colors.blue, Colors.red],
                  route: '/favorite_songs',
                ),
                // Albums Button
                // _buildLibraryItem(
                //   context,
                //   title: 'Albums',
                //   gradientColors: [Colors.green, Colors.yellow],
                //   route: '/favorite_albums',
                // ),
                // Artists Button
                _buildLibraryItem(
                  context,
                  title: 'Artists',
                  gradientColors: [Colors.green, Colors.orange],
                  route: '/favorite_artists',
                ),

              ],
            ),
          ),
          BlocBuilder<PlayerCubit, AppPlayerState>(
            builder: (context, state) {
              if (state is PlayerPlaying) {
                final song = state.currentSong;
                final isPlaying = true;
                return MiniPlayer(
                  currentSong: song,
                  isPlaying: isPlaying,
                );
              } else if (state is PlayerPaused) {
                final song = state.currentSong;
                final isPlaying = false;
                return MiniPlayer(
                  currentSong: song,
                  isPlaying: isPlaying,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      )
    );
  }

  Widget _buildLibraryItem(
      BuildContext context, {
        required String title,
        required List<Color> gradientColors,
        required String route,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
