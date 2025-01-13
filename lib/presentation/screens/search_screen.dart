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
  String? _selectedGenre; // Thể loại được chọn (dùng cho songs)
  List<dynamic> _results = []; // Kết quả trả về từ API

  // Danh sách các thể loại có thể chọn
  final List<String> _availableGenres = ["POP", "PO", "BALLAD"];

  // Hàm thực hiện gọi API
  Future<void> performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty &&
        _selectedFunction == "songs" &&
        (_selectedGenre == null || _selectedGenre!.isEmpty)) {
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

  // Widget nút chọn genre (chỉ cho phép chọn một thể loại duy nhất)
  Widget genreDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Select Genre",
        border: OutlineInputBorder(),
      ),
      value: _selectedGenre,
      items: _availableGenres.map((genre) {
        return DropdownMenuItem<String>(
          value: genre,
          child: Text(genre),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGenre = value;
        });
      },
      isExpanded: true,
      hint: Text("Choose a genre"),
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
                      _selectedGenre = null; // Reset genre khi đổi loại tìm kiếm
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
                      _selectedGenre = null; // Reset genre khi đổi loại tìm kiếm
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
                      _selectedGenre = null; // Reset genre khi đổi loại tìm kiếm
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
              genreDropdown(),
            if (_selectedFunction == "songs") const SizedBox(height: 16),

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
