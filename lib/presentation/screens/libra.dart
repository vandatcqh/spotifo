import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorite_playlist');
              },
              child: const Text('Playlist'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorite_songs');
              },
              child: const Text('Songs'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorite_albums');
              },
              child: const Text('Albums'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorite_artists');
              },
              child: const Text('Artists'),
            ),
          ],
        ),
      ),
    );
  }
}
