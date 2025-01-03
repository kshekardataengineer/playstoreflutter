import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:konktapp/pages/techniciandetailsscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:io';

import 'ViewTechnicianProfile.dart';
import 'chat_screen.dart';

class ViewProfile extends StatefulWidget {
  final String friendName;
  final String loggedin;

  ViewProfile({required this.loggedin,required this.friendName});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  late Future<Friend3> _friendFuture;
  late Friend3 _friend;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadFriendDetails();
  }

  void _loadFriendDetails() {
    setState(() {
      _friendFuture = _fetchFriendDetails(widget.friendName);
    });
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
  Future<Friend3> _fetchFriendDetails(String name) async {
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      //return;
    }
    final response = await http.post(
      //Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/searchperson'),


      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/searchpersonprotected'),
      /*headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },*/
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final friendData = data[0];

        // Fetch profile picture
        final profilePicResponse = await http.post(
          //Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_profilepic'),
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_profilepicprotected'),
          /*headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },*/
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{'name': name}),
        );

        String profilePicBase64 = '';
        if (profilePicResponse.statusCode == 200) {
          profilePicBase64 = base64Encode(profilePicResponse.bodyBytes);
        }

        return Friend3.fromJson(friendData, profilePicBase64);
      } else {
        throw Exception('No friend data found');
      }
    } else {
      throw Exception('Failed to load friend details');
    }
  }

  Future<void> _updateProfilePicture() async {
    if (!_isEditing) return; // Only allow picture update in edit mode

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final response = await _uploadProfilePicture(file, widget.friendName);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(await response.stream.bytesToString());
        final imageName = responseBody['imageName'];

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('$imageName uploaded successfully to Azure Blob Storage!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        // Reload friend details to refresh the profile picture
        _loadFriendDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile picture')),
        );
      }
    }
  }

  Future<http.StreamedResponse> _uploadProfilePicture(File file, String name) async {

    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      //return;
    }
    final request = http.MultipartRequest(
      'POST',
      //Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploading'),
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadingprotected'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    return await request.send();
  }

  Future<void> _saveChanges() async {

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
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Send the updated friend data to your API
      final response = await http.post(
       // Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/updateperson'),
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/updatepersonprotected'),
        /*headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },*/
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _friend.name,
          'dob': _friend.dob,
          'occupation': _friend.occupation,
          'role': _friend.role,
          'city': _friend.city,
          'state': _friend.state,
          'country': _friend.country,
          'lat': _friend.lat.toString(),
          'lng': _friend.lng.toString(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() {
          _isEditing = false; // Exit editing mode after saving changes
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }


/*adding code*/
  Future<void> findConnection(String person1, String person2) async {
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortesfriendtroute');
    // final url = Uri.parse('https://testkonkt.azurewebsites.net/findshortesfriendtroute');findshortesfriendtroute_protected
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortesfriendtroute_protected');
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');



    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog('Authentication error. Please log in again.');
      return;
    }
    try {
      final response = await http.post(
        url,
       // headers: {'Content-Type': 'application/json'},//commented to add token
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        //body: jsonEncode({'person1': person1, 'person2': person2}),
        body: jsonEncode({'person1': widget.loggedin, 'person2': person2}),
      );

      print('Response status: ${response
          .statusCode}'); // Debugging: check status code
      print(
          'Response body: ${response.body}'); // Debugging: check response body

      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        if (result.isNotEmpty && result[0]['connections'] != null) {
          List<String> connections = List<String>.from(
              result[0]['connections']);
          _showConnectionDialog(connections);
        } else {
          _showNoConnectionsDialog();
        }
      } else {
        print('Failed to find connections');
      }
    }
    catch (error) {
      print('Error finding connections: $error');
      _showErrorDialog( 'An error occurred. Please try again.');
    }
  }
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

  /*void _showConnectionDialog(List<String> connections) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Path'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: connections.length,
              itemBuilder: (context, index) {
                return Text('${index + 1}. ${connections[index]}');
              },
            ),
          ),
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
  }*/

  void _showConnectionDialog(List<String> connections) {
    showDialog(
      context: context, // Access BuildContext directly here
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Path'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: connections.length - 1, // Adjust item count to skip the first item
              itemBuilder: (context, index) {
                bool isLastItem = index == connections.length - 2; // Adjust for skipped index 0

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Box for each connection
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        'L${index + 1} ${connections[index + 1]}', // Skip the first item in the list
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Add an arrow if not the last item
                    if (!isLastItem)
                      Icon(
                        Icons.arrow_downward,
                        size: 24,
                        color: Colors.black54,
                      ),
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


/* original code 1.rajkiran showing
  void _showConnectionDialog(List<String> connections) {
    showDialog(
      context: context, // Access BuildContext directly here
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Path'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: connections.length,
              itemBuilder: (context, index) {
                bool isLastItem = index == connections.length - 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Box for each connection
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        '${index + 1}. ${connections[index]}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Add an arrow if not the last item
                    if (!isLastItem)
                      Icon(
                        Icons.arrow_downward,
                        size: 24,
                        color: Colors.black54,
                      ),
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
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Profile')),
      body: FutureBuilder<Friend3>(
        future: _friendFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          _friend = snapshot.data!;

          return SingleChildScrollView( // Makes the screen scrollable
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _isEditing ? _updateProfilePicture : null, // Enable only when editing
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _friend.profilePic.isNotEmpty
                            ? MemoryImage(base64Decode(_friend.profilePic))
                            : AssetImage('assets/default_profile_pic.png') as ImageProvider,
                        child: _isEditing
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _friend.name,
                    decoration: InputDecoration(labelText: 'Name'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.name = value ?? _friend.name,
                  ),
                  TextFormField(
                    initialValue: _friend.dob,
                    decoration: InputDecoration(labelText: 'Date of Birth'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.dob = value ?? _friend.dob,
                  ),
                  TextFormField(
                    initialValue: _friend.occupation,
                    decoration: InputDecoration(labelText: 'Occupation'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.occupation = value ?? _friend.occupation,
                  ),
                  TextFormField(
                    initialValue: _friend.city,
                    decoration: InputDecoration(labelText: 'City'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.city = value ?? _friend.city,
                  ),
                  TextFormField(
                    initialValue: _friend.state,
                    decoration: InputDecoration(labelText: 'State'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.state = value ?? _friend.state,
                  ),
                  TextFormField(
                    initialValue: _friend.country,
                    decoration: InputDecoration(labelText: 'Country'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.country = value ?? _friend.country,
                  ),
                  TextFormField(
                    initialValue: _friend.role,
                    decoration: InputDecoration(labelText: 'Role'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.role = value ?? _friend.role,
                  ),
                /*  TextFormField(
                    initialValue: _friend.lat.toString(),
                    decoration: InputDecoration(labelText: 'Latitude'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.lat = double.parse(value ?? '0.0'),
                  ),
                  TextFormField(
                    initialValue: _friend.lng.toString(),
                    decoration: InputDecoration(labelText: 'Longitude'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _friend.lng = double.parse(value ?? '0.0'),
                  ),*/
                  SizedBox(height: 16),
                  ElevatedButton(
                  /*  onPressed: _isEditing ? _saveChanges : () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),*/
                    onPressed: () {
                      // Navigate to ChatScreen and pass the friend's name as sender
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(sender: _friend.name, loggedinPerson: '', otherPerson:  _friend.name,),
                        ),
                      );

                    },
                    child: Text("Chat with ${_friend.name}"),
                  ),
                  SizedBox(height: 16),

                  // Find Connection Button
                  ElevatedButton(
                    onPressed: () {
                     // String loggedInUserName = "rajkiran"; // Replace with actual logged-in username
                      // findConnection(loggedInUserName, widget.technicianName);
                     // findConnection(loggedInUserName, "krishna");//working
                     // findConnection(loggedInUserName,  _friend.name);//testing

                      findConnection(widget.loggedin,  _friend.name);//testing

                      // To test dialog without API, uncomment:
                      // _showConnectionDialog(['Friend A', 'Friend B', 'Friend C']);
                      // or
                      // _showNoConnectionsDialog();
                    },
                    child: Text('Find Connection'),
                  ),
                  SizedBox(height: 16),

                  // Find Connection Button
            ElevatedButton(
              onPressed: () {
                String technicianName = "rajkiran";  // The name you want to pass
                bool editable = false;  // Set editable to false

                // Navigate to the technician profile screen and pass both technicianName and editable
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewTechnicianProfile(
                      technicianName:  _friend.name,
                      editable: editable,  // Pass the editable value
                    ),
                  ),
                );
              },
              child: Text('View Technician Profile'),
            ),




                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Friend3 {
  String name;
  String profilePic;
  String occupation;
  String city;
  String role;
  String dob;
  String state;
  String country;
  double lat;
  double lng;

  Friend3({
    required this.name,
    this.profilePic = '',
    required this.occupation,
    required this.city,
    required this.role,
    this.dob = '',
    this.state = '',
    this.country = '',
    this.lat = 0.0,
    this.lng = 0.0,
  });

  factory Friend3.fromJson(Map<String, dynamic> json, [String profilePicBase64 = '']) {
    return Friend3(
      name: json['name'] ?? '',
      profilePic: profilePicBase64,
      occupation: json['occupation'] ?? '',
      city: json['city'] ?? '',
      role: json['role'] ?? '',
      dob: json['dob'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      lat: json['lat'] != null ? double.parse(json['lat']) : 0.0,
      lng: json['lng'] != null ? double.parse(json['lng']) : 0.0,
    );
  }
}

