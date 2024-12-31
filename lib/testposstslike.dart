/*working code
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List posts = [];
  Map<String, int> likeCounts = {}; // Store like counts for each post
  Map<String, List<dynamic>> comments = {};  // Store comments for each post
  Map<String, List<String>> likedByUsers = {}; // Store users who liked each post
  String loggedInPerson = "raj kiran"; // Example logged-in user

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": "rajkiran"}),
    );

    if (response.statusCode == 200) {
      setState(() {
        posts = jsonDecode(response.body);
      });
    } else {
      print('Failed to load posts');
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    print('Liking post with filename: $filename by $loggedInPerson'); // Debug statement
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

      setState(() {
        likeCounts[filename] = likers.length;
        likedByUsers[filename] = likers;
      });
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Likes Section
              likedByUsers[filename] != null && likedByUsers[filename]!.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Liked by:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  ...likedByUsers[filename]!.map((user) => Text(user)).toList(),
                  SizedBox(height: 10),
                ],
              )
                  : Text("No likes yet.", style: TextStyle(color: Colors.grey)),

              // Comments Section
              Text("Comments:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Expanded(
                child: (comments[filename] != null && comments[filename]!.isNotEmpty)
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments[filename]!.length,
                  itemBuilder: (context, index) {
                    final comment = comments[filename]![index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          comment['commenter'] ?? "Unknown",
                          style: TextStyle(fontWeight: FontWeight.bold), // Bold commenter name
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['commentContent'] ?? "No content"), // Comment content
                            SizedBox(height: 5),
                            Text(
                              formatTimestamp(comment['timestamp'] ?? ""),
                              style: TextStyle(color: Colors.grey, fontSize: 12), // Formatted timestamp
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Text("No comments available", style: TextStyle(color: Colors.grey)),
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
    if (timestamp.isEmpty) return "No timestamp";
    final dateTime = DateTime.parse(timestamp);
    final formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    return formattedDate; // Format as desired
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Logged in as: $loggedInPerson')), // Display logged-in user
          ),
        ],
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postLikes = likeCounts[post['filename']] ?? 0;
          final postComments = comments[post['filename']] ?? [];
          final userHasLiked = likedByUsers[post['filename']]?.contains(loggedInPerson) ?? false; // Check if the logged-in user has liked

          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(post['friendName']),
                  subtitle: Text(post['content']),
                  trailing: Text(post['timestamp']),
                ),
                Image.network(post['fileUrl']),
                ButtonBar(
                  children: [
                    Text("$postLikes likes"),
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up_alt_outlined,
                        color: userHasLiked ? Colors.red : Colors.grey, // Change color based on whether the user liked
                      ),
                      onPressed: () {
                        likePost(post['filename']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.comment_outlined),
                      onPressed: () {
                        showCommentDialog(post['filename']);
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        await fetchComments(post['filename']); // Fetch comments from the server
                        await fetchLikes(post['filename']); // Fetch likes for this post
                        showCommentsDialog(post['filename']);
                      },
                      child: Text("View All"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/

/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List posts = [];
  Map<String, int> likeCounts = {}; // Store like counts for each post
  Map<String, List<dynamic>> comments = {}; // Store comments for each post
  Map<String, List<String>> likedByUsers = {}; // Store users who liked each post
  String loggedInPerson = "raj kiran"; // Example logged-in user

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": "rajkiran"}),
    );

    if (response.statusCode == 200) {
      setState(() {
        posts = jsonDecode(response.body);
        // Initialize likeCounts and likedByUsers for each post
        for (var post in posts) {
          fetchLikes(post['filename']);
          fetchComments(post['filename']);
        }
      });
    } else {
      print('Failed to load posts');
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    print('Liking post with filename: $filename by $loggedInPerson'); // Debug statement

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

      setState(() {
        likeCounts[filename] = likers.length;
        likedByUsers[filename] = likers;
      });
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
          height: 300, // Set a height for the dialog
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
                        children: likedByUsers[filename]!
                            .map((user) => Text(user))
                            .toList(),
                      ),
                    ),
                  ],
                )
                    : Text("No likes yet.", style: TextStyle(color: Colors.grey)),
              ),

              // Comments Section
              Expanded(
                child: (comments[filename] != null && comments[filename]!.isNotEmpty)
                    ? ListView.builder(
                  itemCount: comments[filename]!.length,
                  itemBuilder: (context, index) {
                    final comment = comments[filename]![index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          comment['commenter'] ?? "Unknown",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['commentContent'] ?? "No content"),
                            SizedBox(height: 5),
                            Text(
                              formatTimestamp(comment['timestamp'] ?? ""),
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Text("No comments available", style: TextStyle(color: Colors.grey)),
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
    if (timestamp.isEmpty) return "No timestamp";
    final dateTime = DateTime.parse(timestamp);
    final formattedDate =
        "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    return formattedDate; // Format as desired
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Logged in as: $loggedInPerson')), // Display logged-in user
          ),
        ],
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postLikes = likeCounts[post['filename']] ?? 0;
          final postComments = comments[post['filename']] ?? [];
          final userHasLiked =
              likedByUsers[post['filename']]?.contains(loggedInPerson) ?? false;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(post['title'] ?? "No title"),
                  subtitle: Text(post['content'] ?? "No content"),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        userHasLiked ? Icons.favorite : Icons.favorite_border,
                        color: userHasLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        likePost(post['filename']);
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
                    Text('${postComments.length} comments'),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        fetchLikes(post['filename']); // Fetch likes for this post
                        showCommentsDialog(post['filename']);
                      },
                      child: Text("View All"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/
/* like unlike working
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List posts = [];
  Map<String, int> likeCounts = {}; // Store like counts for each post
  Map<String, List<dynamic>> comments = {}; // Store comments for each post
  Map<String, List<String>> likedByUsers = {}; // Store users who liked each post
  String loggedInPerson = "raj kiran"; // Example logged-in user

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": "rajkiran"}),
    );

    if (response.statusCode == 200) {
      setState(() {
        posts = jsonDecode(response.body);
        // Initialize likeCounts and likedByUsers for each post
        for (var post in posts) {
          fetchLikes(post['filename']);
          fetchComments(post['filename']);
        }
      });
    } else {
      print('Failed to load posts');
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    print('Liking post with filename: $filename by $loggedInPerson'); // Debug statement

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
    setState(() {
      if (likedByUsers[filename] != null) {
        likedByUsers[filename]!.remove(loggedInPerson);
        likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
      }
    });

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

      setState(() {
        likeCounts[filename] = likers.length;
        likedByUsers[filename] = likers;
      });
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
          height: 300, // Set a height for the dialog
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
                        children: likedByUsers[filename]!
                            .map((user) => Text(user))
                            .toList(),
                      ),
                    ),
                  ],
                )
                    : Text("No likes yet.", style: TextStyle(color: Colors.grey)),
              ),

              // Comments Section
              Expanded(
                child: (comments[filename] != null && comments[filename]!.isNotEmpty)
                    ? ListView.builder(
                  itemCount: comments[filename]!.length,
                  itemBuilder: (context, index) {
                    final comment = comments[filename]![index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          comment['commenter'] ?? "Unknown",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['commentContent'] ?? "No content"),
                            SizedBox(height: 5),
                            Text(
                              formatTimestamp(comment['timestamp'] ?? ""),
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Text("No comments available", style: TextStyle(color: Colors.grey)),
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
    if (timestamp.isEmpty) return "Unknown time";
    final DateTime dateTime = DateTime.parse(timestamp);
    return "${dateTime.hour}:${dateTime.minute} on ${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postLikes = likeCounts[post['filename']] ?? 0;
          final userHasLiked = likedByUsers[post['filename']]?.contains(loggedInPerson) ?? false;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(post['title'] ?? "No title"),
                  subtitle: Text(post['content'] ?? "No content"),
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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*//*  perfectly working without image
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List posts = [];
  Map<String, int> likeCounts = {}; // Store like counts for each post
  Map<String, List<dynamic>> comments = {}; // Store comments for each post
  Map<String, List<String>> likedByUsers = {}; // Store users who liked each post
  String loggedInPerson = "raj kiran"; // Example logged-in user

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": "rajkiran"}),
    );

    if (response.statusCode == 200) {
      setState(() {
        posts = jsonDecode(response.body);
        // Initialize likeCounts and likedByUsers for each post
        for (var post in posts) {
          fetchLikes(post['filename']);
          fetchComments(post['filename']);
        }
      });
    } else {
      print('Failed to load posts');
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    print('Liking post with filename: $filename by $loggedInPerson'); // Debug statement

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
    setState(() {
      if (likedByUsers[filename] != null) {
        likedByUsers[filename]!.remove(loggedInPerson);
        likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
      }
    });

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

      setState(() {
        likeCounts[filename] = likers.length;
        likedByUsers[filename] = likers;
      });
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
          height: 300, // Set a height for the dialog
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
                        children: likedByUsers[filename]!
                            .map((user) => Text(user))
                            .toList(),
                      ),
                    ),
                  ],
                )
                    : Text("No likes yet.", style: TextStyle(color: Colors.grey)),
              ),

              // Comments Section
              Expanded(
                child: (comments[filename] != null && comments[filename]!.isNotEmpty)
                    ? ListView.builder(
                  itemCount: comments[filename]!.length,
                  itemBuilder: (context, index) {
                    final comment = comments[filename]![index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          comment['commenter'] ?? "Unknown",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['commentContent'] ?? "No content"),
                            SizedBox(height: 5),
                            Text(
                              formatTimestamp(comment['timestamp'] ?? ""),
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Text("No comments available", style: TextStyle(color: Colors.grey)),
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
    if (timestamp.isEmpty) return "Unknown time";

    final DateTime dateTime = DateTime.parse(timestamp);

    // Use padLeft(2, '0') to ensure two-digit format for hour and minute
    final String formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} on ${dateTime.day}/${dateTime.month}/${dateTime.year}";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postLikes = likeCounts[post['filename']] ?? 0;
          final userHasLiked = likedByUsers[post['filename']]?.contains(loggedInPerson) ?? false;

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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} */
//posts loaded successfully but images loading again maintain
import 'dart:convert';
import 'dart:typed_data'; // For handling byte data of images
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List posts = [];
  Map<String, int> likeCounts = {}; // Store like counts for each post
  Map<String, List<dynamic>> comments = {}; // Store comments for each post
  Map<String, List<String>> likedByUsers = {
  }; // Store users who liked each post
  String loggedInPerson = "rajkiran"; // Example logged-in user
  String? errorMessage; // Error message variable

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

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
  }

  // Method to fetch image data
  Future<Uint8List?> fetchImageData(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
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
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    print(
        'Liking post with filename: $filename by $loggedInPerson'); // Debug statement

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
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
      print('Liked successfully by $loggedInPerson'); // Debug statement
    } else {
      print('Failed to like post. Status code: ${response
          .statusCode}'); // Debug statement
      print('Response body: ${response
          .body}'); // Print response body for further debugging
    }
  }

  Future<void> removeLike(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');
    print(
        'Removing like for post with filename: $filename by $loggedInPerson'); // Debug statement

    // Optimistically update UI
    setState(() {
      if (likedByUsers[filename] != null) {
        likedByUsers[filename]!.remove(loggedInPerson);
        likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
      }
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
      print('Like removed successfully by $loggedInPerson'); // Debug statement
    } else {
      print('Failed to remove like. Status code: ${response
          .statusCode}'); // Debug statement
      print('Response body: ${response
          .body}'); // Print response body for further debugging
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
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
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
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
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
      builder: (context) =>
          AlertDialog(
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
                            children: likedByUsers[filename]!.map((user) =>
                                Text(user)).toList(),
                          ),
                        ),
                      ],
                    )
                        : Text(
                        "No likes yet.", style: TextStyle(color: Colors.grey)),
                  ),
                  Divider(),
                  // Comments Section
                  Text("Comments:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Expanded(
                    child: comments[filename] != null &&
                        comments[filename]!.isNotEmpty
                        ? ListView.builder(
                      itemCount: comments[filename]!.length,
                      itemBuilder: (context, index) {
                        final comment = comments[filename]![index];
                        return ListTile(
                          title: Text(
                              comment['commentContent'] ?? "No content"),
                          subtitle: Text(
                              comment['commenter'] + ' at ' + formatTimestamp(
                                  comment['timestamp'] ?? "")),
                        );
                      },
                    )
                        : Text("No comments yet.",
                        style: TextStyle(color: Colors.grey)),
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
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/reportPost');
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

/* updating just to resolve bottom navigator blocking last post*/
  @override
  Widget build(BuildContext context) {
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
                      Text('${comments[post['filename']]?.length ??
                          0} comments'),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          fetchLikes(
                              post['filename']); // Fetch likes for this post
                          showCommentsDialog(post['filename']);
                        },
                        child: Text("View All"),
                      ),
                      IconButton(
                        icon: Icon(Icons.flag),
                        onPressed: () {
                          reportPost(post['filename']);
                        },
                      ),
                      Text('Report'),
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

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  appBar: AppBar(
        title: Text('Posts'),
      ),*///removed posts
      appBar: null,
      body: errorMessage != null
          ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
          : posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postLikes = likeCounts[post['filename']] ?? 0;
          final userHasLiked = likedByUsers[post['filename']]?.contains(loggedInPerson) ?? false;

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
                // Display image if available
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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

perfectly working code*/
}