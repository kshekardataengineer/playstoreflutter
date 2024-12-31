import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'consentscreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If not enabled, show a dialog or ask the user to enable it
      _showErrorDialog('Location services are disabled. Please enable them.');
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle it appropriately
        _showErrorDialog('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle appropriately
      _showErrorDialog('Location permissions are permanently denied.');
      return;
    }

    // When permission is granted, get the current position
    currentPosition = await Geolocator.getCurrentPosition();
    setState(() {}); // Update the UI once location is available
  }

  // Show an error dialog if any issues with location or submission
  void _showErrorDialog(String message) {
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

  // Send sign-up data to the server
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && currentPosition != null) {
      String name = nameController.text;
      String dob = dobController.text;
      String occupation = occupationController.text;
      String phonenumber = phoneNumberController.text;
      String role = roleController.text;
      String city = cityController.text;
      String state = stateController.text;
      String country = countryController.text;
      double lat = currentPosition!.latitude;
      double lng = currentPosition!.longitude;

      // Create the query string
      String query = "CREATE (person:Person {"
          "name: '$name', "
          "dob: '$dob', "
          "phone_number: '$phonenumber', "
          "occupation: '$occupation', "
          "role: '$role', "
          "city: '$city', "
          "state: '$state', "
          "country: '$country', "
          "lat: '$lat', "
          "lng: '$lng'"
          "})";

      // Make the HTTP request
      final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/querynew');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse.isEmpty) {
          // Success - handle accordingly (e.g., navigate to another screen)
          //Navigator.pushReplacementNamed(context, '/login');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConsentScreen(phoneNumber: phonenumber),
            ),
          );
        } else {
          _showErrorDialog('Failed to sign up. Please try again.');
        }
      } else {
        _showErrorDialog('Failed to sign up. Please try again.');
      }
    } else if (currentPosition == null) {
      _showErrorDialog('Unable to get your current location.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dobController,
                decoration: InputDecoration(labelText: 'Date of Birth (DD-MM-YYYY)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),


              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Date of Birth (DD-MM-YYYY)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: occupationController,
                decoration: InputDecoration(labelText: 'Occupation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your occupation';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: roleController,
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your role';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextFormField(
                controller: countryController,
                decoration: InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
