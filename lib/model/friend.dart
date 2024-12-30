class Friend {
  final String name;
  String profilePic;
  final String occupation;
  final String city;
  final String role;
  final String state;//added newly
  final String country;//added newly after category filter
  final double lat;
  final double lng;
  final double distance;
  final int level;

  Friend({
    required this.name,
    this.profilePic = '',
    required this.occupation,
    required this.city,
    required this.role,
    required this.state,
    required this.country,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.level,

  });

  factory Friend.fromJson(Map<String, dynamic> json, int index) {
    return Friend(
        name: json['friendName'][index.toString()],
        profilePic: '', // Initially empty, to be updated
        occupation: json['occupation'][index.toString()],
        city: json['city'][index.toString()],
        role: json['role'][index.toString()],
        state: json['state'][index.toString()],//newly added
        country: json['country'][index.toString()],//newly added
        lat: double.parse(json['lat'][index.toString()]),
        lng: double.parse(json['lng'][index.toString()]),
        distance: json['distance (Km)'][index.toString()],
        level: json['Level'][index.toString()]
    );
  }

  static List<Friend> fromJsonList(Map<String, dynamic> json) {
    int length = json['friendName'].length;
    List<Friend> friends = [];
    for (int i = 0; i < length; i++) {
      friends.add(Friend.fromJson(json, i));
    }
    return friends;
  }
}
