// lib/screens/friends_screen.dart
/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:konktapp/pages/ProfileScreen.dart';
import 'package:konktapp/pages/tabs.dart';
import 'package:konktapp/pages/viewprofile.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';
import '../model/friend.dart' ;
//import 'ProfileScreen.dart';

class FriendsScreen extends StatefulWidget {
  late String name;
  late String lat;
  late String lng;
 // FriendsScreen({Key? key, required String name, required String lat, required String lng}) : super(key: key);
  FriendsScreen({
    Key? key,
    required this.name,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  static const String page_id = "FriendScreen";



  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _filterController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<FriendProvider>(context, listen: false).fetchDefaultFriends(name: widget.name, lat: '17.3730', lng: '78.5476');

      Provider.of<FriendProvider>(context, listen: false).fetchDefaultFriends(name: widget.name, lat: widget.lat, lng: widget.lng);
    });

    _filterController.addListener(() {
      Provider.of<FriendProvider>(context, listen: false).filterFriends(_filterController.text);
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _filterController.clear();
        Provider.of<FriendProvider>(context, listen: false).filterFriends('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(230),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: _isSearching
              ? TextField(
            controller: _filterController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
          )
              : Text(
            'Friends List',
            style: TextStyle(fontFamily: 'medium', fontSize: 18, color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                tabs.page_id,
                    (Route<dynamic> route) => false,
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: _toggleSearch,
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            margin: EdgeInsets.only(top: 60),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Text(
                  'Manage your friends and find new ones.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _filterController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by designation,city,state,country etc.',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<FriendProvider>(
        builder: (context, provider, _) {
          if (provider.friends.isEmpty) {
            return Center(child: Text('No friends found.'));
          } else {
            return ListView.builder(
              itemCount: provider.friends.length,
              itemBuilder: (context, index) {
                Friend friend = provider.friends[index];
                return ListTile(
                  leading: friend.profilePic.isEmpty
                      ? CircleAvatar(
                    backgroundImage: AssetImage('assets/images/default_profile_pic.jpg'),
                  )
                      : CircleAvatar(
                   backgroundImage: MemoryImage(
                      base64Decode(friend.profilePic.replaceFirst('data:image/jpeg;base64,', '')),

                    ),
                  ),
                  title: Text(friend.name),
                  subtitle: Text(friend.occupation),
                  //trailing: Text('${friend.level} level'),
                  trailing: Text('L${friend.level}'),
                  onTap: () {
                    // Navigate to ProfileScreen with friend.name
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewProfile(friendName: friend.name),
                      ),
                    );
                  },



                );
              },
            );
          }
        },
      ),
    );
  }
}

*/

/* working perfectly just to filter with multiple values
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FriendsScreen extends StatefulWidget {
  final String name;
  final String lat;
  final String lng;

  FriendsScreen({
    Key? key,
    required this.name,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  static const String page_id = "FriendScreen";

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _filterController = TextEditingController();
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _filteredFriends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
    _filterController.addListener(_filterFriends);
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  Future<void> _fetchFriends() async {
    final url =
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net//friendsoffriendsradius20levels';
    final body = {
      "name": widget.name,
      "lat": widget.lat,
      "lng": widget.lng,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        // Transform API response to a list of friend maps
        setState(() {
          _friends = _parseFriends(responseData);
          _filteredFriends = List.from(_friends);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load friends');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching friends: $error');
    }
  }

  List<Map<String, dynamic>> _parseFriends(Map<String, dynamic> data) {
    List<Map<String, dynamic>> friendsList = [];
    for (var index in data['friendName'].keys) {
      friendsList.add({
        'friendName': data['friendName'][index],
        'occupation': data['occupation'][index],
        'city': data['city'][index],
        'role': data['role'][index],
        'lat': data['lat'][index],
        'lng': data['lng'][index],
        'coordinates': data['coordinates'][index],
        'distance': data['distance (Km)'][index],
        'level': data['Level'][index],
      });
    }
    return friendsList;
  }

  void _filterFriends() {
    final query = _filterController.text.toLowerCase();
    setState(() {
      _filteredFriends = _friends.where((friend) {
        return friend.values
            .whereType<String>()
            .any((value) => value.toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _filterController,
          decoration: InputDecoration(
            hintText: 'Search by name, city, state, etc.',
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_filterController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _filterController.clear();
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredFriends.isEmpty
          ? Center(child: Text('No friends found.'))
          : ListView.builder(
        itemCount: _filteredFriends.length,
        itemBuilder: (context, index) {
          final friend = _filteredFriends[index];
          return ListTile(
            title: Text(friend['friendName'] ?? 'Unknown'),
            subtitle: Text(
                '${friend['occupation']}, ${friend['city'] ?? 'Unknown'}'),
            trailing: Text('L${friend['level']}'),
            onTap: () {
              // Navigate to ViewProfile screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewProfile(friendName: friend['friendName']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ViewProfile extends StatelessWidget {
  final String friendName;

  ViewProfile({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$friendName\'s Profile'),
      ),
      body: Center(
        child: Text('Viewing profile of $friendName'),
      ),
    );
  }
}
*/
/*perfectly working with multiple filter*/
/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/viewprofile.dart';

class FriendsScreen extends StatefulWidget {
  final String name;
  final String lat;
  final String lng;

  FriendsScreen({
    Key? key,
    required this.name,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  static const String page_id = "FriendScreen";

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _filterController = TextEditingController();
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _filteredFriends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
    _filterController.addListener(() {
      _filterFriends(_filterController.text);
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  Future<void> _fetchFriends() async {
    final url =
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net//friendsoffriendsradius20levels';
    final body = {
      "name": widget.name,
      "lat": widget.lat,
      "lng": widget.lng,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        setState(() {
          _friends = _parseFriends(responseData);
          _filteredFriends = List.from(_friends);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load friends');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching friends: $error');
    }
  }

  List<Map<String, dynamic>> _parseFriends(Map<String, dynamic> data) {
    List<Map<String, dynamic>> friendsList = [];
    for (var index in data['friendName'].keys) {
      friendsList.add({
        'name': data['friendName'][index],
        'occupation': data['occupation'][index],
        'city': data['city'][index],
        'role': data['role'][index],
        'lat': data['lat'][index],
        'lng': data['lng'][index],
        'coordinates': data['coordinates'][index],
        'distance': data['distance (Km)'][index],
        'level': data['Level'][index],
      });
    }
    return friendsList;
  }

  void _filterFriends(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFriends = List.from(_friends); // Reset to the original list
      });
    } else {
      // Split the query into terms by commas or spaces
      final terms = query
          .toLowerCase()
          .split(RegExp(r'[,\s]+')) // Match commas or spaces as separators
          .where((term) => term.isNotEmpty) // Exclude empty terms
          .toList();

      setState(() {
        _filteredFriends = _friends.where((friend) {
          // Normalize friend properties for case-insensitive matching
          final name = friend['name']?.toLowerCase() ?? '';
          final occupation = friend['occupation']?.toLowerCase() ?? '';
          final city = friend['city']?.toLowerCase() ?? '';
          final role = friend['role']?.toLowerCase() ?? '';
          final lat = friend['lat']?.toLowerCase() ?? '';
          final lng = friend['lng']?.toLowerCase() ?? '';
          final distance = friend['distance']?.toString().toLowerCase() ?? '';
          final level = friend['level']?.toString().toLowerCase() ?? '';

          // Ensure all terms match at least one property
          return terms.every((term) =>
          name.contains(term) ||
              occupation.contains(term) ||
              city.contains(term) ||
              role.contains(term) ||
              lat.contains(term) ||
              lng.contains(term) ||
              distance.contains(term) ||
              level.contains(term));
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _filterController,
          decoration: InputDecoration(
            hintText: 'Search by name, city, state, role, etc.',
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_filterController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _filterController.clear();
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredFriends.isEmpty
          ? Center(child: Text('No friends found.'))
          : ListView.builder(
        itemCount: _filteredFriends.length,
        itemBuilder: (context, index) {
          final friend = _filteredFriends[index];
          return ListTile(
            title: Text(friend['name'] ?? 'Unknown'),
            subtitle: Text(
                '${friend['occupation']}, ${friend['city'] ?? 'Unknown'}'),
            trailing: Text('L${friend['level']}'),

            onTap: () {
              // Navigate to ViewProfile screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewProfile(friendName: friend['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/


/*class ViewProfile extends StatelessWidget {
  final String friendName;

  ViewProfile({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$friendName\'s Profile'),
      ),
      body: Center(
        child: Text('Viewing profile of $friendName'),
      ),
    );
  }
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../testingsession.dart';
import 'viewprofile.dart'; // Import the ViewProfile screen
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsScreen extends StatefulWidget {
  final String name;
  final String lat;
  final String lng;
  static const String page_id = "FriendScreen";

  FriendsScreen({
    Key? key,
    required this.name,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _filterController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _friends = [];
  List<dynamic> _filteredFriends = [];

  @override
  void initState() {
    super.initState();
    fetchFriends();
    _filterController.addListener(() {
      filterFriends(_filterController.text);
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  // Fetch friends from the API
  Future<void> fetchFriends() async {
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }


    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/friendsoffriendsradius20levels');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/friendsoffriendsradius20levelsprotected');
    final response = await http.post(
      url,
      //headers: {'Content-Type': 'application/json'},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': widget.name,
        'lat': widget.lat,
        'lng': widget.lng
        /*'name': 'rajkiran',
        'lat': '17.3730',
        'lng': '78.5476'*/
      }),
    );
//name: 'rajkiran', lat: '17.3730', lng: '78.5476'
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        _friends = List.generate(responseBody['friendName'].length, (index) {
          return {
            'name': responseBody['friendName']['$index'],
            'occupation': responseBody['occupation']['$index'],
            'city': responseBody['city']['$index'],
            'role': responseBody['role']['$index'],
            'level': responseBody['Level']['$index'],
            'lat': responseBody['lat']['$index'],
            'lng': responseBody['lng']['$index'],
          };
        });
        _filteredFriends = List.from(_friends);
      });
    } else {
      print('Failed to fetch friends');
    }
  }

  // Filtering the list of friends based on search query
  void filterFriends(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFriends = List.from(_friends);
      });
    } else {
      final terms = query
          .toLowerCase()
          .split(RegExp(r'[,\s]+'))
          .where((term) => term.isNotEmpty)
          .toList();

      setState(() {
        _filteredFriends = _friends.where((friend) {
          final name = friend['name']?.toLowerCase() ?? '';
          final occupation = friend['occupation']?.toLowerCase() ?? '';
          final city = friend['city']?.toLowerCase() ?? '';
          final role = friend['role']?.toLowerCase() ?? '';

          // Check if each term matches any of the friend's details
          return terms.every((term) =>
          name.contains(term) ||
              occupation.contains(term) ||
              city.contains(term) ||
              role.contains(term));
        }).toList();
      });
    }
  }
/*uncommenting for shravan anna demo
  // Find the connection between two persons
  Future<void> findConnection(String person1, String person2) async {
   final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortesfriendtroute');
    //final url = Uri.parse('https://testkonkt.azurewebsites.net/findshortesfriendtroute');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'person1': person1, 'person2': person2}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as List<dynamic>;
      if (result.isNotEmpty && result[0]['connections'] != null) {
        List<String> connections = List<String>.from(result[0]['connections']);
        _showConnectionDialog(connections);
      } else {
        _showNoConnectionsDialog();
      }
    } else {
      print('Failed to find connections');
    }
  } *//*this hould be commenting to test using token*/


/*this should be used only commenting for shravan anna demo*/



  // Find the connection between two persons
  Future<void> findConnection( String person1, String person2) async {
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortesfriendtroute');
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortesfriendtroute_protected');
    // Retrieve the token from secure storage
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');








  if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'person1': person1, 'person2': person2}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as List<dynamic>;
        if (result.isNotEmpty && result[0]['connections'] != null) {
          List<String> connections = List<String>.from(result[0]['connections']);
          _showConnectionDialog(connections);
        } else {
          _showNoConnectionsDialog();
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized error (e.g., token expired)
        _showErrorDialog( 'Session expired. Please log in again.');
      } else {
        print('Failed to find connections: ${response.body}');
        _showErrorDialog( 'Failed to find connections. Please try again.${response.body}');
      }
    } catch (error) {
      print('Error finding connections: $error');
      _showErrorDialog( 'An error occurred. Please try again.');
    }
  }

  void _showErrorDialog( String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show dialog if no connections found
  void _showNoConnectionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Connections'),
          content: Text('There are no common friends between the two individuals.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show dialog with the connection path
  void _showConnectionDialog(List<String> connections) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Path'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: connections.length - 1,
              itemBuilder: (context, index) {
                bool isLastItem = index == connections.length - 2;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'L${index + 1} ${connections[index + 1]}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    if (!isLastItem)
                      Icon(Icons.arrow_downward, size: 24, color: Colors.black54),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _filterController,
          decoration: InputDecoration(hintText: 'Search... name,occupation,location'),
        )
            : Text('Friends List'),

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(name: widget.name),
              ),
                  (Route<dynamic> route) => false, // Removes all previous routes
            );
          },
        ),

        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _filterController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: _filteredFriends.isEmpty
          ? Center(child: Text('No friends found.'))
          : ListView.builder(
        itemCount: _filteredFriends.length,
        itemBuilder: (context, index) {
          final friend = _filteredFriends[index];
          return ListTile(
            title: Text(friend['name'] ?? 'Unknown'),
            subtitle: Text('${friend['occupation']}, ${friend['city']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('L${friend['level']}'),
                SizedBox(width: 8),
                IconButton(
                  //icon: Icon(Icons.network_check, color: Colors.blue),
                  icon:Icon(Icons.group, size: 50, color: Colors.blue),
                  onPressed: () {
                    findConnection(widget.name, friend['name']); //commented for demo
                   // findConnection('rajkiran', friend['name']);
                  },
                ),
              ],
            ),
            onTap: () {
              // Navigate to the ViewProfile screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProfile(loggedin:widget.name,friendName: friend['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
