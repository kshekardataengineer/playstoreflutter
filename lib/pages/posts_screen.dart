/*import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import 'package:intl/intl.dart';

class PostsScreen extends StatelessWidget {
  String loggedInPerson = 'rajkiran';

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);

    // Initial fetch on screen load
    postsProvider.fetchPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: postsProvider.posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Check if there are more posts to fetch and if the user is at the bottom of the list
          if (!postsProvider.hasMorePosts) return false;

          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            postsProvider.fetchPosts(); // Load more posts when scrolled to the bottom
          }
          return false;
        },
        child: ListView.builder(
          itemCount: postsProvider.posts.length + (postsProvider.hasMorePosts ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == postsProvider.posts.length) {
              return Center(child: CircularProgressIndicator()); // Show loader at the bottom
            }

            final post = postsProvider.posts[index];
            final postLikes = postsProvider.likeCounts[post.filename] ?? 0;
            final userHasLiked = postsProvider.likedByUsers[post.filename]?.contains(postsProvider.loggedInPerson) ?? false;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(post.content ?? "No title"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Posted by ${post.friendName}"),
                        SizedBox(height: 5),
                        Text(formatTimestamp(post.timestamp)),
                      ],
                    ),
                  ),
                  if (post.imageBytes != null)
                    Image.memory(
                      post.imageBytes! as Uint8List,
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
                            postsProvider.removeLike(post.filename);
                          } else {
                            postsProvider.likePost(post.filename);
                          }
                        },
                      ),
                      Text('$postLikes likes'),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          showCommentDialog(context, post.filename);
                        },
                      ),
                      Text('${postsProvider.comments[post.filename]?.length ?? 0} comments'),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          postsProvider.fetchLikes(post.filename);
                          showCommentsDialog(context, post.filename);
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

  void showCommentDialog(BuildContext context, String filename) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Add a Comment"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: "Enter your comment"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<PostsProvider>(context, listen: false)
                    .commentPost(filename, loggedInPerson, commentController.text);
                Navigator.of(ctx).pop();
              },
              child: Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void showCommentsDialog(BuildContext context, String filename) {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    List<dynamic> postComments = postsProvider.comments[filename] ?? [];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Comments"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: postComments.length,
              itemBuilder: (context, index) {
                // Ensure that the comment is not null and has the required properties
                final comment = postComments[index];
                final content = comment['content'] ?? 'No content';
                final name = comment['name'] ?? 'Unknown';

                return ListTile(
                  title: Text(content),
                  subtitle: Text(name),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
*/




// posts_screen.dart
// worked code
/*
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';

import 'package:intl/intl.dart';

class PostsScreen extends StatelessWidget {
  String loggedInPerson='rajkiran';
  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    postsProvider.fetchPosts(); // Fetch posts on screen load

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: postsProvider.posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: postsProvider.posts.length,
        itemBuilder: (context, index) {
          final post = postsProvider.posts[index];
          final postLikes = postsProvider.likeCounts[post.filename] ?? 0;
          final userHasLiked = postsProvider.likedByUsers[post.filename]?.contains(postsProvider.loggedInPerson) ?? false;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(post.content ?? "No title"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Posted by ${post.friendName}"),
                      SizedBox(height: 5),
                      Text(formatTimestamp(post.timestamp)),
                    ],
                  ),
                ),
                // Display image if available
                if (post.imageBytes != null)
                  Image.memory(
                    post.imageBytes! as Uint8List,
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
                          postsProvider.removeLike(post.filename);
                        } else {
                          postsProvider.likePost(post.filename);
                        }
                      },
                    ),
                    Text('$postLikes likes'),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        showCommentDialog(context, post.filename);
                      },
                    ),
                    Text('${postsProvider.comments[post.filename]?.length ?? 0} comments'),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        postsProvider.fetchLikes(post.filename);
                        showCommentsDialog(context, post.filename);
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

  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
    } catch (e) {
      return timestamp; // Return original timestamp if parsing fails
    }
  }

  void showCommentDialog(BuildContext context, String filename) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Add a Comment"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: "Enter your comment"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<PostsProvider>(context, listen: false)
                    .commentPost(filename, "rajkiran", commentController.text);
                Navigator.of(ctx).pop();
              },
              child: Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void showCommentsDialog(BuildContext context, String filename) {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    List<dynamic> postComments = postsProvider.comments[filename] ?? [];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Comments"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: postComments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(postComments[index]['content']),
                  subtitle: Text(postComments[index]['name']),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
*/
/* working but very slow
// posts_screen.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';

import 'package:intl/intl.dart';

class PostsScreen extends StatelessWidget {
  String loggedInPerson='rajkiran';
  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    postsProvider.fetchPosts(); // Fetch posts on screen load

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: postsProvider.posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: postsProvider.posts.length,
        itemBuilder: (context, index) {
          final post = postsProvider.posts[index];
          final postLikes = postsProvider.likeCounts[post.filename] ?? 0;
          final userHasLiked = postsProvider.likedByUsers[post.filename]?.contains(postsProvider.loggedInPerson) ?? false;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(post.content ?? "No title"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Posted by ${post.friendName}"),
                      SizedBox(height: 5),
                      Text(formatTimestamp(post.timestamp)),
                    ],
                  ),
                ),
                // Display image if available
                if (post.imageBytes != null)
                  Image.memory(
                    post.imageBytes! as Uint8List,
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
                          postsProvider.removeLike(post.filename);
                        } else {
                          postsProvider.likePost(post.filename);
                        }
                      },
                    ),
                    Text('$postLikes likes'),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        showCommentDialog(context, post.filename);
                      },
                    ),
                    Text('${postsProvider.comments[post.filename]?.length ?? 0} comments'),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        postsProvider.fetchLikes(post.filename);
                        showCommentsDialog(context, post.filename);
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

  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
    } catch (e) {
      return timestamp; // Return original timestamp if parsing fails
    }
  }

  void showCommentDialog(BuildContext context, String filename) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Add a Comment"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: "Enter your comment"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<PostsProvider>(context, listen: false)
                    .commentPost(filename, "rajkiran", commentController.text);
                Navigator.of(ctx).pop();
              },
              child: Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void showCommentsDialog(BuildContext context, String filename) {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    List<dynamic> postComments = postsProvider.comments[filename] ?? [];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Comments"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: postComments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(postComments[index]['content']),
                  subtitle: Text(postComments[index]['name']),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}*/
