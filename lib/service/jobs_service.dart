import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:konktapp/model/job.dart';
import '../model/friend.dart';

class FriendService {
  //static const String friendsUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/friendsoffriendsradius20';
  static const String friendsUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/friendsoffriendsradius20levels';
  //static const String profilePicUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_profilepic';

  Future<List<Job>> fetchFriends(String name, String lat, String lng) async {
    print('Fetching friends...');
    final response = await http.post(
      Uri.parse(friendsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'lat': lat,
        'lng': lng,
      }),
    );

    if (response.statusCode == 200) {
      print('Response received');
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body.isNotEmpty) {
        print('jobs list parsed');
        List<Job> friends = Job.fromJsonList(body as List);
        // Fetch profile pictures
       // await _fetchProfilePictures(friends);
        return friends;
      } else {
        print('No jobs found');
        return [];
      }
    } else {
      print('Failed to load jobs: ${response.statusCode}');
      throw Exception('Failed to load jobs');
    }
  }

 /* Future<void> _fetchProfilePictures(List<Friend> friends) async
  {
    for (var friend in friends) {
      final response = await http.post(
        Uri.parse(profilePicUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': friend.name,
        }),
      );

      if (response.statusCode == 200) {
        print('Profile picture binary data fetched for ${friend.name}');
        Uint8List profilePicBytes = response.bodyBytes;
        friend.profilePic = 'data:image/jpeg;base64,' + base64Encode(profilePicBytes);
      } else {
        print('Failed to load profile picture for ${friend.name}');
      }
    }
  }*/
}
