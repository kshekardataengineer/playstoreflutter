import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'consentscreen.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  static const String page_id = "Sign Up";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  // List of country codes
  final List<String> countryCodes = ['+44', '+91'];
  String countryCode = ''; // Initialize as empty

  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    // Set the default country code to the first item in the list
    countryCode = countryCodes[0];
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied.');
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

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

  void _showSuccessDialog(String mobileNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Successfully registered!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConsentScreen(phoneNumber: mobileNumber,)));
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && currentPosition != null) {
      String name = nameController.text;
      String dob = dobController.text;
      String occupation = occupationController.text;
      String role = roleController.text;
      String city = cityController.text;
      String state = stateController.text;
      String country = countryController.text;
      String mobileNumber = '$countryCode${mobileController.text}'; // Combined country code and mobile number
      double lat = currentPosition!.latitude;
      double lng = currentPosition!.longitude;
     // "mobile: '$mobileNumber', "
      String query = "CREATE (person:Person {"
          "name: '$name', "
          "dob: '$dob', "
          "occupation: '$occupation', "
          "role: '$role', "
          "city: '$city', "
          "state: '$state', "
          "country: '$country', "
          "phone_number:'$mobileNumber', "
          "lat: '$lat', "
          "lng: '$lng'"
          "})";

      final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/querynew');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse.isEmpty) {
          _showSuccessDialog(mobileNumber);
        } else {
          _showErrorDialog('Sign up failed. Try again.');
        }
      } else {
        _showErrorDialog('Sign up failed. Try again.');
      }
    } else if (currentPosition == null) {
      _showErrorDialog('Unable to get your current location.');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  Widget _buildCountryCodeDropdown() {
    return DropdownButton<String>(
      value: countryCode, // Set the default value to the current selected country code
      onChanged: (String? newValue) {
        setState(() {
          countryCode = newValue!;
        });
      },
      items: countryCodes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: <Widget>[
              if (value == '+44') ...[
                Image.asset('assets/flags/uk.png', height: 20), // UK flag
                SizedBox(width: 8),
              ] else if (value == '+91') ...[
                Image.asset('assets/flags/india.png', height: 20), // India flag
                SizedBox(width: 8),
              ],
              Text(value),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text: 'Have an account? ',
                style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'regular'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Log in.',
                    style: TextStyle(color: Colors.blue, fontSize: 16, fontFamily: 'regular'),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Konkt',
                  style: TextStyle(fontFamily: 'bold', fontSize: 24),
                ),
                SizedBox(height: 20),
                Text(
                  'Sign up to see your friends',
                  style: TextStyle(fontFamily: 'semi-bold', fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(),
                      hintText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: dobController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(),
                    hintText: 'Date of Birth',
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: occupationController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(),
                      hintText: 'Occupation'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your occupation';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: roleController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(),
                      hintText: 'Role'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your role';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(),
                      hintText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(),
                      hintText: 'State'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: countryController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(),
                      hintText: 'Country'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Country Code Dropdown
                _buildCountryCodeDropdown(),
                SizedBox(height: 20),
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(),
                      hintText: 'Mobile Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
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
      ),
    );
  }
}