/*working but very slow
/* working perfect but some loading very late*/
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import 'package:intl/intl.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Fetch initial posts when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts();
    });

    // Load more posts when scrolled to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<PostsProvider>(context, listen: false).fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    final isLoading = postsProvider.isLoading; // Check loading state

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: postsProvider.posts.isEmpty
          ? Center(child: isLoading ? CircularProgressIndicator() : Text("No posts available"))
          : NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
            postsProvider.fetchPosts();
          }
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: postsProvider.posts.length + (isLoading ? 1 : 0), // Add loading item if loading
          itemBuilder: (context, index) {
            if (index == postsProvider.posts.length) {
              return Center(child: CircularProgressIndicator()); // Show loading indicator at the end
            }

            final post = postsProvider.posts[index];
            final postLikes = postsProvider.likeCounts[post.filename] ?? 0;
            final userHasLiked = postsProvider.likedByUsers[post.filename]?.contains(postsProvider.loggedInPerson) ?? false;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(post.content ?? "No title"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Posted by ${post.friendName}"),
                        SizedBox(height: 5),
                        Text(formatTimestamp(post.timestamp)),
                      ],
                    ),
                  ),
                  // Display image if available
                  if (post.imageBytes != null && post.imageBytes!.isNotEmpty)
                    Image.memory(
                      post.imageBytes!,
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
                            postsProvider.removeLike(post.filename);
                          } else {
                            postsProvider.likePost(post.filename);
                          }
                        },
                      ),
                      Text('$postLikes likes'),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          showCommentDialog(context, post.filename);
                        },
                      ),
                      Text('${postsProvider.comments[post.filename]?.length ?? 0} comments'),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          postsProvider.fetchLikes(post.filename);
                          showCommentsDialog(context, post.filename);
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

  void showCommentDialog(BuildContext context, String filename) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Add a Comment"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: "Enter your comment"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<PostsProvider>(context, listen: false)
                    .commentPost(filename, "rajkiran", commentController.text);
                Navigator.of(ctx).pop();
              },
              child: Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void showCommentsDialog(BuildContext context, String filename) {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    List<dynamic> postComments = postsProvider.comments[filename] ?? [];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Comments"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: postComments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(postComments[index]['content']),
                  subtitle: Text(postComments[index]['name']),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}*/
