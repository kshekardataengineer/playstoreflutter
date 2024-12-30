import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
class Post {
  final String content;
  final String filename;
  final String friendName;
  final String timestamp;
  Uint8List? imageBytes;

  Post({
    required this.content,
    required this.filename,
    required this.friendName,
    required this.timestamp,
    this.imageBytes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'],
      filename: json['filename'],
      friendName: json['friendName'],
      timestamp: json['timestamp'],
    );
  }

  String get formattedTimestamp {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return 'Unknown time';
    }
  }
}

class PostProvider with ChangeNotifier {
  List<Post>? _posts;
  bool _isFetching = false;
  Timer? _timer;

  List<Post>? get posts => _posts;
  bool get isFetching => _isFetching;

  PostProvider() {
    _startPeriodicFetch();
  }

  void _startPeriodicFetch() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      fetchPostsAndCache();
    });
  }

  Future<void> fetchPostsAndCache() async {
    if (_isFetching) return;

    _isFetching = true;
    notifyListeners();

    try {
      final posts = await _fetchPosts();
      if (posts != _posts) {
        _posts = posts;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<List<Post>> _fetchPosts() async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"name": "nandu"}), // Adjust the payload as needed
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return Future.wait(data.map((postJson) async {
        final post = Post.fromJson(postJson);
        post.imageBytes = await _fetchImageData(post.filename);
        return post;
      }));
    } else {
      throw Exception('Failed to load posts');
    }
  }



  Future<Uint8List> _fetchImageData(String filename) async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'filename': filename}),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
