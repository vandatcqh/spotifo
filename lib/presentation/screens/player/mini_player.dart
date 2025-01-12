import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/player/player_cubit.dart';
import '../../cubit/player/player_state.dart';
import '../../../domain/entities/song_entity.dart';
import 'player_screen.dart';


class MiniPlayer extends StatelessWidget {
  final SongEntity currentSong;
  final bool isPlaying;

  const MiniPlayer({
    Key? key,
    required this.currentSong,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          // Navigate to the player screen when the mini-player is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SongPlayerScreen(song: currentSong),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade200, Colors.purple.shade300],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  currentSong.songImageUrl ?? '',
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 10.w,
                      height: 10.w,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.music_note,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSong.songName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentSong.artistId,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 40,
                  color: Colors.orange,
                ),
                onPressed: () {
                  context.read<PlayerCubit>().togglePlayPause(currentSong);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
