import 'dart:typed_data';

class Post {
  final String filename;
  final String content;
  final String friendName;
  final String timestamp;
  Uint8List? imageBytes; // Nullable image data

  Post({
    required this.filename,
    required this.content,
    required this.friendName,
    required this.timestamp,
    this.imageBytes,
  });

  // Convert JSON to Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      filename: json['filename'] as String,
      content: json['content'] as String,
      friendName: json['friendName'] as String,
      timestamp: json['timestamp'] as String,
      // imageBytes can be null, so we don't set it here
    );
  }

  // Optionally, you can add a method to convert Post to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'content': content,
      'friendName': friendName,
      'timestamp': timestamp,
      // Exclude imageBytes from JSON if not needed
    };
  }
}
