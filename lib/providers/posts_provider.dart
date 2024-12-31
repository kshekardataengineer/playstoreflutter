/*import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';

class Post {
  final String filename;
  final String friendName;
  final String? content;
  final String timestamp;
  final Uint8List? imageBytes;

  Post({
    required this.filename,
    required this.friendName,
    this.content,
    required this.timestamp,
    this.imageBytes,
  });
}

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _hasMorePosts = true; // Track if more posts are available
  Map<String, int> _likeCounts = {};
  Map<String, List<String>> _likedByUsers = {};
  Map<String, List<dynamic>> _comments = {};
  String loggedInPerson = 'rajkiran';

  List<Post> get posts => _posts;
  bool get hasMorePosts => _hasMorePosts;
  Map<String, int> get likeCounts => _likeCounts;
  Map<String, List<dynamic>> get comments => _comments;
  Map<String, List<String>> get likedByUsers => _likedByUsers;

  Future<void> fetchPosts() async {
    // Simulate an API call with a delay
    await Future.delayed(Duration(seconds: 2));

    // Replace this with your actual API call
    List<Post> fetchedPosts = [
      // Simulated posts
      Post(
        filename: 'post1',
        friendName: 'Alice',
        content: 'This is the first post!',
        timestamp: DateTime.now().toIso8601String(),
        imageBytes: null, // Add your image bytes here
      ),
      Post(
        filename: 'post2',
        friendName: 'Bob',
        content: 'This is the second post!',
        timestamp: DateTime.now().toIso8601String(),
        imageBytes: null, // Add your image bytes here
      ),
    ];

    // Add the fetched posts to the list
    if (fetchedPosts.isEmpty) {
      _hasMorePosts = false; // No more posts to load
    } else {
      _posts.addAll(fetchedPosts);
    }

    notifyListeners(); // Notify listeners to rebuild UI
  }

  void likePost(String filename) {
    _likeCounts[filename] = (_likeCounts[filename] ?? 0) + 1;
    _likedByUsers.putIfAbsent(filename, () => []).add(loggedInPerson);
    notifyListeners(); // Update UI
  }

  void removeLike(String filename) {
    if (_likeCounts[filename] != null && _likeCounts[filename]! > 0) {
      _likeCounts[filename] = _likeCounts[filename]! - 1;
      _likedByUsers[filename]?.remove(loggedInPerson);
      notifyListeners(); // Update UI
    }
  }

  void commentPost(String filename, String userName, String comment) {
    if (comment.isNotEmpty) {
      _comments.putIfAbsent(filename, () => []).add({'content': comment, 'name': userName});
      notifyListeners(); // Update UI
    }
  }

// Additional methods to fetch likes, comments, etc. can be added here.
}


// posts_provider.dart
//working code but loading slow
/*
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/model/post_model.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  Map<String, int> likeCounts = {};
  Map<String, List<dynamic>> comments = {};
  Map<String, List<String>> likedByUsers = {};
  String loggedInPerson = "rajkiran"; // Example logged-in user

  List<Post> get posts => _posts;

  // Fetch posts method
  Future<void> fetchPosts() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": loggedInPerson}),
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = jsonDecode(response.body);

        // Create Post objects and sort them by timestamp in descending order
        _posts = fetchedPosts.map((json) => Post.fromJson(json)).toList()
          ..sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

        // Fetch likes, comments, and images for each post
        for (var post in _posts) {
          await fetchLikes(post.filename);
          await fetchComments(post.filename);
          // Fetch image data and ensure it's not null
          Uint8List? imageData = await fetchImageData(post.filename);
          post.imageBytes = imageData ?? Uint8List(0); // Default to empty Uint8List if null
        }

        notifyListeners(); // Notify listeners to rebuild the UI
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  // Fetch image data method
  Future<Uint8List?> fetchImageData(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"filename": filename}),
      );

      if (response.statusCode == 200) {
        print('Image fetched successfully for filename: $filename'); // Debug statement
        return response.bodyBytes; // This is already Uint8List
      } else {
        print('Failed to fetch image. Status code: ${response.statusCode}');
        print('Response body: ${response.body}'); // Log response body for further debugging
        return null; // Return null if fetching fails
      }
    } catch (e) {
      print('Error fetching image data: $e'); // Log any exceptions
      return null; // Return null in case of an error
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    print('Liking post with filename: $filename by $loggedInPerson'); // Debug statement

    // Optimistically update UI
    if (likedByUsers[filename] == null) {
      likedByUsers[filename] = [];
    }
    // Add the current user if not already liked
    if (!likedByUsers[filename]!.contains(loggedInPerson)) {
      likedByUsers[filename]!.add(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
      print('Liked successfully by $loggedInPerson'); // Debug statement
    } else {
      print('Failed to like post. Status code: ${response.statusCode}'); // Debug statement
      print('Response body: ${response.body}'); // Print response body for further debugging
    }
  }

  Future<void> removeLike(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');
    print('Removing like for post with filename: $filename by $loggedInPerson'); // Debug statement

    // Optimistically update UI
    if (likedByUsers[filename] != null) {
      likedByUsers[filename]!.remove(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
      print('Like removed successfully by $loggedInPerson'); // Debug statement
    } else {
      print('Failed to remove like. Status code: ${response.statusCode}'); // Debug statement
      print('Response body: ${response.body}'); // Print response body for further debugging
    }
  }

  Future<void> fetchLikes(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    print('Fetching likes for post: $filename'); // Debug statement
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likers = List<String>.from(data.map((like) => like['liker']));
      print('Likers: $likers'); // Debug statement

      likeCounts[filename] = likers.length;
      likedByUsers[filename] = likers;
    } else {
      print('Failed to fetch likes. Status code: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print response body for debugging
    }
  }

  Future<void> commentPost(String filename, String name, String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      print('Comment added');
      fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to add comment');
    }
  }

  Future<void> fetchComments(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      comments[filename] = jsonDecode(response.body);
    } else {
      print('Failed to fetch comments');
    }
  }
} */
/*working slow
 */
