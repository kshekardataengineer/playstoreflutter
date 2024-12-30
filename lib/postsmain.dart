import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(


  ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<List<Post>> fetchPosts() async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"name": "nandu"}), // Adjust the payload as needed
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return Future.wait(data.map((postJson) async {
        final post = Post.fromJson(postJson);
        post.imageBytes = await fetchImageData(post.filename);
        return post;
      }));
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Uint8List> fetchImageData(String filename) async {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Posts',
            style: TextStyle(fontFamily: 'medium', fontSize: 18, color: Colors.black),
          ),
        ),
        body: FutureBuilder<List<Post>>(
          future: fetchPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading posts: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return postContainer(post);
                },
              );
            } else {
              return Center(child: Text('No posts found'));
            }
          },
        ),
      ),
    );
  }

  Widget postContainer(Post post) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: AssetImage('assets/images/s8.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.friendName,
                          style: TextStyle(
                            fontFamily: 'medium',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'San Francisco', // Adjust if you have location info
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.5,
                          child: bottomContainer(),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: post.imageBytes != null
                    ? DecorationImage(
                  image: MemoryImage(post.imageBytes!),
                  fit: BoxFit.cover,
                )
                    : null,
                color: Colors.grey[300],
              ),
              child: post.imageBytes == null
                  ? Center(child: Text('No Image'))
                  : null,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_outline),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.comment_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.near_me_outlined),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_outline),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '88,022 likes', // Adjust based on your data
              style: TextStyle(fontFamily: 'medium'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 320,
              child: RichText(
                text: TextSpan(
                  text: '${post.friendName} ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'medium',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: post.content, // Adjust based on your data
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'regular',
                      ),
                    ),
                    TextSpan(
                      text: ' more...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'regular',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'View all 542 comments', // Adjust based on your data
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              post.formattedTimestamp,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomContainer() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Post to other apps..'),
            SizedBox(height: 20),
            Text('Copy link'),
            SizedBox(height: 20),
            Text('Share to...'),
            SizedBox(height: 20),
            Text('Archive'),
            SizedBox(height: 20),
            Text('Delete'),
            SizedBox(height: 20),
            Text('Edit'),
            SizedBox(height: 20),
            Text('Hide like comment'),
            SizedBox(height: 20),
            Text('Turn off commenting'),
          ],
        ),
      ),
    );
  }
}

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
