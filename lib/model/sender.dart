class Sender {
  final String name;
  String profilePic;

  Sender({required this.name, this.profilePic = ''});

  // Factory constructor to create a Sender from JSON
  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      name: json['sender'] as String,
      profilePic: '', // Initialize with empty profilePic
    );
  }

  // Method to convert Sender object to JSON
  Map<String, dynamic> toJson() {
    return {
      'sender': name,
      'profilePic': profilePic,
    };
  }

  // Static method to create a list of Sender from JSON
  static List<Sender> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((dynamic item) => Sender.fromJson(item as Map<String, dynamic>)).toList();
  }
}
