/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SOSApp(),
    );
  }
}

class SOSApp extends StatefulWidget {
  @override
  _SOSAppState createState() => _SOSAppState();
}

class _SOSAppState extends State<SOSApp> {
  bool isSosActive = false; // Initial SOS state

  // Function to switch on the SOS
  Future<void> switchOnSos() async {
    const url = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net//createsosnotification';
    var body = jsonEncode({"person": "nandu","message":"my car breakdown at kothapet rythubazar"});
    const url1 = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/sospersonupdate';
    var body1 = jsonEncode({"person": "nandu"});
    try {

      final response1 = await http.post(Uri.parse(url1),
          headers: {'Content-Type': 'application/json'}, body: body1);

      if (response1.statusCode == 200) {
        var data1 = json.decode(response1.body);
        setState(() {
          isSosActive = true; // Update SOS state based on response
        });
      }
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          isSosActive = true; // Update SOS state based on response
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Function to switch off the SOS
  Future<void> switchOffSos() async {
    const url = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/offsosnotification';
    var body = jsonEncode({"person": "nandu"});

    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        setState(() {
          isSosActive = false; // Update SOS state to false
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Toggle SOS state and make API call
  void toggleSos() {
    if (isSosActive) {
      switchOffSos(); // Switch off SOS
    } else {
      switchOnSos(); // Switch on SOS
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS App'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.light_mode_rounded,
              color: isSosActive ? Colors.red : Colors.grey, // Icon color based on SOS state
            ),
            onPressed: toggleSos, // Handle the icon press to toggle SOS
          ),
        ],
      ),
      body:  Center(
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              // Toggle the button state
              isSosActive = !isSosActive;
            });
          },
          backgroundColor: isSosActive ? Colors.red : Colors.green, // Change color based on state
          child: Icon(Icons.power_settings_new), // You can change the icon as needed
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SOSApp(name:''),
    );
  }
}

class SOSApp extends StatefulWidget {
  final String name;



  static const String page_id = "sos";





  // Accept the name as a parameter
  SOSApp({required this.name});
  @override
  _SOSAppState createState() => _SOSAppState();
}

class _SOSAppState extends State<SOSApp> {
  bool isSosActive = false; // Initial SOS state

  @override
  void initState() {
    super.initState();
    _loadSosState(); // Load SOS state when the app starts
  }

  // Load SOS state from shared preferences
  Future<void> _loadSosState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSosActive = prefs.getBool('isSosActive') ?? false; // Default to false if not set
    });
  }

  // Save SOS state to shared preferences
  Future<void> _saveSosState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSosActive', value);
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
  // Function to switch on the SOS
  Future<void> switchOnSos() async {

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
    //const url = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createsosnotification';
    //const url1 = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/sospersonupdate';
    const url = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createsosnotificationprotected';
    const url1 = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/sospersonupdateprotected';
    var body = jsonEncode({
      "person": widget.name,
      "message": "SOS Alert! Please help me"
    });

    var body1 = jsonEncode({"person": widget.name});

    try {
      // First API call
      final response1 = await http.post(Uri.parse(url1),
          //headers: {'Content-Type': 'application/json'},
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body1);

      if (response1.statusCode == 200) {
        setState(() {
          isSosActive = true; // Update SOS state based on response
          _saveSosState(isSosActive); // Save to shared preferences
        });
      }

      // Second API call
      final response = await http.post(Uri.parse(url),
          //headers: {'Content-Type': 'application/json'},
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      if (response.statusCode == 200) {
        setState(() {
          isSosActive = true; // Update SOS state based on response
          _saveSosState(isSosActive); // Save to shared preferences
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Function to switch off the SOS
  Future<void> switchOffSos() async {

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
    const url = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/offsosnotification';
    var body = jsonEncode({"person": "nandu"});
//updated
    try {
      final response = await http.post(Uri.parse(url),
          //headers: {'Content-Type': 'application/json'},
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },

          body: body);

      if (response.statusCode == 200) {
        setState(() {
          isSosActive = false; // Update SOS state to false
          _saveSosState(isSosActive); // Save to shared preferences
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Toggle SOS state and make API call
  void toggleSos() {
    if (isSosActive) {
      switchOffSos(); // Switch off SOS
    } else {
      switchOnSos(); // Switch on SOS
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS App'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.light_mode_rounded,
              color: isSosActive ? Colors.red : Colors.grey, // Icon color based on SOS state
            ),
            onPressed: toggleSos, // Handle the icon press to toggle SOS
          ),
        ],
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: toggleSos, // Use the same toggle method
          backgroundColor: isSosActive ? Colors.red : Colors.green, // Change color based on state
          child: Icon(Icons.power_settings_new), // Icon for the button
        ),
      ),
    );
  }
}
