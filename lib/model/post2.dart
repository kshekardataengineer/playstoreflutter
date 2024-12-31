// model/post.dart
import 'dart:typed_data';

class Post {
  final String content;
  final String filename;
  String profilePic;
  final String friendName;
  final String timestamp;
  Uint8List? profilePicBytes;
  Uint8List? imageBytes;

  Post({
    required this.content,
    this.profilePic = '',
    required this.filename,
    required this.friendName,
    required this.timestamp,
    this.profilePicBytes,
    this.imageBytes,
  });

  factory Post.fromJson(Map<String, dynamic> json, int i) {
    return Post(
      content: json['content'],
      filename: json['filename'],
      friendName: json['friendName'],
      timestamp: json['timestamp'],
      profilePic: '',
    );
  }


  static List<Post> fromJsonList(Map<String, dynamic> json) {
    int length = json.length;
    List<Post> friends = [];
    //friends.add(Post.fromJson(json));
    for (int i = 0; i < length; i++) {
      friends.add(Post.fromJson(json, i));
    }
    return friends;
  }
 /*factory Post.fromJson(Map<String, dynamic> json, int index) {
    return Post(

        profilePic: '', // Initially empty, to be updated
        content: json['content'],
        filename: json['filename'],
        friendName: json['friendName'],
        timestamp: json['timestamp'],
    );*/
  }




