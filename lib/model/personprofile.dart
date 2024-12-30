class PersonProfile {
  final String name;
  final String city;
  final String state;
  final String country;
  final String dob;
  final String occupation;
  final String role;
  final String lat;
  final String lng;

  PersonProfile({
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    required this.dob,
    required this.occupation,
    required this.role,
    required this.lat,
    required this.lng,
  });

  factory PersonProfile.fromJson(Map<String, dynamic> json) {
    return PersonProfile(
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      dob: json['dob'] ?? '',
      occupation: json['occupation'] ?? '',
      role: json['role'] ?? '',
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
    );
  }
}