/* loading fast some error in possts screen
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/model/post_model.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  Map<String, int> likeCounts = {};
  Map<String, List<dynamic>> comments = {};
  Map<String, List<String>> likedByUsers = {};
  String loggedInPerson = "rajkiran"; // Example logged-in user
  bool _isLoading = false;
  int _currentPage = 0; // For pagination
  final int _postsPerPage = 10; // Define how many posts to load per request
  bool _hasMorePosts = true; // Flag to track if there are more posts to fetch

  List<Post> get posts => _posts;

  // Fetch posts method with pagination
  Future<void> fetchPosts() async {
    if (_isLoading || !_hasMorePosts) return; // Prevent multiple simultaneous requests

    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": loggedInPerson, "page": _currentPage, "limit": _postsPerPage}),
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = jsonDecode(response.body);

        // Check if fetched posts are empty to prevent further calls
        if (fetchedPosts.isEmpty) {
          _hasMorePosts = false;
          return;
        }

        // Create Post objects and sort them by timestamp in descending order
        _posts.addAll(fetchedPosts.map((json) => Post.fromJson(json)).toList()
          ..sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp))));

        // Fetch likes, comments, and images for each post
        for (var post in fetchedPosts) {
          await fetchLikes(post['filename']);
          await fetchComments(post['filename']);
          // Fetch image data and ensure it's not null
          Uint8List? imageData = await fetchImageData(post['filename']);
          // Update post object with image data
          Post postObj = _posts.firstWhere((p) => p.filename == post['filename']);
          postObj.imageBytes = imageData ?? Uint8List(0); // Default to empty Uint8List if null
        }

        _currentPage++; // Increment the page counter
        notifyListeners(); // Notify listeners to rebuild the UI
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      _isLoading = false; // Set loading to false after operation
      notifyListeners();
    }
  }

  // Fetch image data method
  Future<Uint8List?> fetchImageData(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"filename": filename}),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // This is already Uint8List
      } else {
        print('Failed to fetch image. Status code: ${response.statusCode}');
        return null; // Return null if fetching fails
      }
    } catch (e) {
      print('Error fetching image data: $e'); // Log any exceptions
      return null; // Return null in case of an error
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    print('Liking post with filename: $filename by $loggedInPerson'); // Debug statement

    // Optimistically update UI
    if (likedByUsers[filename] == null) {
      likedByUsers[filename] = [];
    }
    // Add the current user if not already liked
    if (!likedByUsers[filename]!.contains(loggedInPerson)) {
      likedByUsers[filename]!.add(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
      print('Liked successfully by $loggedInPerson'); // Debug statement
    } else {
      print('Failed to like post. Status code: ${response.statusCode}'); // Debug statement
    }
  }

  Future<void> removeLike(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');
    print('Removing like for post with filename: $filename by $loggedInPerson'); // Debug statement

    // Optimistically update UI
    if (likedByUsers[filename] != null) {
      likedByUsers[filename]!.remove(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
      print('Like removed successfully by $loggedInPerson'); // Debug statement
    } else {
      print('Failed to remove like. Status code: ${response.statusCode}'); // Debug statement
    }
  }

  Future<void> fetchLikes(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    print('Fetching likes for post: $filename'); // Debug statement
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likers = List<String>.from(data.map((like) => like['liker']));
      print('Likers: $likers'); // Debug statement

      likeCounts[filename] = likers.length;
      likedByUsers[filename] = likers;
    } else {
      print('Failed to fetch likes. Status code: ${response.statusCode}');
    }
  }

  Future<void> commentPost(String filename, String name, String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      print('Comment added');
      fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to add comment');
    }
  }

  Future<void> fetchComments(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      comments[filename] = jsonDecode(response.body);
    } else {
      print('Failed to fetch comments');
    }
  }

  // Call this method to clear and reset pagination if necessary
  void resetProvider() {
    _posts.clear();
    likeCounts.clear();
    comments.clear();
    likedByUsers.clear();
    _currentPage = 0;
    _hasMorePosts = true; // Reset hasMorePosts
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
some isssue to clear*/
/*slow
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/model/post_model.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  Map<String, int> likeCounts = {};
  Map<String, List<dynamic>> comments = {};
  Map<String, List<String>> likedByUsers = {};
  String loggedInPerson = "rajkiran"; // Example logged-in user

  bool _isLoading = false; // private loading state
  bool get isLoading => _isLoading; // public getter for loading state

  List<Post> get posts => _posts;

  // Fetch posts method
  Future<void> fetchPosts() async {
    if (_isLoading) return; // Prevent multiple simultaneous fetches
    _isLoading = true; // Set loading to true
    notifyListeners(); // Notify listeners to update UI

    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": loggedInPerson}),
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = jsonDecode(response.body);

        // Create Post objects and sort them by timestamp in descending order
        _posts = fetchedPosts.map((json) => Post.fromJson(json)).toList()
          ..sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

        // Fetch likes, comments, and images for each post
        for (var post in _posts) {
          await fetchLikes(post.filename);
          await fetchComments(post.filename);
          // Fetch image data and ensure it's not null
          Uint8List? imageData = await fetchImageData(post.filename);
          post.imageBytes = imageData ?? Uint8List(0); // Default to empty Uint8List if null
        }
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      _isLoading = false; // Reset loading state
      notifyListeners(); // Notify listeners to update UI
    }
  }

  // Fetch image data method
  Future<Uint8List?> fetchImageData(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"filename": filename}),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // This is already Uint8List
      } else {
        return null; // Return null if fetching fails
      }
    } catch (e) {
      print('Error fetching image data: $e'); // Log any exceptions
      return null; // Return null in case of an error
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');

    // Optimistically update UI
    if (likedByUsers[filename] == null) {
      likedByUsers[filename] = [];
    }
    // Add the current user if not already liked
    if (!likedByUsers[filename]!.contains(loggedInPerson)) {
      likedByUsers[filename]!.add(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
    } else {
      print('Failed to like post. Status code: ${response.statusCode}');
    }
  }

  Future<void> removeLike(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');

    // Optimistically update UI
    if (likedByUsers[filename] != null) {
      likedByUsers[filename]!.remove(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
    } else {
      print('Failed to remove like. Status code: ${response.statusCode}');
    }
  }

  Future<void> fetchLikes(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likers = List<String>.from(data.map((like) => like['liker']));

      likeCounts[filename] = likers.length;
      likedByUsers[filename] = likers;
    } else {
      print('Failed to fetch likes. Status code: ${response.statusCode}');
    }
  }

  Future<void> commentPost(String filename, String name, String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to add comment');
    }
  }

  Future<void> fetchComments(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      comments[filename] = jsonDecode(response.body);
    } else {
      print('Failed to fetch comments');
    }
  }
}

slow
/*comments issue*/
/*
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/model/post_model.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  Map<String, int> likeCounts = {};
  Map<String, List<dynamic>> comments = {};
  Map<String, List<String>> likedByUsers = {};
  String loggedInPerson = "rajkiran"; // Example logged-in user
  bool _isLoading = false; // To track loading state
  bool _isLoadingMore = false; // To track loading more posts

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;

  // Fetch initial posts
  Future<void> fetchPosts() async {
    if (_isLoading) return; // Prevent multiple fetch calls
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": loggedInPerson}),
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = jsonDecode(response.body);

        // Create Post objects and sort them by timestamp in descending order
        _posts = fetchedPosts.map((json) => Post.fromJson(json)).toList()
          ..sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

        // Fetch likes, comments, and images for each post
        for (var post in _posts) {
          await fetchLikes(post.filename);
          await fetchComments(post.filename);
          // Fetch image data and ensure it's not null
          Uint8List? imageData = await fetchImageData(post.filename);
          post.imageBytes = imageData ?? Uint8List(0); // Default to empty Uint8List if null
        }
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners to rebuild the UI
    }
  }

  // Fetch more posts
  Future<void> fetchMorePosts() async {
    if (_isLoadingMore) return; // Prevent multiple fetch calls
    _isLoadingMore = true;
    notifyListeners();

    // Add logic to fetch more posts based on your API design.
    // For now, I'll simulate it by fetching again, but you should implement pagination on the server.
    try {
      final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts'); // Adjust endpoint as necessary
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": loggedInPerson}),
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = jsonDecode(response.body);

        // Create Post objects and add them to existing posts
        List<Post> newPosts = fetchedPosts.map((json) => Post.fromJson(json)).toList();
        _posts.addAll(newPosts); // Append new posts
        _posts.sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

        // Fetch likes, comments, and images for each new post
        for (var post in newPosts) {
          await fetchLikes(post.filename);
          await fetchComments(post.filename);
          Uint8List? imageData = await fetchImageData(post.filename);
          post.imageBytes = imageData ?? Uint8List(0); // Default to empty Uint8List if null
        }
      }
    } catch (e) {
      print('Error fetching more posts: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners(); // Notify listeners to rebuild the UI
    }
  }

  Future<Uint8List?> fetchImageData(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"filename": filename}),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // This is already Uint8List
      } else {
        return null; // Return null if fetching fails
      }
    } catch (e) {
      print('Error fetching image data: $e'); // Log any exceptions
      return null; // Return null in case of an error
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');

    // Optimistically update UI
    if (likedByUsers[filename] == null) {
      likedByUsers[filename] = [];
    }
    // Add the current user if not already liked
    if (!likedByUsers[filename]!.contains(loggedInPerson)) {
      likedByUsers[filename]!.add(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
    }
  }

  Future<void> removeLike(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');

    // Optimistically update UI
    if (likedByUsers[filename] != null) {
      likedByUsers[filename]!.remove(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
    }
  }

  Future<void> fetchLikes(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likers = List<String>.from(data.map((like) => like['liker']));

      likeCounts[filename] = likers.length;
      likedByUsers[filename] = likers;
    }
  }

  Future<void> commentPost(String filename, String name, String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      fetchComments(filename); // Fetch comments again to update the view
    }
  }

  Future<void> fetchComments(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      comments[filename] = jsonDecode(response.body);
    }
  }
}
/*
working perfect loading faster comments issue
*//*
// lib/providers/posts_provider.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/model/post_model.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  Map<String, int> likeCounts = {};
  Map<String, List<dynamic>> comments = {};
  Map<String, List<String>> likedByUsers = {};
  String loggedInPerson = "rajkiran"; // Example logged-in user
  bool _isLoading = false; // Added loading state

  List<Post> get posts => _posts;

  bool get isLoading => _isLoading; // Getter for loading state

  // Fetch posts method
  Future<void> fetchPosts() async {
    _isLoading = true; // Start loading
    notifyListeners(); // Notify listeners to show loading state
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": loggedInPerson}),
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = jsonDecode(response.body);

        // Create Post objects and sort them by timestamp in descending order
        _posts = fetchedPosts.map((json) => Post.fromJson(json)).toList()
          ..sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

        // Fetch likes, comments, and images for each post
        for (var post in _posts) {
          await fetchLikes(post.filename);
          await fetchComments(post.filename);
          Uint8List? imageData = await fetchImageData(post.filename);
          post.imageBytes = imageData ?? Uint8List(0); // Default to empty Uint8List if null
        }
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      _isLoading = false; // Stop loading
      notifyListeners(); // Notify listeners to update UI
    }
  }

  // Fetch image data method
  Future<Uint8List?> fetchImageData(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"filename": filename}),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // This is already Uint8List
      } else {
        return null; // Return null if fetching fails
      }
    } catch (e) {
      print('Error fetching image data: $e'); // Log any exceptions
      return null; // Return null in case of an error
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    if (likedByUsers[filename] == null) {
      likedByUsers[filename] = [];
    }
    if (!likedByUsers[filename]!.contains(loggedInPerson)) {
      likedByUsers[filename]!.add(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename);
    }
  }

  Future<void> removeLike(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');
    if (likedByUsers[filename] != null) {
      likedByUsers[filename]!.remove(loggedInPerson);
      likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename);
    }
  }

  Future<void> fetchLikes(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likers = List<String>.from(data.map((like) => like['liker']));
      likeCounts[filename] = likers.length;
      likedByUsers[filename] = likers;
    }
  }

  Future<void> commentPost(String filename, String loggedInPerson,String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson, "content": content}),
    );

    if (response.statusCode == 200) {
      fetchComments(filename);
    }
  }

  Future<void> fetchComments(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      comments[filename] = jsonDecode(response.body);
    }
  }
}
*/*/




*/*/