/*loading slow */
/* working excellent bull null issue
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import 'package:intl/intl.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch posts when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts();
    });

    // Listen for scroll events to load more posts
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<PostsProvider>(context, listen: false).fetchMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
//only  null issue loading properly
  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: postsProvider.posts.isEmpty
          ? Center(
        child: postsProvider.isLoading
            ? CircularProgressIndicator()
            : Text("No posts available"),
      )
          : ListView.builder(
        controller: _scrollController,
        itemCount: postsProvider.posts.length + (postsProvider.isLoadingMore ? 1 : 0), // Add loading item if loading more
        itemBuilder: (context, index) {
          if (index == postsProvider.posts.length) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator at the end
          }
          final post = postsProvider.posts[index];
          final postLikes = postsProvider.likeCounts[post.filename] ?? 0;
          final userHasLiked = postsProvider.likedByUsers[post.filename]?.contains(postsProvider.loggedInPerson) ?? false;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(post.content ?? "No title"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Posted by ${post.friendName}"),
                      SizedBox(height: 5),
                      Text(formatTimestamp(post.timestamp)),
                    ],
                  ),
                ),
                // Display image if available
                if (post.imageBytes != null && post.imageBytes!.isNotEmpty)
                  Image.memory(
                    post.imageBytes!,
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
                          postsProvider.removeLike(post.filename);
                        } else {
                          postsProvider.likePost(post.filename);
                        }
                      },
                    ),
                    Text('$postLikes likes'),
                  ],
                ),
                // Comment section
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: postsProvider.comments[post.filename]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final comment = postsProvider.comments[post.filename]![index];
                    return ListTile(
                      title: Text(comment['name']),
                      subtitle: Text(comment['content']),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
    } catch (e) {
      return timestamp; // Return original timestamp if parsing fails
    }
  }
}




/*
excellent speed in loading but comment 3 arguments issue*/
/*
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import 'package:intl/intl.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial posts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: postsProvider.isLoading && postsProvider.posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (!postsProvider.isLoading && scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
            // Fetch more posts when the user scrolls to the bottom
            postsProvider.fetchPosts();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: postsProvider.posts.length,
          itemBuilder: (context, index) {
            final post = postsProvider.posts[index];
            final postLikes = postsProvider.likeCounts[post.filename] ?? 0;
            final userHasLiked = postsProvider.likedByUsers[post.filename]?.contains(postsProvider.loggedInPerson) ?? false;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(post.content ?? "No title"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Posted by ${post.friendName}"),
                        SizedBox(height: 5),
                        Text(formatTimestamp(post.timestamp)),
                      ],
                    ),
                  ),
                  // Display image if available
                  if (post.imageBytes != null && post.imageBytes!.isNotEmpty)
                    Image.memory(
                      post.imageBytes!,
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
                            postsProvider.removeLike(post.filename);
                          } else {
                            postsProvider.likePost(post.filename);
                          }
                        },
                      ),
                      Text('$postLikes likes'),
                     //SizedBox(width: 3),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          showCommentDialog(context, post.filename);
                        },
                      ),
                      Text('${postsProvider.comments[post.filename]?.length ?? 0} comments'),
                      //SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () {
                          postsProvider.fetchLikes(post.filename);
                          showCommentsDialog(context, post.filename);
                        },
                        child: Text("View Comments"),
                      ),
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

  String formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formatter = DateFormat('yyyy-MM-dd – kk:mm');
    return formatter.format(dateTime);
  }

  void showCommentDialog(BuildContext context, String filename) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Add a Comment"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(labelText: 'Comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  Provider.of<PostsProvider>(context, listen: false)
                     // .commentPost(filename, commentController.text);
                .commentPost(filename, "rajkiran", commentController.text);
                  Navigator.of(ctx).pop();
                }
              },
              child: Text("Submit"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void showCommentsDialog(BuildContext context, String filename) {
    final comments = Provider.of<PostsProvider>(context).comments[filename] ?? [];
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Comments"),
          content: SingleChildScrollView(
            child: ListBody(
              children: comments.map((comment) {
                return ListTile(
                  title: Text(comment['content']),
                  subtitle: Text("by ${comment['name']}"),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
*/
*/
/*renderflex issue*/
/*
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import 'package:intl/intl.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch posts when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts();
    });

    // Listen for scroll events to load more posts
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<PostsProvider>(context, listen: false).fetchMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
//only  null issue loading properly
  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: postsProvider.posts.isEmpty
          ? Center(
        child: postsProvider.isLoading
            ? CircularProgressIndicator()
            : Text("No posts available"),
      )
          : ListView.builder(
        controller: _scrollController,
        itemCount: postsProvider.posts.length + (postsProvider.isLoadingMore ? 1 : 0), // Add loading item if loading more
        itemBuilder: (context, index) {
          if (index == postsProvider.posts.length) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator at the end
          }
          final post = postsProvider.posts[index];
          final postLikes = postsProvider.likeCounts[post.filename] ?? 0;
          final userHasLiked = postsProvider.likedByUsers[post.filename]?.contains(postsProvider.loggedInPerson) ?? false;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(post.content ?? "No title"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Posted by ${post.friendName}"),
                      SizedBox(height: 5),
                      Text(formatTimestamp(post.timestamp)),
                    ],
                  ),
                ),
                // Display image if available
                if (post.imageBytes != null && post.imageBytes!.isNotEmpty)
                  Image.memory(
                    post.imageBytes!,
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
                          postsProvider.removeLike(post.filename);
                        } else {
                          postsProvider.likePost(post.filename);
                        }
                      },
                    ),
                    Text('$postLikes likes'),
                  ],
                ),
                // Comment section
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: postsProvider.comments[post.filename]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final comment = postsProvider.comments[post.filename]![index];
                    return ListTile(
                      title: Text(comment['name']),
                      subtitle: Text(comment['content']),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
    } catch (e) {
      return timestamp; // Return original timestamp if parsing fails
    }
  }
}
*/