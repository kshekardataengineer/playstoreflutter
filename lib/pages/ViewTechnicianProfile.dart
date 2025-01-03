/*logo working text data not saving
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';

class ViewTechnicianProfile extends StatefulWidget {
  final String technicianName;



  final bool editable;  // Add editable parameter

  // Modify constructor to accept 'editable' parameter
  ViewTechnicianProfile({required this.technicianName, this.editable = true});

  @override
  _ViewTechnicianProfileState createState() => _ViewTechnicianProfileState();
}

class _ViewTechnicianProfileState extends State<ViewTechnicianProfile> {
  late Future<Technician> _technicianFuture;
  Technician? _technician; // _technician is now nullable
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadTechnicianDetails();
  }

  void _loadTechnicianDetails() {
    setState(() {
      _technicianFuture = _fetchTechnicianDetails(widget.technicianName);
    });
  }

  Future<Technician> _fetchTechnicianDetails(String name) async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/searchTechnician'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final technicianData = data[0];

        // Fetch profile logo
        final logoResponse = await http.post(
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_logopic'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'name': name}),
        );

        String logoBase64 = '';
        if (logoResponse.statusCode == 200) {
          logoBase64 = base64Encode(logoResponse.bodyBytes);
        }

        return Technician.fromJson(technicianData, logoBase64);
      } else {
        throw Exception('No technician data found');
      }
    } else {
      throw Exception('Failed to load technician details');
    }
  }

  Future<void> _updateProfilePicture() async {
    if (!_isEditing) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final response = await _uploadProfilePicture(file, widget.technicianName);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(await response.stream.bytesToString());
        final imageName = responseBody['imageName'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('$imageName uploaded successfully!'),
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

        _loadTechnicianDetails();
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
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadinglogo'),
    );

    request.fields['name'] = name;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    return await request.send();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/updateTechnician'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _technician?.name ?? '',
          'contact': _technician?.contact ?? '',
          'rating': _technician?.rating ?? 0.0,
          'location': _technician?.location ?? '',
          'availability': _technician?.availability ?? '',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() {
          _isEditing = false;
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
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Technician Profile')),
      body: FutureBuilder<Technician>(
        future: _technicianFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          _technician = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _isEditing ? _updateProfilePicture : null,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _technician!.logo.isNotEmpty
                            ? MemoryImage(base64Decode(_technician!.logo))
                            : AssetImage('assets/default_profile_pic.png') as ImageProvider,
                        child: _isEditing
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _technician?.name ?? '',
                    decoration: InputDecoration(labelText: 'Name'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.name = value ?? _technician!.name,
                  ),
                  TextFormField(
                    initialValue: _technician?.contact ?? '',
                    decoration: InputDecoration(labelText: 'Contact Number'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.contact = value ?? _technician!.contact,
                  ),
                  TextFormField(
                    initialValue: _technician?.rating.toString() ?? '',
                    decoration: InputDecoration(labelText: 'Rating'),
                    readOnly: true, // Rating is not editable
                  ),
                  TextFormField(
                    initialValue: _technician?.location ?? '',
                    decoration: InputDecoration(labelText: 'Location'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.location = value ?? _technician!.location,
                  ),
                  TextFormField(
                    initialValue: _technician?.availability ?? '',
                    decoration: InputDecoration(labelText: 'Availability'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.availability = value ?? _technician!.availability,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _isEditing ? _saveChanges : null,
                        child: Text('Save Changes'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        child: Text(_isEditing ? 'Cancel' : 'Edit'),
                      ),
                    ],
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

class Technician {
  late final String name;
  late final String contact;
  final double rating;
  late final String location;
  late final String availability;
  final String logo;

  Technician({
    required this.name,
    required this.contact,
    required this.rating,
    required this.location,
    required this.availability,
    required this.logo,
  });

  factory Technician.fromJson(Map<String, dynamic> json, String logoBase64) {
    return Technician(
      name: json['name'],
      contact: json['contact'],

      rating: json['rating'] != null ? (json['rating'] is double ? json['rating'] : double.tryParse(json['rating'].toString()) ?? 0.0) : 0.0,
      location: json['location'],
      availability: json['availability'],
      logo: logoBase64,
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';

class ViewTechnicianProfile extends StatefulWidget {
  final String technicianName;
  final bool editable;  // Add editable parameter

  // Modify constructor to accept 'editable' parameter
  ViewTechnicianProfile({required this.technicianName, this.editable = true});

  @override
  _ViewTechnicianProfileState createState() => _ViewTechnicianProfileState();
}

class _ViewTechnicianProfileState extends State<ViewTechnicianProfile> {
  late Future<Technician> _technicianFuture;
  Technician? _technician; // _technician is now nullable
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadTechnicianDetails();
  }

  void _loadTechnicianDetails() {
    setState(() {
      _technicianFuture = _fetchTechnicianDetails(widget.technicianName);
    });
  }

  Future<Technician> _fetchTechnicianDetails(String name) async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/searchTechnician'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final technicianData = data[0];

        // Fetch profile logo
        final logoResponse = await http.post(
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_logopic'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'name': name}),
        );

        String logoBase64 = '';
        if (logoResponse.statusCode == 200) {
          logoBase64 = base64Encode(logoResponse.bodyBytes);
        }

        return Technician.fromJson(technicianData, logoBase64);
      } else {
        throw Exception('No technician data found');
      }
    } else {
      throw Exception('Failed to load technician details');
    }
  }

  Future<void> _updateProfilePicture() async {
    if (!_isEditing) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final response = await _uploadProfilePicture(file, widget.technicianName);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(await response.stream.bytesToString());
        final imageName = responseBody['imageName'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('$imageName uploaded successfully!'),
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

        _loadTechnicianDetails();
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
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadinglogo'),
    );

    request.fields['name'] = name;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    return await request.send();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/updateTechnician'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _technician?.name ?? '',
          'contact': _technician?.contact ?? '',
          'rating': _technician?.rating ?? 0.0,
          'location': _technician?.location ?? '',
          'availability': _technician?.availability ?? '',
          'description': _technician?.description ?? '',
          'website': _technician?.website ?? '',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() {
          _isEditing = false;
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
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Technician Profile')),
      body: FutureBuilder<Technician>(
        future: _technicianFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          _technician = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _isEditing ? _updateProfilePicture : null,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _technician!.logo.isNotEmpty
                            ? MemoryImage(base64Decode(_technician!.logo))
                            : AssetImage('assets/default_profile_pic.png') as ImageProvider,
                        child: _isEditing
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _technician?.name ?? '',
                    decoration: InputDecoration(labelText: 'Name'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.name = value ?? _technician!.name,
                  ),
                  TextFormField(
                    initialValue: _technician?.contact ?? '',
                    decoration: InputDecoration(labelText: 'Contact Number'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.contact = value ?? _technician!.contact,
                  ),
                  TextFormField(
                    initialValue: _technician?.rating.toString() ?? '',
                    decoration: InputDecoration(labelText: 'Rating'),
                    readOnly: true, // Rating is not editable
                  ),
                  TextFormField(
                    initialValue: _technician?.location ?? '',
                    decoration: InputDecoration(labelText: 'Location'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.location = value ?? _technician!.location,
                  ),
                  TextFormField(
                    initialValue: _technician?.availability ?? '',
                    decoration: InputDecoration(labelText: 'Availability'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.availability = value ?? _technician!.availability,
                  ),
                  // Adding description and website fields
                  TextFormField(
                    initialValue: _technician?.description ?? '',
                    decoration: InputDecoration(labelText: 'Description'),
                    readOnly: !_isEditing,
                    maxLines: 5,
                    onSaved: (value) => _technician?.description = value ?? _technician!.description,
                  ),
                  TextFormField(
                    initialValue: _technician?.website ?? '',
                    decoration: InputDecoration(labelText: 'Website'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.website = value ?? _technician!.website,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _isEditing ? _saveChanges : null,
                        child: Text('Save Changes'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        child: Text(_isEditing ? 'Cancel' : 'Edit Profile'),
                      ),
                    ],
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

class Technician {
  String name;
  String contact;
  double rating;
  String location;
  String availability;
  String description;
  String website;
  String logo;

  Technician({
    required this.name,
    required this.contact,
    required this.rating,
    required this.location,
    required this.availability,
    required this.description,
    required this.website,
    required this.logo,
  });

  factory Technician.fromJson(Map<String, dynamic> json, String logoBase64) {
    return Technician(
      name: json['name'],
      contact: json['contact'],
      rating: json['rating'].toDouble(),
      location: json['location'],
      availability: json['availability'],
      description: json['description'] ?? '',
      website: json['website'] ?? '',
      logo: logoBase64,
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ViewTechnicianProfile extends StatefulWidget {
  final String technicianName;
  final bool editable;  // Add editable parameter

  // Modify constructor to accept 'editable' parameter
  ViewTechnicianProfile({required this.technicianName, this.editable = true});

  @override
  _ViewTechnicianProfileState createState() => _ViewTechnicianProfileState();
}

class _ViewTechnicianProfileState extends State<ViewTechnicianProfile> {
  late Future<Technician> _technicianFuture;
  Technician? _technician; // _technician is now nullable
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadTechnicianDetails();
  }

  void _loadTechnicianDetails() {
    setState(() {
      _technicianFuture = _fetchTechnicianDetails(widget.technicianName);
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
  Future<Technician> _fetchTechnicianDetails(String name) async {
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
     // return;
    }

    final response = await http.post(
      //Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/searchTechnician'),
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/searchTechnicianprotected'),
     /* headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },*/
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final technicianData = data[0];

        // Fetch profile logo
        final logoResponse = await http.post(
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_logopic'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'name': name}),
        );

        String logoBase64 = '';
        if (logoResponse.statusCode == 200) {
          logoBase64 = base64Encode(logoResponse.bodyBytes);
        }

        return Technician.fromJson(technicianData, logoBase64);
      } else {
        throw Exception('No technician data found');
      }
    } else {
      throw Exception('Failed to load technician details');
    }
  }

  Future<void> _updateProfilePicture() async {
    if (!_isEditing) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final response = await _uploadProfilePicture(file, widget.technicianName);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(await response.stream.bytesToString());
        final imageName = responseBody['imageName'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('$imageName uploaded successfully!'),
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

        _loadTechnicianDetails();
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
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadinglogo'),
    );

    request.fields['name'] = name;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    return await request.send();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/updateTechnician'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _technician?.name ?? '',
          'contact': _technician?.contact ?? '',
          'rating': _technician?.rating ?? 0.0,
          'location': _technician?.location ?? '',
          'availability': _technician?.availability ?? '',
          'description': _technician?.description ?? '',
          'website': _technician?.website ?? '',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() {
          _isEditing = false;
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
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Technician Profile')),
      body: FutureBuilder<Technician>(
        future: _technicianFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          _technician = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _isEditing ? _updateProfilePicture : null,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _technician!.logo.isNotEmpty
                            ? MemoryImage(base64Decode(_technician!.logo))
                            : AssetImage('assets/default_profile_pic.png') as ImageProvider,
                        child: _isEditing
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _technician?.name ?? 'N/A',
                    decoration: InputDecoration(labelText: 'Name'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.name = value ?? _technician!.name,
                  ),
                  TextFormField(
                    initialValue: _technician?.contact ?? 'N/A',
                    decoration: InputDecoration(labelText: 'Contact Number'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.contact = value ?? _technician!.contact,
                  ),
                  TextFormField(
                    initialValue: _technician?.rating.toString() ?? '0.0',  // Ensure non-null value
                    decoration: InputDecoration(labelText: 'Rating'),
                    readOnly: true, // Rating is not editable
                  ),
                  TextFormField(
                    initialValue: _technician?.location ?? 'N/A',
                    decoration: InputDecoration(labelText: 'Location'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.location = value ?? _technician!.location,
                  ),
                  TextFormField(
                    initialValue: _technician?.availability ?? 'N/A',
                    decoration: InputDecoration(labelText: 'Availability'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.availability = value ?? _technician!.availability,
                  ),
                  // Adding description and website fields
                  TextFormField(
                    initialValue: _technician?.description ?? 'N/A',
                    decoration: InputDecoration(labelText: 'Description'),
                    readOnly: !_isEditing,
                    maxLines: 5,
                    onSaved: (value) => _technician?.description = value ?? _technician!.description,
                  ),
                  TextFormField(
                    initialValue: _technician?.website ?? 'N/A',
                    decoration: InputDecoration(labelText: 'Website'),
                    readOnly: !_isEditing,
                    onSaved: (value) => _technician?.website = value ?? _technician!.website,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _isEditing ? _saveChanges : null,
                        child: Text('Save Changes'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        child: Text(_isEditing ? 'Cancel' : 'Edit Profile'),
                      ),
                    ],
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

class Technician {
  String name;
  String contact;
  double rating;
  String location;
  String availability;
  String description;
  String website;
  String logo;

  Technician({
    required this.name,
    required this.contact,
    required this.rating,
    required this.location,
    required this.availability,
    required this.description,
    required this.website,
    required this.logo,
  });

  factory Technician.fromJson(Map<String, dynamic> json, String logoBase64) {
    return Technician(
      name: json['name'] ?? 'N/A',
      contact: json['contact'] ?? 'N/A',
      rating: json['rating'] != null ? json['rating'].toDouble() : 0.0,
      location: json['location'] ?? 'N/A',
      availability: json['availability'] ?? 'N/A',
      description: json['description'] ?? 'N/A',
      website: json['website'] ?? 'N/A',
      logo: logoBase64,
    );
  }
}
