import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//{{azure_url}}/Listpersonmessages
class NotificationsScreen extends StatefulWidget {
  final String notificationType;

  NotificationsScreen({required this.notificationType});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final url = widget.notificationType == 'sos'
          ? 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/myfriendssosretrieve'
          : 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/appnotifications'; // Use correct URL for app notifications

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"person": "rajkiran"}), // Replace with your actual payload if needed
      );

      if (response.statusCode == 200) {
        setState(() {
          _notifications = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notificationType == 'sos' ? 'SOS Notifications' : 'App Notifications'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(child: Text('Failed to load notifications'))
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(_notifications[index]);
        },
      ),
    );
  }

  Widget _buildNotificationCard(dynamic notification) {
    if (widget.notificationType == 'sos') {
      return Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${notification['name']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('Location: Lat ${notification['lat']}, Lng ${notification['lng']}'),
              SizedBox(height: 5),
              Text('Timestamp: ${notification['formatted_timestamp']}'),
              SizedBox(height: 5),
              if (notification['message'] != null) Text('Message: ${notification['message']}'),
              if (notification['mobilenumber'] != null)
                Text('Mobile Number: ${notification['mobilenumber']}'),
            ],
          ),
        ),
      );
    } else {
      return Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Notification: ${notification['title']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Details: ${notification['details']}'),
            ],
          ),
        ),
      );
    }
  }
}


