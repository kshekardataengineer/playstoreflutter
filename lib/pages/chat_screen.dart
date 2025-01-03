/* working chat good but left right alignment but like whatsapp*/
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
/*
class ChatScreen extends StatefulWidget {
  final String sender;
  final String loggedinPerson;
  final String otherPerson;


  ChatScreen({required this.sender, required this.loggedinPerson, required this.otherPerson});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String receiver="";//added this
  @override
  void initState() {
    super.initState();
    fetchMessages();

    // Periodically check for new messages every 5 seconds
    Timer.periodic(Duration(seconds: 5), (Timer t) => fetchMessages());
  }

  Future<void> fetchMessages() async {
    try {
      List<Map<String, dynamic>> fetchedMessages = await retrieveMessages(widget.sender);
      setState(() {
        // Format timestamps before sorting
        messages = fetchedMessages.map((message) {
          message['timestamp'] = formatTimestamp(message['timestamp']);
          return message;
        }).toList();

        // Sort messages based on the parsed timestamp
        messages.sort((a, b) => DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp'])));
      });
      _scrollToBottom();
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  String formatTimestamp(String timestamp) {
    // Example input: "2024-6-13 16H:2M"
    try {
      // Clean up the timestamp format
      timestamp = timestamp.replaceAll("m", "").replaceAll("H", ":").replaceAll("M", "").trim();
      var parts = timestamp.split(" ");
      var datePart = parts[0]; // "2024-6-13"
      var timePart = parts[1]; // "16:2"

      // Split date into its components
      var dateElements = datePart.split("-");
      String year = dateElements[0];
      String month = dateElements[1].padLeft(2, '0'); // Add leading zero for month
      String day = dateElements[2].padLeft(2, '0'); // Add leading zero for day

      // Further split time into hours and minutes
      var timeElements = timePart.split(":");
      String hour = timeElements[0].padLeft(2, '0'); // Add leading zero for hour
      String minute = timeElements[1].padLeft(2, '0'); // Add leading zero for minute

      // Return formatted timestamp
      return "$year-$month-$day $hour:$minute"; // Will be in the format "YYYY-MM-DD HH:mm"
    } catch (e) {
      print('Error formatting timestamp: $e');
      return "1970-01-01 00:00"; // Default to a valid timestamp
    }
  }

  Future<List<Map<String, dynamic>>> retrieveMessages(String sender) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievemessages');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
     // body: jsonEncode({'person1': 'rajkiran', 'person2': 'varun'}),
      body: jsonEncode({'person1': widget.loggedinPerson, 'person2': widget.otherPerson}),
      //body: jsonEncode({'person1': 'rajkiran', 'person2': sender}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(String content, String receiver) async {
    receiver=receiver;
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createmessage');
    final body = jsonEncode({
      'person1': widget.loggedinPerson,
      'person2': receiver,//changed here
      'content': content
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        fetchMessages(); // Refresh messages after sending
      } else {
        print('Failed to send message: ${response.body}');
        throw Exception('Failed to send message');
      }
    } catch (e) {
      print('Exception occurred while sending message: $e');
      throw Exception('Failed to send message');
    }
  }

  void handleSend() async {
    if (_controller.text.isNotEmpty) {
      await sendMessage(_controller.text, widget.otherPerson); // Assume 'varun' is the receiver here changed
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildMessage(Map<String, dynamic> message) {
    bool isSender = message['sender'] == widget.sender; // Check if the current user is the sender
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['content'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              message['timestamp'] ?? '',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.otherPerson}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

/*only alignment needed*/



import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String sender; // Current logged-in person
  final String loggedinPerson; // Sender for messages
  final String otherPerson; // Receiver for messages

  ChatScreen({
    required this.sender,
    required this.loggedinPerson,
    required this.otherPerson,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMessages();

    // Periodically fetch messages every 5 seconds
    Timer.periodic(Duration(seconds: 5), (Timer t) => fetchMessages());
  }

  Future<void> fetchMessages() async {
    try {
      final fetchedMessages = await retrieveMessages(widget.loggedinPerson);
      setState(() {
        messages = fetchedMessages.map((message) {
          message['timestamp'] = formatTimestamp(message['timestamp']);
          return message;
        }).toList();

        // Sort messages by timestamp
        messages.sort((a, b) => DateTime.parse(a['timestamp'])
            .compareTo(DateTime.parse(b['timestamp'])));
      });
      _scrollToBottom();
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }
/*
  String formatTimestamp(String timestamp) {
    try {
      timestamp = timestamp.replaceAll("m", "").replaceAll("H", ":").replaceAll("M", "").trim();
      var parts = timestamp.split(" ");
      var datePart = parts[0];
      var timePart = parts[1];

      var dateElements = datePart.split("-");
      String year = dateElements[0];
      String month = dateElements[1].padLeft(2, '0');
      String day = dateElements[2].padLeft(2, '0');

      var timeElements = timePart.split(":");
      String hour = timeElements[0].padLeft(2, '0');
      String minute = timeElements[1].padLeft(2, '0');

      return "$year-$month-$day $hour:$minute";
    } catch (e) {
      print('Error formatting timestamp: $e');
      return "1970-01-01 00:00";
    }
  }
*/
  String formatTimestamp(String timestamp) {
    try {
      // Parse the input string directly as ISO 8601 if possible
      DateTime parsedDate = DateTime.parse(timestamp);

      // Format the parsed date into the desired format "YYYY-MM-DD HH:mm"
      String formattedDate = "${parsedDate.year.toString().padLeft(4, '0')}-"
          "${parsedDate.month.toString().padLeft(2, '0')}-"
          "${parsedDate.day.toString().padLeft(2, '0')} "
          "${parsedDate.hour.toString().padLeft(2, '0')}:"
          "${parsedDate.minute.toString().padLeft(2, '0')}";

      return formattedDate;
    } catch (e) {
      // Debugging output for unexpected input
      print('Error formatting timestamp "$timestamp": $e');
      return DateTime.fromMillisecondsSinceEpoch(0).toIso8601String(); // Default to epoch start in ISO 8601 format
    }
  }


  Future<List<Map<String, dynamic>>> retrieveMessages(String sender) async {
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievemessages');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'person1': widget.loggedinPerson,
        'person2': widget.otherPerson,
      }),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      print('Failed to retrieve messages: ${response.body}');
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(String content) async {
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createmessage');
    // Get the current timestamp in the required format
    String currentTimestamp = DateTime.now().toUtc().toIso8601String();
    final body = jsonEncode({
      'person1': widget.loggedinPerson, // Sender
      'person2': widget.otherPerson,   // Receiver
      'content': content,
      'timestamp': currentTimestamp,   // Add the timestamp
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        fetchMessages(); // Refresh messages
      } else {
        print('Failed to send message: ${response.body}');
        _showError('Failed to send message. Please try again. ${response.body}');
      }
    } catch (e) {
      print('Exception occurred while sending message: $e');
      _showError('An error occurred while sending the message.');
    }
  }

  void handleSend() async {
    if (_controller.text.isNotEmpty) {
      await sendMessage(_controller.text);
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(Map<String, dynamic> message) {
    bool isSender = message['sender'] == widget.loggedinPerson;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['content'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              message['timestamp'] ?? '',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.otherPerson}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

