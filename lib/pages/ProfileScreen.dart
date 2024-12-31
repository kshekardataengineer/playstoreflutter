/*import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String friendName;

  ProfileScreen({required this.friendName});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Friend> _friendFuture;
  late Friend _friend;
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

  Future<Friend> _fetchFriendDetails(String name) async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/searchperson'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final friendData = data[0];

        // Fetch profile picture
        final profilePicResponse = await http.post(
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_profilepic'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'name': name}),
        );

        String profilePicBase64 = '';
        if (profilePicResponse.statusCode == 200) {
          profilePicBase64 = base64Encode(profilePicResponse.bodyBytes);
        }

        return Friend.fromJson(friendData, profilePicBase64);
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
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploading'),
    );

    request.fields['name'] = name;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    return await request.send();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Send the updated friend data to your API
      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/updateperson'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Profile')),
      body: FutureBuilder<Friend>(
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
                  TextFormField(
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
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isEditing ? _saveChanges : () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
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

class Friend {
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

  Friend({
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

  factory Friend.fromJson(Map<String, dynamic> json, [String profilePicBase64 = '']) {
    return Friend(
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
}*/
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:io';

import '../providers/UserProvider.dart';
import 'ViewTechnicianProfile.dart';

class ProfileScreen extends StatefulWidget {
  final String friendName;

  ProfileScreen({required this.friendName});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late Future<Friend2> _friendFuture;
  late Friend2 _friend;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;
  String? loggedInPerson;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        loggedInPerson = userProvider.loggedInPerson;
      });
    });
    _loadFriendDetails();

  }

  void _loadFriendDetails() {
    setState(() {
      _friendFuture = _fetchFriendDetails(widget.friendName);
    });
  }

  Future<Friend2> _fetchFriendDetails(String name) async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/searchperson'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final friendData = data[0];

        // Fetch profile picture
        final profilePicResponse = await http.post(
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_profilepic'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'name': name}),
        );

        String profilePicBase64 = '';
        if (profilePicResponse.statusCode == 200) {
          profilePicBase64 = base64Encode(profilePicResponse.bodyBytes);
        }

        return Friend2.fromJson(friendData, profilePicBase64);
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
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploading'),
    );

    request.fields['name'] = name;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    return await request.send();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Send the updated friend data to your API
      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/updateperson'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Profile')),
      body: FutureBuilder<Friend2>(
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
                 /* TextFormField(
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
                    onPressed: _isEditing ? _saveChanges : () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      //String technicianName = "rajkiran";
                      // The name you want to pass
                      String? technicianName = loggedInPerson;
                      bool editable = true;  // Set editable to false

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

class Friend2 {
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

  Friend2({
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

  factory Friend2.fromJson(Map<String, dynamic> json, [String profilePicBase64 = '']) {
    return Friend2(
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

