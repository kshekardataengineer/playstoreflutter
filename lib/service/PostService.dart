import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../model/post2.dart';

class PostService {
  //static const String friendsUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/friendsoffriendsradius20';
  static const String friendsUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts';
  static const String profilePicUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_profilepic';

  Future<List<Post>> fetchPosts(String name) async {
    print('Fetching friends...');
    final response = await http.post(
      Uri.parse(friendsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,

      }),
    );

    if (response.statusCode == 200) {
      print('Response received');
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body.isNotEmpty) {
        print('posts list parsed');
        List<Post> posts = Post.fromJsonList(body);
        // Fetch profile pictures
        await _fetchProfilePictures(posts);
        return posts;
      } else {
        print('No posts found');
        return [];
      }
    } else {
      print('Failed to load posts: ${response.statusCode}');
      throw Exception('Failed to load posts');
    }
  }

  Future<void> _fetchProfilePictures(List<Post> posts) async {
    for (var post in posts) {
      final response = await http.post(
        Uri.parse(profilePicUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': post.friendName,
        }),
      );

      if (response.statusCode == 200) {
        print('Profile picture binary data fetched for ${post.friendName}');
        Uint8List profilePicBytes = response.bodyBytes;
        post.profilePic = 'data:image/jpeg;base64,' + base64Encode(profilePicBytes);
      } else {
        print('Failed to load profile picture for ${post.friendName}');
      }
    }
  }
}
