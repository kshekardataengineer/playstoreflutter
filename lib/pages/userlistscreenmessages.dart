import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'chat_screen.dart';

// Message Model
/*
class Message {
  final String message;
  final String person;
  final String receiver;
  final String sender;
  final String timestamp;

  Message({
    required this.message,
    required this.person,
    required this.receiver,
    required this.sender,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      person: json['person'],
      receiver: json['receiver'],
      sender: json['sender'],
      timestamp: json['timestamp'],
    );
  }
}

// Message Provider
class MessageProvider with ChangeNotifier {
  List<Message> _messages = [];
  Set<String> _uniqueUsernames = {};

  List<Message> get messages => _messages;
  Set<String> get uniqueUsernames => _uniqueUsernames;

  Future<void> fetchMessages(String person2) async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievemessagesperson2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'person2': person2}),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      _messages = body.map((dynamic item) => Message.fromJson(item)).toList();
      _uniqueUsernames = getUniqueUsernames(_messages, person2);
      notifyListeners(); // Notify listeners about the change
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Set<String> getUniqueUsernames(List<Message> messages, String loggedinPerson) {
    Set<String> usernames = {};
    for (var message in messages) {
      if (message.sender != loggedinPerson) {
        usernames.add(message.sender);
      }
      if (message.receiver != loggedinPerson) {
        usernames.add(message.receiver);
      }
    }
    return usernames;
  }
}

// User List Screen
class UserListScreen extends StatefulWidget {
  final String loggedinPerson;

  UserListScreen({required this.loggedinPerson});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch messages when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MessageProvider>(context, listen: false);
      provider.fetchMessages(widget.loggedinPerson);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MessageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: provider.messages.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: provider.uniqueUsernames.map((username) {
          return ListTile(
            title: Text(username),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(sender: username)
                    /*  ChatScreen(
                    loggedinPerson: widget.loggedinPerson,
                    otherPerson: username,
                  ),*/
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
*/
// Chat Screen
/*class ChatScreen extends StatelessWidget {
  final String loggedinPerson;
  final String otherPerson;

  ChatScreen({required this.loggedinPerson, required this.otherPerson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $otherPerson')),
      body: Center(
        child: Text('Chat Screen for $loggedinPerson and $otherPerson'),
      ),
    );
  }
}*/
/*
// Main Function
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MessageProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(loggedinPerson: 'varun'), // Replace with actual logged-in person
    );
  }
}*/
/* trying to resolve issue in node backend code*/

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
/*
// Message Model
class Message {
  final String message;
  final String person;
  final String receiver;
  final String sender;
  final String timestamp;

  Message({
    required this.message,
    required this.person,
    required this.receiver,
    required this.sender,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      person: json['person'],
      receiver: json['receiver'],
      sender: json['sender'],
      timestamp: json['timestamp'],
    );
  }
}

// Message Provider
class MessageProvider with ChangeNotifier {
  List<Message> _messages = [];
  Set<String> _uniqueUsernames = {};

  List<Message> get messages => _messages;
  Set<String> get uniqueUsernames => _uniqueUsernames;

  Future<void> fetchMessages(String person2) async {
    final response = await http.post(
      Uri.parse(
          'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievemessagesperson2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'person2': person2}),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      _messages = body.map((dynamic item) => Message.fromJson(item)).toList();
      _uniqueUsernames = getUniqueUsernames(_messages, person2);
      notifyListeners();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Set<String> getUniqueUsernames(List<Message> messages, String loggedinPerson) {
    Set<String> usernames = {};
    for (var message in messages) {
      if (message.sender != loggedinPerson) {
        usernames.add(message.sender);
      }
      if (message.receiver != loggedinPerson) {
        usernames.add(message.receiver);
      }
    }
    return usernames;
  }
}

// User List Screen
class UserListScreen extends StatefulWidget {
  final String loggedinPerson;

  UserListScreen({required this.loggedinPerson});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MessageProvider>(context, listen: false);
      provider.fetchMessages(widget.loggedinPerson);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MessageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: provider.messages.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: provider.uniqueUsernames.map((username) {
          return ListTile(
            title: Text(username),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    loggedinPerson: widget.loggedinPerson,
                    otherPerson: username, sender: '',
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

*/


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Fetch messages and extract unique usernames
Future<Set<String>> fetchUniqueUsernames(String person2) async {
  final response = await http.post(
    Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievemessagesperson2'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'person2': person2}),
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    Set<String> usernames = {};
    for (var item in body) {
      final sender = item['sender'];
      final receiver = item['receiver'];
      if (sender != person2) usernames.add(sender);
      if (receiver != person2) usernames.add(receiver);
    }
    return usernames;
  } else {
    throw Exception('Failed to load messages');
  }
}

// User List Screen
class UserListScreen extends StatefulWidget {
  final String loggedinPerson;

  UserListScreen({required this.loggedinPerson});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<Set<String>> _usernamesFuture;

  @override
  void initState() {
    super.initState();
    _usernamesFuture = fetchUniqueUsernames(widget.loggedinPerson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: FutureBuilder<Set<String>>(
        future: _usernamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chats found.'));
          } else {
            final usernames = snapshot.data!;
            return ListView(
              children: usernames.map((username) {
                return ListTile(
                  title: Text(username),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          loggedinPerson: widget.loggedinPerson,
                          otherPerson: username, sender: widget.loggedinPerson,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
/*
// Chat Screen
class ChatScreen extends StatelessWidget {
  final String loggedinPerson;
  final String otherPerson;

  ChatScreen({required this.loggedinPerson, required this.otherPerson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $otherPerson')),
      body: Center(
        child: Text('Chat Screen for $loggedinPerson and $otherPerson'),
      ),
    );
  }
}

*/
