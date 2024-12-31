import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Import the Sender model
import '../model/sender.dart';
import 'chat_screen.dart';


class SenderListScreen extends StatefulWidget {

  @override
  _SenderListScreenState createState() => _SenderListScreenState();
}

class _SenderListScreenState extends State<SenderListScreen> {
  List<Sender> senders = [];
  String loggedinPerson = 'varun';  // Variable holding the logged-in person's name

  @override
  void initState() {
    super.initState();
    fetchSenders();
  }

  Future<void> fetchSenders() async {
    try {
      List<Sender> senderList = await retrieveSenders();

      // Filter out the logged-in person (varun) from the sender list
      senderList = senderList.where((sender) => sender.name != loggedinPerson).toList();

      setState(() {
        senders = senderList;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Sender>> retrieveSenders() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievemessagesperson2');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'person2': 'varun'}),  // Use loggedinPerson here
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      // Map dynamic types to the Sender model
      List<Sender> senderList = data.map((dynamic item) => Sender.fromJson(item as Map<String, dynamic>)).toList();

      // Fetch profile pictures for all senders
      await _fetchProfilePictures(senderList);
      return senderList;
    } else {
      throw Exception('Failed to load senders');
    }
  }

  Future<void> _fetchProfilePictures(List<Sender> senderList) async {
    for (var sender in senderList) {
      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_profilepic'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': sender.name}),
      );

      if (response.statusCode == 200) {
        Uint8List profilePicBytes = response.bodyBytes;
        sender.profilePic = 'data:image/jpeg;base64,' + base64Encode(profilePicBytes);
      } else {
        print('Failed to load profile picture for ${sender.name}');
      }
    }

    // Refresh the state to reflect profile picture changes
    setState(() {});
  }

  void handleSenderTap(String sender) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>ChatScreen(sender: sender),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Senders')),
      body: ListView.builder(
        itemCount: senders.length,
        itemBuilder: (context, index) {
          final sender = senders[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: sender.profilePic.isNotEmpty
                  ? MemoryImage(base64Decode(sender.profilePic.split(',')[1]))
                  : null,
              child: sender.profilePic.isEmpty ? Icon(Icons.person) : null,
            ),
            title: Text(sender.name),
            onTap: () => handleSenderTap(sender.name),
          );
        },
      ),
    );
  }
}
