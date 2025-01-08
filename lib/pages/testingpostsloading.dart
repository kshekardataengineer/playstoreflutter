import 'dart:convert';
import 'dart:typed_data'; // For handling byte data of images
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsScreen1 extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen1> {
  List posts = [];
  Map<String, int> likeCounts = {};
  Map<String, List<dynamic>> comments = {};
  Map<String, List<String>> likedByUsers = {};
  String loggedInPerson = "rajkiran"; // Example logged-in user
  String? errorMessage;
  int currentPage = 0; // Track current page
  final int pageSize = 10; // Number of posts to load per page
  bool isLoading = false; // Loading state
  bool hasMorePosts = true; // Flag to check if more posts are available

  @override
  void initState() {
    super.initState();
    fetchPosts(); // Initial fetch
  }

  // Method to fetch posts
  Future<void> fetchPosts() async {
    if (isLoading || !hasMorePosts) return; // Prevent duplicate loading

    setState(() {
      isLoading = true; // Set loading state
    });
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }

    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_postsprotected');
    try {
      final response = await http.post(
        url,
       // headers: {"Content-Type": "application/json"},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"name": loggedInPerson, "page": currentPage, "size": pageSize}), // Pass pagination params
      );

      if (response.statusCode == 200) {
        List newPosts = jsonDecode(response.body);

        if (newPosts.isEmpty) {
          hasMorePosts = false; // No more posts to load
        } else {
          setState(() {
            posts.addAll(newPosts); // Append new posts
            currentPage++; // Increment page for next fetch
            errorMessage = null; // Clear any previous error message
            for (var post in newPosts) {
              fetchLikes(post['filename']);
              fetchComments(post['filename']);
              fetchImageData(post['filename']).then((imageBytes) {
                setState(() {
                  post['imageBytes'] = imageBytes; // Store image bytes in the post
                });
              });
            }
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load posts: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching posts: $e'; // Update the error message
      });
    } finally {
      setState(() {
        isLoading = false; // Reset loading state
      });
    }
  }

  // Method to fetch image data
  Future<Uint8List?> fetchImageData(String filename) async {
   // final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimageprotected');
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
     // return;
    }

    final response = await http.post(
      url,
     // headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // Return image data as bytes
    } else {
      print('Failed to fetch image');
      return null;
    }
  }

  Future<void> likePost(String filename) async {
   // final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlikeprotected');
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }

    // Optimistically update UI
    setState(() {
      if (likedByUsers[filename] == null) {
        likedByUsers[filename] = [];
      }
      // Add the current user if not already liked
      if (!likedByUsers[filename]!.contains(loggedInPerson)) {
        likedByUsers[filename]!.add(loggedInPerson);
        likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
      }
    });

    final response = await http.post(
      url,
      //headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
    } else {
      print('Failed to like post. Status code: ${response.statusCode}');
    }
  }

  Future<void> removeLike(String filename) async {
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deletelikedprotected');
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }

    // Optimistically update UI
    setState(() {
      if (likedByUsers[filename] != null) {
        likedByUsers[filename]!.remove(loggedInPerson);
        likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
      }
    });

    final response = await http.post(
      url,
     // headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
    } else {
      print('Failed to remove like. Status code: ${response.statusCode}');
    }
  }
  void _showErrorDialog( String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchLikes(String filename) async {
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedbyprotected');
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    final response = await http.post(
      url,
      //headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likers = List<String>.from(data.map((like) => like['liker']));

      setState(() {
        likeCounts[filename] = likers.length;
        likedByUsers[filename] = likers;
      });
    } else {
      print('Failed to fetch likes. Status code: ${response.statusCode}');
    }
  }

  Future<void> commentPost(String filename, String name, String content) async {
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }
   // final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcommentprotected');
    final response = await http.post(
      url,
     // headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to add comment');
    }
  }

  Future<void> fetchComments(String filename) async {
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }

    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedbyprotected');
    final response = await http.post(
      url,
      //headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      setState(() {
        comments[filename] = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch comments');
    }
  }

  void showCommentDialog(String filename) {
    String commentContent = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          onChanged: (value) {
            commentContent = value;
          },
          decoration: InputDecoration(hintText: "Enter your comment"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (commentContent.isNotEmpty) {
                commentPost(filename, loggedInPerson, commentContent);
                Navigator.pop(context);
              }
            },
            child: Text("Submit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void showCommentsDialog(String filename) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Comments & Likes"),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              // Likes Section
              Expanded(
                child: likedByUsers[filename] != null && likedByUsers[filename]!.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Liked by:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Expanded(
                      child: ListView(
                        children: likedByUsers[filename]!.map((user) => Text(user)).toList(),
                      ),
                    ),
                  ],
                )
                    : Text("No likes yet.", style: TextStyle(color: Colors.grey)),
              ),
              Divider(),
              // Comments Section
              Text("Comments:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Expanded(
                child: comments[filename] != null && comments[filename]!.isNotEmpty
                    ? ListView(
                  children: comments[filename]!.map((comment) {
                    return ListTile(
                      title: Text(comment['content']),
                      subtitle: Text("by ${comment['name']}"),
                    );
                  }).toList(),
                )
                    : Text("No comments yet.", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat.yMMMd().format(dateTime); // Format timestamp
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchPosts(); // Re-fetch posts when the widget is inserted into the tree
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posts")),
      body: Column(
        children: [
          if (errorMessage != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
            ),
          ],
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading &&
                    hasMorePosts &&
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  fetchPosts(); // Load more posts when scrolling to the bottom
                }
                return true;
              },
              child: ListView.builder(
                itemCount: posts.length + (isLoading ? 1 : 0), // Show loading indicator at the end if loading
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return Center(child: CircularProgressIndicator()); // Loading indicator
                  }

                  final post = posts[index];

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post['content'], style: TextStyle(fontSize: 16)),
                          if (post['imageBytes'] != null)
                            Image.memory(post['imageBytes']), // Display post image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      likedByUsers[post['filename']]?.contains(loggedInPerson) == true
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_outlined,
                                      color: likedByUsers[post['filename']]?.contains(loggedInPerson) == true
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      if (likedByUsers[post['filename']]?.contains(loggedInPerson) == true) {
                                        removeLike(post['filename']);
                                      } else {
                                        likePost(post['filename']);
                                      }
                                    },
                                  ),
                                  Text("${likeCounts[post['filename']] ?? 0} Likes"),
                                ],
                              ),
                              Text(formatTimestamp(post['timestamp'])),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => showCommentDialog(post['filename']),
                                child: Text("Comment"),
                              ),
                              TextButton(
                                onPressed: () => showCommentsDialog(post['filename']),
                                child: Text("View Comments"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
