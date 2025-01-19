import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spotifo/presentation/screens/player/mini_player.dart';
import 'dart:convert';
import '../../core/app_export.dart';

import '../cubit/player/player_cubit.dart';
import '../cubit/player/player_state.dart';

class CloudFunctionTestScreen extends StatefulWidget {
  const CloudFunctionTestScreen({super.key});

  @override
  State<CloudFunctionTestScreen> createState() => _CloudFunctionTestScreenState();
}

class _CloudFunctionTestScreenState extends State<CloudFunctionTestScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFunction = "songs"; // Loại hàm: songs, artists, albums
  String? _selectedGenre; // Thể loại được chọn (dùng cho songs)
  List<dynamic> _results = []; // Kết quả trả về từ API

  final List<String> _availableGenres = ["POP", "BALLAD"];
  final List<String> _recentSearches = ["mind is a prison", "my mind is telling me no", "your mind is not your friend"];
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    // Use test data for initial display
    _results = _testData;
  }

  final List<Map<String, dynamic>> _testData = [
    {
      "id": "1",
      "songName": "chim sau",
      "songImageUrl":
          "https://firebasestorage.googleapis.com/v0/b/hipro-ba392.firebasestorage.app/o/images%2F99%25.jpg?alt=media&token=a288c2d3-6af4-440c-96ed-29af63da5b3c",
      "albumId": "99%",
      "playCount": 12,
      "genre": "POP",
      "releaseDate": {"_seconds": 1677862800, "_nanoseconds": 707000000},
      "artistId": "MCK"
    },
    {
      "id": "2",
      "songName": "thoi em dung di",
      "songImageUrl":
          "https://firebasestorage.googleapis.com/v0/b/hipro-ba392.firebasestorage.app/o/images%2Fthoi_em_dung_di.jpg?alt=media&token=8b7f773f-909b-449f-9773-9e1f738e5d22",
      "albumId": "99%",
      "playCount": 100,
      "genre": "POP",
      "releaseDate": {"_seconds": 1677862800, "_nanoseconds": 707000000},
      "artistId": "TLinh"
    },
    {
      "id": "3",
      "songName": "chi mot dem nua thoi",
      "songImageUrl":
          "https://firebasestorage.googleapis.com/v0/b/hipro-ba392.firebasestorage.app/o/images%2Fchi_mot_dem_nua_thoi.jpg?alt=media&token=dba98b84-0576-4f66-bc04-b3ca4d27eef3",
      "albumId": "99%",
      "playCount": 100,
      "genre": "POP",
      "releaseDate": {"_seconds": 1677862800, "_nanoseconds": 707000000},
      "artistId": "WRXDIE"
    },
  ];

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _showSuggestions = false;
        _filteredSuggestions = [];
      } else {
        _showSuggestions = true;
        _filteredSuggestions = _recentSearches.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void _onSuggestionSelected(String suggestion) {
    setState(() {
      _searchController.text = suggestion;
      _showSuggestions = false;
    });
  }

  Future<void> performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty && _selectedFunction == "songs" && (_selectedGenre == null || _selectedGenre!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a search query or select a genre.")),
      );
      return;
    }

    late Uri uri;

    if (_selectedFunction == "songs") {
      final params = {
        "songName": query,
      };
      if (_selectedGenre != null && _selectedGenre!.isNotEmpty) {
        params["genre"] = _selectedGenre!.toLowerCase();
      }
      uri = Uri.https(
        "us-central1-spotifo-ded50.cloudfunctions.net",
        "/searchSongs",
        params,
      );
    } else if (_selectedFunction == "artists") {
      uri = Uri.https(
        "us-central1-spotifo-ded50.cloudfunctions.net",
        "/searchArtists",
        {"artistName": query},
      );
    } else if (_selectedFunction == "albums") {
      uri = Uri.https(
        "us-central1-spotifo-ded50.cloudfunctions.net",
        "/searchAlbums",
        {"albumName": query},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid function selected.")),
      );
      return;
    }

    print(uri);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          _results = decoded;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Widget nút chọn genre (chỉ cho phép chọn một thể loại duy nhất)

  Widget genreChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableGenres.map((genre) {
        return ChoiceChip(
          label: Text(genre),
          selected: _selectedGenre == genre,
          onSelected: (selected) {
            setState(() {
              _selectedGenre = selected ? genre : null;
            });
          },
          selectedColor: Colors.blue,
          backgroundColor: Colors.grey[300],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the box
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlphaD(0.5), // Shadow color
                    spreadRadius: 4,
                    blurRadius: 8,
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0), // Padding inside the box
              margin: const EdgeInsets.all(16.0), // Margin outside the box
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search function buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedFunction = "songs";
                              _selectedGenre = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedFunction == "songs" ? colorTheme.onPrimary : colorTheme.onSecondary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text("Search Songs"),
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       _selectedFunction = "artists";
                        //       _selectedGenre = null;
                        //     });
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: _selectedFunction == "artists" ? colorTheme.onPrimary : colorTheme.onSecondary,
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        //     child: Text("Search Artists"),
                        //   ),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       _selectedFunction = "albums";
                        //       _selectedGenre = null;
                        //     });
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor:
                        //     _selectedFunction == "albums" ? colorTheme.onPrimary : colorTheme.onSecondary,
                        //   ),
                        //   child: Text("Search Albums"),
                        // ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    // Search input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Field with Suggestions
                        Expanded(
                          child: Stack(
                            children: [
                              TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                decoration: InputDecoration(
                                  hintText: "Search for songs, artists, or albums",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                              if (_showSuggestions && _filteredSuggestions.isNotEmpty)
                                Positioned(
                                  top: 48.0, // Adjust based on TextField height
                                  left: 0,
                                  right: 0,
                                  child: Material(
                                    elevation: 4.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: _filteredSuggestions.map((suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                          onTap: () => _onSuggestionSelected(suggestion),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Search Button
                        const SizedBox(width: 16.0), // Optional spacing between TextField and Button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                            onPressed: performSearch,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorTheme.onSurface, // Set the background color
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0), // Add padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Rounded corners
                              ),
                            ),
                            child: Text(
                              "Search",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: colorTheme.surface, // Text color
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),
                    // Genre filters
                    Center(
                      child: Visibility(
                        visible: _selectedFunction == "songs", // Control visibility
                        child: genreChips(), // Widget to show
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Perform search button

                    Divider(),

                    // Display results
                    Expanded(
                      child: _results.isNotEmpty
                          ? ListView.builder(
                              itemCount: _results.length,
                              itemBuilder: (context, index) {
                                final item = _results[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    elevation: 4.0,
                                    color: colorTheme.onSurface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          // Song Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.network(
                                              item['songImageUrl'] ?? '',
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 12.0),

                                          // Song Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['songName'] ?? "Unknown",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: colorTheme.surface,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 1.h),
                                                Text(
                                                  "Artist: ${item['artistId'] ?? 'Unknown'}",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: colorTheme.surface,
                                                  ),
                                                ),
                                                Text(
                                                  "Genre: ${item['genre'] ?? 'Unknown'}",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: colorTheme.surface,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Metadata: Release Date & Play Count
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Release: ${DateTime.fromMillisecondsSinceEpoch(item['releaseDate']['_seconds'] * 1000).toLocal().toString().split(' ')[0]}",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                "Plays: ${item['playCount'] ?? 0}",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                "No results found",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                    ),
                  ],
                ),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
