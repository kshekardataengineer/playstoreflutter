
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:konktapp/pages/readcontacts.dart';

import 'package:intl/intl.dart';
import 'package:konktapp/pages/sosonoff.dart';
import 'package:konktapp/pages/userlistscreenmessages.dart';

import 'package:provider/provider.dart';

import '../providers/UserProvider.dart';
import '../providers/auth_provider.dart';

import 'ProfileScreen.dart';
import 'appsosnotifications.dart';
import 'friendscreenlist.dart';
import 'friendsonmap.dart';

import 'login.dart';
import 'microservices.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PostsScreen extends StatefulWidget {
  final String name;

  // Accept the name as a parameter
  PostsScreen({required this.name});
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List posts = [];
  Map<String, int> likeCounts = {}; // Store like counts for each post
  Map<String, List<dynamic>> comments = {}; // Store comments for each post
  Map<String, List<String>> likedByUsers = {
  }; // Store users who liked each post
 String loggedInPerson = "rajkiran";
 // String? loggedInPerson; // Example logged-in user
  String? errorMessage; // Error message variable


  @override
  void initState() {
    super.initState();
    // loadLoggedInPerson();

    fetchPosts(widget.name);


  }

/*working
  // Method to fetch posts
  Future<void> fetchPosts() async {
    // final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends__posts_L1');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": loggedInPerson}),
      );

      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          errorMessage = null; // Clear any previous error message
          for (var post in posts) {
            fetchLikes(post['filename']);
            fetchComments(post['filename']);
            // Fetch the image for each post
            fetchImageData(post['filename']).then((imageBytes) {
              setState(() {
                post['imageBytes'] =
                    imageBytes; // Store image bytes in the post
              });
            });
          }
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load posts: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching posts: $e'; // Update the error message
      });
    }
  }*/


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
  Future<void> fetchPosts(String name) async {

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



    // Fetch loggedInPerson from UserProvider
    //String? loggedInPerson = Provider.of<UserProvider>(context, listen: false).loggedInPerson;


    // Ensure loggedInPerson is not null
    /* if (loggedInPerson == null) {
      throw Exception('User not logged in');
    }*/

    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends__posts_L1');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends__posts_L1_protected');


    try {

      final response = await http.post(
        url,
       // headers: {"Content-Type": "application/json"},
      //  body: jsonEncode({"name": "rajkiran"}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"name": widget.name}),
      );

      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          errorMessage = null; // Clear any previous error message
          for (var post in posts) {
            // Fetch likes and comments for each post
            fetchLikes(post['filename']);
            fetchComments(post['filename']);

            // Fetch the image for each post (if exists)
            fetchImageData(post['filename']).then((imageBytes) {
              setState(() {
                post['imageBytes'] = imageBytes; // Store image bytes in the post
              });
            });
          }
        });
      }
      else if(response.statusCode == 404){

        errorMessage = 'No posts to load';
      }

      else {
        setState(() {
          errorMessage = 'Failed to load posts: ${response.statusCode}';

        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching posts: $e'; // Update the error message
      });
    }
  }





  // Method to fetch image data
  Future<Uint8List?> fetchImageData(String filename) async {
    final _secureStorage = const FlutterSecureStorage();
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      //return;
    }
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimageprotected');
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
      return response.bodyBytes; // Return image data as bytes
    } else {
      print('Failed to fetch image');
      return null;
    }
  }

  Future<void> likePost(String filename) async {
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    final _secureStorage = const FlutterSecureStorage();
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      //return;
    }

    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlikeprotected');
    print(
        'Liking post with filename: $filename by $loggedInPerson'); // Debug statement
    loggedInPerson=widget.name;
    // Optimistically update UI
    setState(() {
      if (likedByUsers[filename] == null) {
        likedByUsers[filename] = [];
      }
      // Add the current user if not already liked
      if (!likedByUsers[filename]!.contains(widget.name)) {
        likedByUsers[filename]!.add(widget.name);
        likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
      }
    });

    final response = await http.post(
      url,
      /*headers: {"Content-Type": "application/json"},*/
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename, "name": widget.name}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
      print('Liked successfully by $widget.name'); // Debug statement
    } else {
      print('Failed to like post. Status code: ${response
          .statusCode}'); // Debug statement
      print('Response body: ${response
          .body}'); // Print response body for further debugging
    }
  }

  Future<void> removeLike(String filename) async {
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

    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deletelikedprotected');
    print(
        'Removing like for post with filename: $filename by $widget.name'); // Debug statement
    loggedInPerson=widget.name;
    // Optimistically update UI
    setState(() {
      if (likedByUsers[filename] != null) {
        likedByUsers[filename]!.remove(widget.name);
        likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
      }
    });

    final response = await http.post(
      url,
      //headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename, "name": widget.name}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
      print('Like removed successfully by $widget.name'); // Debug statement
    } else {
      print('Failed to remove like. Status code: ${response
          .statusCode}'); // Debug statement
      print('Response body: ${response
          .body}'); // Print response body for further debugging
    }
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
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedbyprotected');
    print('Fetching likes for post: $filename'); // Debug statement
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
      print('Likers: $likers'); // Debug statement

      setState(() {
        likeCounts[filename] = likers.length;
        likedByUsers[filename] = likers;
      });
    } else {
      print('Failed to fetch likes. Status code: ${response.statusCode}');
      print('Response body: ${response
          .body}'); // Print response body for debugging
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
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcommentprotected');
    final response = await http.post(
      url,
      //headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
          {"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      print('Comment added');
      fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to add comment');
    }
  }

  Future<void> fetchComments(String filename) async {

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
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
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
    loggedInPerson=widget.name;
    if (response.statusCode == 200) {
      setState(() {
        comments[filename] = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch comments');
    }
  }

  void showCommentDialog(String filename) {
    loggedInPerson=widget.name;
    String commentContent = '';
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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
                    commentPost(filename, widget.name, commentContent);
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

  //debugging code to find error
  void showCommentsDialog(String filename) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Comments & Likes"),
        content: Container(
          width: double.maxFinite,
          height: 300, // Set a height for the dialog
          child: Column(
            children: [
              // Likes Section
              Expanded(
                child: likedByUsers[filename] != null &&
                    likedByUsers[filename]!.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Liked by:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Expanded(
                      child: ListView(
                        children: likedByUsers[filename]!
                            .map((user) => Text(user))
                            .toList(),
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
                child: comments[filename] != null &&
                    comments[filename]!.isNotEmpty
                    ? ListView.builder(
                  itemCount: comments[filename]!.length,
                  itemBuilder: (context, index) {
                    final comment = comments[filename]![index];

                    // Print the comment data to inspect its structure
                    print('Comment at index $index: $comment');

                    // Check if the comment has the required fields
                    if (comment is Map<String, dynamic> &&
                        comment.containsKey('commentContent') &&
                        comment.containsKey('commenter') &&
                        comment.containsKey('timestamp')) {
                      final commentContent =
                          comment['commentContent'] ?? "No content";
                      final commenter = comment['commenter'] ?? "Anonymous";
                      final timestamp =
                      formatTimestamp(comment['timestamp'] ?? "");

                      return ListTile(
                        title: Text(commentContent),
                        subtitle: Text('$commenter at $timestamp'),
                      );
                    } else {
                      // Log the invalid comment data
                      print("Invalid comment data at index $index: $comment");
                      return ListTile(
                        title: Text("Invalid comment data"),
                      );
                    }
                  },
                )
                    : Text("No comments yet.", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }



  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
    } catch (e) {
      return timestamp; // Return original timestamp if parsing fails
    }
  }
  Future<void> reportPostApi(String filename, String name, String content) async {
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

    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/reportPost');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/reportPostprotected');
    final response = await http.post(
      url,
      //headers: {"Content-Type": "application/json"},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      print('reported successfully');
      fetchPosts(widget.name);
      // fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to report');
    }
  }

  void reportPost(String filename) {
    String commentContent = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Report"),
        content: TextField(
          onChanged: (value) {
            commentContent = value;
          },
          decoration: InputDecoration(hintText: "Enter your report"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (commentContent.isNotEmpty) {
                reportPostApi(filename, loggedInPerson!, commentContent);
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

  @override
  Widget build(BuildContext context) {
  //  final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: null,
      body: errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.red),
        ),
      )
          : posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .padding
                .bottom + 16, // Adjust for bottom navigation
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final postLikes = likeCounts[post['filename']] ?? 0;
            final userHasLiked =
                likedByUsers[post['filename']]?.contains(loggedInPerson) ??
                    false;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(post['content'] ?? "No title"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Posted by ${post['friendName']}"),
                        SizedBox(height: 5),
                        Text(formatTimestamp(post['timestamp'] ?? "")),
                      ],
                    ),
                  ),
                  if (post['imageBytes'] != null)
                    Image.memory(
                      post['imageBytes'], // Use the image bytes from the post
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          userHasLiked ? Icons.favorite : Icons.favorite_border,
                          color: userHasLiked ? Colors.red : null,
                        ),
                        onPressed: () {
                          if (userHasLiked) {
                            removeLike(post['filename']);
                          } else {
                            likePost(post['filename']);
                          }
                        },
                      ),
                      Text('$postLikes likes'),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          showCommentDialog(post['filename']);
                        },
                      ),
                      Text('${comments[post['filename']]?.length ?? 0} comments'),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          fetchLikes(post['filename']); // Fetch likes for this post
                          showCommentsDialog(post['filename']);
                        },
                        child: Text("View All"),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Report') {
                            // Call the API to report the post directly
                            reportPostApi(
                              post['filename'], // Pass the filename
                              loggedInPerson!,  // Pass the logged-in user name
                              "Content is not appropriate", // Default report content
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'Report',
                            child: Text('Report'),
                          ),
                        ],
                        icon: Icon(Icons.more_vert),
                      )

                    ],
                  ),
                ],
              ),
            );


          },
        ),
      ),
    );
  }
}

