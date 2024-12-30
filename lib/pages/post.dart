import 'dart:convert';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class post extends StatefulWidget {
  post({Key? key}) : super(key: key);

  static const String page_id = "Posts";

  @override
  _postState createState() => _postState();
}

class _postState extends State<post> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchPosts(1, 10); // Example parameters, adjust as needed
  }

  Future<List<Post>> fetchPosts(int page, int limit) async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "name": "nandu",
        "page": page,
        "limit": limit,
      }),
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
        appBar: _buildAppbar(),
        body: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No posts available'));
            }

            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.map((post) => PostContainer(post)).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        'Posts',
        style: TextStyle(fontFamily: 'medium', fontSize: 18, color: Colors.black),
      ),
    );
  }
}

class Post {
  final String username;
  final String location;
  final String filename; // filename of the image
  final String content;
  final int likes;
  final int comments;
  final String timestamp;
  final String userImage; // User profile image URL

  Uint8List? imageBytes; // To hold image data if needed

  Post({
    required this.username,
    required this.location,
    required this.filename,
    required this.content,
    required this.likes,
    required this.comments,
    required this.timestamp,
    required this.userImage,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'],
      location: json['location'],
      filename: json['filename'],
      content: json['content'],
      likes: json['likes'],
      comments: json['comments'],
      timestamp: json['timestamp'],
      userImage: json['userImage'], // Assuming user image URL is provided
    );
  }
}

class PostContainer extends StatelessWidget {
  final Post post;

  PostContainer(this.post);

  @override
  Widget build(BuildContext context) {
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
                          image: MemoryImage(post.imageBytes ?? Uint8List(0)),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.username,
                          style: TextStyle(fontFamily: 'medium', fontSize: 16),
                        ),
                        Text(
                          post.location,
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
                          child: BottomContainer(),
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
                  image: DecorationImage(
                      image: MemoryImage(post.imageBytes ?? Uint8List(0)),
                      fit: BoxFit.cover)),
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
              '${post.likes} likes',
              style: TextStyle(fontFamily: 'medium'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 320,
              child: RichText(
                text: TextSpan(
                  text: '${post.username} ',
                  style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'medium'),
                  children: <TextSpan>[
                    TextSpan(
                      text: post.content,
                      style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'regular'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'View all ${post.comments} comments',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              post.timestamp,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
