/*class Friend {
  final String name;
  final String occupation;
  final String city;
  final String role;
  final double lat;
  final double lng;
  final double distance;

  Friend({
    required this.name,
    required this.occupation,
    required this.city,
    required this.role,
    required this.lat,
    required this.lng,
    required this.distance,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['friendName'],
      occupation: json['occupation'],
      city: json['city'],
      role: json['role'],
      lat: double.parse(json['lat']),
      lng: double.parse(json['lng']),
      distance: double.parse(json['distance (Km)']),
    );
  }
}*/
