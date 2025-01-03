/*import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void main() {
  runApp(ReadContacts());
}

class ReadContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactsPage(),
    );
  }
}

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      setState(() {
        isLoading = true;
      });

      List<Contact> fetchedContacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contacts = fetchedContacts;
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access contacts was denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contacts.isEmpty
          ? Center(child: Text('No contacts found'))
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.displayName ?? 'Unknown Name'),
            subtitle: Text(contact.phones.isNotEmpty
                ? contact.phones.first.number
                : 'No phone number'),
          );
        },
      ),
    );
  }
}
perfectly working to read contacts */
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ReadContacts(name:'rajkiran'));
}

class ReadContacts extends StatelessWidget {
  final String name;

  // Accept the name as a parameter
  ReadContacts({required this.name});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactsPage(name:name),
    );
  }
}

class ContactsPage extends StatefulWidget {
  final String name;

  // Accept the name as a parameter
  ContactsPage({required this.name});
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      setState(() {
        isLoading = true;
      });

      List<Contact> fetchedContacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contacts = fetchedContacts;
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access contacts was denied')),
      );
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
  Future<void> _addFriend(Contact contact) async {
    final String name = contact.displayName ?? 'Unknown Name';
    final String phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : '';

    // Prepare the JSON body for the first POST request
    final String jsonBody1 = jsonEncode({
      "query": "CREATE (rathod:Person {name: '$name', dob:'', occupation: '', role:'', city: '', state:'', country:'', lat:'', lng:'', otp_expiry: '', phone_number: '$phoneNumber', otp: ''})"
    });
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
    // Send the first POST request
    final response1 = await http.post(
    //  Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/querynew'),

      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/querynewprotected'),
      //headers: {'Content-Type': 'application/json'},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody1,
    );

    if (response1.statusCode == 200) {
      // Prepare the JSON body for the second POST request
      final String jsonBody2 = jsonEncode({
        "person1": widget.name, // Replace with the actual logged-in person name
        "person2": name,
        "phone_number": phoneNumber
      });

      // Send the second POST request
      final response2 = await http.post(
        //Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/AddfriendContact'),
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/AddfriendContactprotected'),
       //headers: {'Content-Type': 'application/json'},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody2,
      );

      if (response2.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add friend')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create person')),
      );
    }
    } catch (error) {
      print('Error finding connections: $error');
      _showErrorDialog( 'An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contacts.isEmpty
          ? Center(child: Text('No contacts found'))
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.displayName ?? 'Unknown Name'),
            subtitle: Text(contact.phones.isNotEmpty
                ? contact.phones.first.number
                : 'No phone number'),
            trailing: ElevatedButton(
              onPressed: () => _addFriend(contact),
              child: Text('Add as Friend'),
            ),
          );
        },
      ),
    );
  }
}
