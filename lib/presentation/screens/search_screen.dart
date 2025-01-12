import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudFunctionTestScreen extends StatefulWidget {
  @override
  _CloudFunctionTestScreenState createState() =>
      _CloudFunctionTestScreenState();
}

class _CloudFunctionTestScreenState extends State<CloudFunctionTestScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFunction = "songs"; // Loại hàm: songs, artists, albums
  List<String> _selectedGenres = []; // Danh sách thể loại được chọn (dùng cho songs)
  List<dynamic> _results = []; // Kết quả trả về từ API

  // Hàm thực hiện gọi API
  Future<void> performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty &&
        _selectedFunction == "songs" &&
        _selectedGenres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a search query or select a genre.")),
      );
      return;
    }

    late Uri uri; // Sử dụng 'late' để đảm bảo 'uri' sẽ được gán trước khi sử dụng

    if (_selectedFunction == "songs") {
      final params = {
        "songName": query,
      };
      if (_selectedGenres.isNotEmpty) {
        params["genre"] = _selectedGenres.join(',');
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
      // Xử lý trường hợp không xác định (nên không xảy ra nếu _selectedFunction chỉ có 3 giá trị)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid function selected.")),
      );
      return;
    }

    print("API Request URL: $uri"); // Thêm dòng này để kiểm tra URL

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          _results = decoded;
        });
        print("Search Results: $decoded"); // Thêm dòng này để kiểm tra kết quả
      } else {
        print("Error Response: ${response.body}"); // Thêm dòng này để kiểm tra lỗi
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

  // Widget nút chọn genre
  Widget genreButton(String genre) {
    final lowerGenre = genre.toLowerCase();
    final isSelected = _selectedGenres.contains(lowerGenre);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            _selectedGenres.remove(lowerGenre);
          } else {
            _selectedGenres.add(lowerGenre);
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
      child: Text(genre),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Functions Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ô nhập liệu
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Enter search query",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Chọn loại hàm
            Text("Select Function:"),
            Wrap(
              spacing: 8, // Khoảng cách ngang giữa các nút
              runSpacing: 8, // Khoảng cách dọc khi các nút xuống dòng
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedFunction = "songs";
                      _selectedGenres = []; // Reset genres khi đổi loại tìm kiếm
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedFunction == "songs"
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text("Search Songs"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedFunction = "artists";
                      _selectedGenres = []; // Reset genres khi đổi loại tìm kiếm
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedFunction == "artists"
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text("Search Artists"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedFunction = "albums";
                      _selectedGenres = []; // Reset genres khi đổi loại tìm kiếm
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedFunction == "albums"
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text("Search Albums"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chọn genre (chỉ áp dụng cho songs)
            if (_selectedFunction == "songs")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Genre:"),
                  Wrap(
                    spacing: 8,
                    children: [
                      genreButton("POP"),
                      genreButton("ROCK"),
                      genreButton("BALLAD"),
                      // Thêm các thể loại khác nếu cần
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Nút thực hiện tìm kiếm
            Center(
              child: ElevatedButton(
                onPressed: performSearch,
                child: Text("Search"),
              ),
            ),
            const SizedBox(height: 16),

            // Hiển thị kết quả
            Expanded(
              child: _results.isNotEmpty
                  ? ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  String title = "";
                  if (_selectedFunction == "songs") {
                    title = item['songName'] ?? "Unknown";
                  } else if (_selectedFunction == "artists") {
                    title = item['artistName'] ?? "Unknown";
                  } else if (_selectedFunction == "albums") {
                    title = item['albumName'] ?? "Unknown";
                  }
                  return ListTile(
                    title: Text(title),
                    subtitle: Text("ID: ${item['id']}"),
                  );
                },
              )
                  : Center(child: Text("No results")),
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
