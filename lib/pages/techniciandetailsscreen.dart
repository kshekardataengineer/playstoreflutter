/* working code
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class TechnicianDetailsScreen extends StatefulWidget {
  final String technicianName;

  TechnicianDetailsScreen({required this.technicianName});

  @override
  _TechnicianDetailsScreenState createState() => _TechnicianDetailsScreenState();
}

class _TechnicianDetailsScreenState extends State<TechnicianDetailsScreen> {
  Map<String, dynamic>? technicianDetails;

  @override
  void initState() {
    super.initState();
    fetchTechnicianDetails();
  }

  Future<void> fetchTechnicianDetails() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/gettechnicianpersondetails');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'technicianname': widget.technicianName}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Filter to get the first valid record with non-null `lat` and `dob`
      final validRecord = data.firstWhere(
            (record) => record['lat'] != null && record['dob'] != null,
        orElse: () => null,
      );

      if (validRecord != null) {
        setState(() {
          technicianDetails = validRecord;
        });
      }
    } else {
      // Handle errors
      print('Failed to load technician details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Details')),
      body: technicianDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${technicianDetails!['name']}', style: TextStyle(fontSize: 18)),
            Text('DOB: ${technicianDetails!['dob']}'),
            Text('City: ${technicianDetails!['city']}'),
            Text('State: ${technicianDetails!['state']}'),
            Text('Country: ${technicianDetails!['personCountry']}'),
            Text('Occupation: ${technicianDetails!['personOccupation']}'),
            Text('Role: ${technicianDetails!['personRole']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add chat or contact functionality here
                // This could launch a messaging feature or dialer
              },
              child: Text('Chat or Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/* this is nice
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TechnicianDetailsScreen extends StatefulWidget {
  final String technicianName;

  TechnicianDetailsScreen({required this.technicianName});

  @override
  _TechnicianDetailsScreenState createState() => _TechnicianDetailsScreenState();
}

class _TechnicianDetailsScreenState extends State<TechnicianDetailsScreen> {
  Map<String, dynamic>? technicianDetails;

  @override
  void initState() {
    super.initState();
    fetchTechnicianDetails();
  }

  Future<void> fetchTechnicianDetails() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/gettechnicianpersondetails');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'technicianname': widget.technicianName}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final validRecord = data.firstWhere(
            (record) => record['lat'] != null && record['dob'] != null,
        orElse: () => null,
      );

      if (validRecord != null) {
        setState(() {
          technicianDetails = validRecord;
        });
      }
    } else {
      print('Failed to load technician details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Details')),
      body: technicianDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(technicianDetails!['profilePic'] ?? 'https://via.placeholder.com/150'),
                ),
              ),
              SizedBox(height: 16),

              // Technician Information
              Text('Name: ${technicianDetails!['name']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('DOB: ${technicianDetails!['dob']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('City: ${technicianDetails!['city']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('State: ${technicianDetails!['state']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Country: ${technicianDetails!['personCountry']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Occupation: ${technicianDetails!['personOccupation']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Role: ${technicianDetails!['personRole']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Contact Information
              Text('Contact Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Website: ${technicianDetails!['website'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Available Time: ${technicianDetails!['availableTime'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Chat or Contact Button
              ElevatedButton(
                onPressed: () {
                  // Add chat or contact functionality here
                  // This could launch a messaging feature or dialer
                },
                child: Text('Chat or Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

/* purely testing-1 it has to be enhanced

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TechnicianDetailsScreen extends StatefulWidget {
  final String technicianName;

  TechnicianDetailsScreen({required this.technicianName});

  @override
  _TechnicianDetailsScreenState createState() => _TechnicianDetailsScreenState();
}

class _TechnicianDetailsScreenState extends State<TechnicianDetailsScreen> {
  Map<String, dynamic>? technicianDetails;

  @override
  void initState() {
    super.initState();
    fetchTechnicianDetails();
  }

  Future<void> fetchTechnicianDetails() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/gettechnicianpersondetails');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'technicianname': widget.technicianName}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final validRecord = data.firstWhere(
            (record) => record['lat'] != null && record['dob'] != null,
        orElse: () => null,
      );

      if (validRecord != null) {
        setState(() {
          technicianDetails = validRecord;
        });
      }
    } else {
      print('Failed to load technician details');
    }
  }

  Future<void> findConnection(String person1, String person2) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortestfriendroute');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'person1': person1, 'person2': person2}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      // Assuming the output is structured correctly
      if (result.isNotEmpty && result[0]['connections'] != null) {
        List<String> connections = List<String>.from(result[0]['connections']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectionPathScreen(connections: connections),
          ),
        );
      } else {
        // Handle case when there are no connections
        _showNoConnectionsDialog();
      }
    } else {
      print('Failed to find connections');
    }
  }

  void _showNoConnectionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Connections'),
          content: Text('There are no common friends between the two individuals.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Details')),
      body: technicianDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(technicianDetails!['profilePic'] ?? 'https://via.placeholder.com/150'),
                ),
              ),
              SizedBox(height: 16),

              // Technician Information
              Text('Name: ${technicianDetails!['name']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('DOB: ${technicianDetails!['dob']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('City: ${technicianDetails!['city']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('State: ${technicianDetails!['state']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Country: ${technicianDetails!['personCountry']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Occupation: ${technicianDetails!['personOccupation']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Role: ${technicianDetails!['personRole']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Contact Information
              Text('Contact Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Website: ${technicianDetails!['website'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Available Time: ${technicianDetails!['availableTime'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Chat or Contact Button
              ElevatedButton(
                onPressed: () {
                  // Add chat or contact functionality here
                },
                child: Text('Chat or Contact'),
              ),

              SizedBox(height: 16),

              // Find Connection Button
              ElevatedButton(
                onPressed: () {
                  String loggedInUserName = "rakesh"; // Replace with actual logged-in username
                  findConnection(loggedInUserName, widget.technicianName);
                },
                child: Text('Find Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen to display the connection path
class ConnectionPathScreen extends StatelessWidget {
  final List<String> connections;

  ConnectionPathScreen({required this.connections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connection Path')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: connections.isEmpty
            ? Center(child: Text('No connections found.'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connection Path:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            for (int i = 0; i < connections.length; i++)
              Text('${i + 1}. ${connections[i]}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
*/
/*experimental testing graph view*/
/*
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ConnectionPathScreen.dart';

class TechnicianDetailsScreen extends StatefulWidget {
  final String technicianName;

  TechnicianDetailsScreen({required this.technicianName});

  @override
  _TechnicianDetailsScreenState createState() => _TechnicianDetailsScreenState();
}

class _TechnicianDetailsScreenState extends State<TechnicianDetailsScreen> {
  Map<String, dynamic>? technicianDetails;

  @override
  void initState() {
    super.initState();
    fetchTechnicianDetails();
  }

  Future<void> fetchTechnicianDetails() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/gettechnicianpersondetails');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'technicianname': widget.technicianName}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final validRecord = data.firstWhere(
            (record) => record['lat'] != null && record['dob'] != null,
        orElse: () => null,
      );

      if (validRecord != null) {
        setState(() {
          technicianDetails = validRecord;
        });
      }
    } else {
      print('Failed to load technician details');
    }
  }

  Future<void> findConnection(String person1, String person2) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortestfriendroute');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'person1': person1, 'person2': person2}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result[0]['connections'] != null) {
        List<String> connections = List<String>.from(result[0]['connections']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectionPathScreen(connections: connections),
          ),
        );
      } else {
        _showNoConnectionsDialog();
      }
    } else {
      print('Failed to find connections');
    }
  }

  void _showNoConnectionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Connections'),
          content: Text('There are no common friends between the two individuals.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Details')),
      body: technicianDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(technicianDetails!['profilePic'] ?? 'https://via.placeholder.com/150'),
                ),
              ),
              SizedBox(height: 16),

              // Technician Information
              Text('Name: ${technicianDetails!['name']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('DOB: ${technicianDetails!['dob']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('City: ${technicianDetails!['city']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('State: ${technicianDetails!['state']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Country: ${technicianDetails!['personCountry']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Occupation: ${technicianDetails!['personOccupation']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Role: ${technicianDetails!['personRole']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Contact Information
              Text('Contact Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Website: ${technicianDetails!['website'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Available Time: ${technicianDetails!['availableTime'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Chat or Contact Button
              ElevatedButton(
                onPressed: () {
                  // Add chat or contact functionality here
                },
                child: Text('Chat or Contact'),
              ),

              SizedBox(height: 16),

              // Find Connection Button
              ElevatedButton(
                onPressed: () {
                  String loggedInUserName = "rakesh"; // Replace with actual logged-in username
                  findConnection(loggedInUserName, widget.technicianName);

                },
                child: Text('Find Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}above working*/

/*working only logo and website description was not loading
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'chat_screen.dart';
class ConnectionBox extends StatelessWidget {
  final String text;

  const ConnectionBox({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class ArrowDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(24, 24),
      painter: _ArrowPainter(),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw downward arrow
    Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height - 8) // vertical line
      ..moveTo(size.width / 2 - 5, size.height - 8)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 2 + 5, size.height - 8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint( CustomPainter oldDelegate) {
    return false;
  }
}

class TechnicianDetailsScreen extends StatefulWidget {
  final String technicianName;

  TechnicianDetailsScreen({required this.technicianName});

  @override
  _TechnicianDetailsScreenState createState() => _TechnicianDetailsScreenState();
}

class _TechnicianDetailsScreenState extends State<TechnicianDetailsScreen> {
  Map<String, dynamic>? technicianDetails;

  @override
  void initState() {
    super.initState();
    fetchTechnicianDetails();
  }

  Future<void> fetchTechnicianDetails() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/gettechnicianpersondetails');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'technicianname': widget.technicianName}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final validRecord = data.firstWhere(
            (record) => record['lat'] != null && record['dob'] != null,
        orElse: () => null,
      );

      if (validRecord != null) {
        setState(() {
          technicianDetails = validRecord;
        });
      }
    } else {
      print('Failed to load technician details');
    }
  }

  Future<void> findConnection(String person1, String person2) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortesfriendtroute');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'person1': person1, 'person2': person2}),
    );

    print('Response status: ${response.statusCode}'); // Debugging: check status code
    print('Response body: ${response.body}'); // Debugging: check response body

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result[0]['connections'] != null) {
        List<String> connections = List<String>.from(result[0]['connections']);
        _showConnectionDialog(connections);
      } else {
        _showNoConnectionsDialog();
      }
    } else {
      print('Failed to find connections');
    }
  }


  /*void _showConnectionDialog(List<String> connections) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Path'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: connections.length,
              itemBuilder: (context, index) {
                return Text('${index + 1}. ${connections[index]}');
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/




  void _showConnectionDialog(List<String> connections) {
    showDialog(
      context: context, // Access BuildContext directly here
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Path'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: connections.length,
              itemBuilder: (context, index) {
                bool isLastItem = index == connections.length - 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Box for each connection
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        '${index + 1}. ${connections[index]}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Add an arrow if not the last item
                    if (!isLastItem)
                      Icon(
                        Icons.arrow_downward,
                        size: 24,
                        color: Colors.black54,
                      ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }





  void _showNoConnectionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Connections'),
          content: Text('There are no common friends between the two individuals.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Details')),
      body: technicianDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  //backgroundImage: NetworkImage(technicianDetails!['profilePic'] ?? ''),
                ),
              ),
              SizedBox(height: 16),

              // Technician Information
              Text('Name: ${technicianDetails!['name']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('DOB: ${technicianDetails!['dob']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('City: ${technicianDetails!['city']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('State: ${technicianDetails!['state']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Country: ${technicianDetails!['personCountry']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Occupation: ${technicianDetails!['personOccupation']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Role: ${technicianDetails!['personRole']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Contact Information
              Text('Contact Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Website: ${technicianDetails!['website'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Available Time: ${technicianDetails!['availableTime'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Chat or Contact Button
              ElevatedButton(
                onPressed: () {
                  String loggedInUserName = "rakesh";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(sender: widget.technicianName),
                    ),
                  );
                },
                child: Text('Chat or Contact'),
              ),

              SizedBox(height: 16),

              // Find Connection Button
              ElevatedButton(
                onPressed: () {
                  String loggedInUserName = "rakesh"; // Replace with actual logged-in username
                 // findConnection(loggedInUserName, widget.technicianName);
                  findConnection(loggedInUserName, "krishna");
                  // To test dialog without API, uncomment:
                  // _showConnectionDialog(['Friend A', 'Friend B', 'Friend C']);
                  // or
                  // _showNoConnectionsDialog();
                },
                child: Text('Find Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
working code below code updated to load logo */
/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';  // for base64Decode
import 'package:http/http.dart' as http;
import 'dart:typed_data';  // for Uint8List

import 'chat_screen.dart';

class TechnicianDetailsScreen extends StatefulWidget {
  final String technicianName;

  TechnicianDetailsScreen({required this.technicianName});

  @override
  _TechnicianDetailsScreenState createState() => _TechnicianDetailsScreenState();
}

class _TechnicianDetailsScreenState extends State<TechnicianDetailsScreen> {
  Map<String, dynamic>? technicianDetails;
  Uint8List? profileImageBytes;  // To store the image data

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchTechnicianDetails();
    fetchProfileImage();
  }
  //update in  api /listkonktserviceswithdetails to return if any new fields added in technician node

  // Fetch technician details
  Future<void> fetchTechnicianDetails() async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/gettechnicianpersondetails');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'technicianname': widget.technicianName}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final validRecord = data.firstWhere(
            (record) => record['lat'] != null && record['dob'] != null,
        orElse: () => null,
      );

      if (validRecord != null) {
        setState(() {
          technicianDetails = validRecord;
        });
      }
    } else {
      print('Failed to load technician details');
    }
  }

  // Fetch the profile image
  /*Future<void> fetchProfileImage() async {
    final url = Uri.parse('https://your-api-url/get_logopic');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': widget.technicianName}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        // Assuming the image is base64 encoded in the response, decode it
        String base64Image = data['image'];  // Adjust this key based on your API response
        profileImageBytes = base64Decode(base64Image);  // Decode base64 string to bytes
      });
    } else {
      print('Failed to load profile image');
    }
  }
*/

  Future<void> fetchProfileImage() async {
    const String url = "https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_logopic";
    String name = widget.technicianName; // Replace with your variable if needed

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": name}),
      );

      if (response.statusCode == 200) {
        setState(() {
          profileImageBytes = response.bodyBytes;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load image");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching profile image: $e");
    }
  }

  // Find connection between two persons
  Future<void> findConnection(String person1, String person2) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortesfriendtroute');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'person1': person1, 'person2': person2}),
    );

    print('Response status: ${response.statusCode}'); // Debugging: check status code
    print('Response body: ${response.body}'); // Debugging: check response body

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result[0]['connections'] != null) {
        List<String> connections = List<String>.from(result[0]['connections']);
        _showConnectionDialog(connections);
      } else {
        _showNoConnectionsDialog();
      }
    } else {
      print('Failed to find connections');
    }
  }

  // Show the connection path in a dialog
  void _showConnectionDialog(List<String> connections) {
    showDialog(
      context: context, // Access BuildContext directly here
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Path'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: connections.length,
              itemBuilder: (context, index) {
                bool isLastItem = index == connections.length - 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Box for each connection
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        '${index + 1}. ${connections[index]}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Add an arrow if not the last item
                    if (!isLastItem)
                      Icon(
                        Icons.arrow_downward,
                        size: 24,
                        color: Colors.black54,
                      ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show the "no connection" dialog if no connection exists
  void _showNoConnectionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Connections'),
          content: Text('There are no common friends between the two individuals.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Details')),
      body: technicianDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
             Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImageBytes != null
                      ? MemoryImage(profileImageBytes!) // Display the image from memory
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                ),
              ),

              SizedBox(height: 16),

              // Technician Information
              Text('Name: ${technicianDetails!['name']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('DOB: ${technicianDetails!['dob']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('City: ${technicianDetails!['city']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('State: ${technicianDetails!['state']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Country: ${technicianDetails!['personCountry']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Occupation: ${technicianDetails!['personOccupation']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Role: ${technicianDetails!['personRole']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),

              // **Long Description Field** - wrapped in SingleChildScrollView for better readability
              Text('Description:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              // Wrapping description in a SingleChildScrollView to handle long text
              SingleChildScrollView(
                child: Text(
                  technicianDetails!['description'] ?? 'No description available.',
                  style: TextStyle(fontSize: 18),
                  softWrap: true,  // Allow the text to wrap naturally
                  overflow: TextOverflow.visible,  // Ensure text doesn't get clipped
                ),
              ),
              SizedBox(height: 20),

              // Contact Information
              Text('Contact Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Website: ${technicianDetails!['website'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Available Time: ${technicianDetails!['availability'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Chat or Contact Button
              ElevatedButton(
                onPressed: () {
                  String loggedInUserName = "rakesh";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(sender: widget.technicianName),
                    ),
                  );
                },
                child: Text('Chat or Contact'),
              ),

              SizedBox(height: 16),

              // Find Connection Button
              ElevatedButton(
                onPressed: () {
                  String loggedInUserName = "rajkiran"; // Replace with actual logged-in username
                  findConnection(loggedInUserName, widget.technicianName);  // Find connection with technician
                },
                child: Text('Find Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
working code but website description availability was not loading*/

/*gettechnicianpersondetails need update tis to get latet parameters in technician screen */
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'chat_screen.dart';

class TechnicianDetailsScreen extends StatefulWidget {
  final String technicianName;

  TechnicianDetailsScreen({required this.technicianName});

  @override
  _TechnicianDetailsScreenState createState() =>
      _TechnicianDetailsScreenState();
}

class _TechnicianDetailsScreenState extends State<TechnicianDetailsScreen> {
  Map<String, dynamic>? technicianDetails;
  Uint8List? profileImageBytes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTechnicianDetails();
    fetchProfileImage();
  }

  // Fetch technician details
  Future<void> fetchTechnicianDetails() async {
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/gettechnicianpersondetails');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'technicianname': widget.technicianName}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final validRecord = data.isNotEmpty ? data.first : null;

        if (validRecord != null) {
          setState(() {
            technicianDetails = validRecord;
          });
        } else {
          print('No valid technician details found.');
        }
      } else {
        print('Failed to fetch technician details.');
      }
    } catch (e) {
      print('Error fetching technician details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch the profile image
  Future<void> fetchProfileImage() async {
    const String url = "https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_logopic";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": widget.technicianName}),
      );

      if (response.statusCode == 200) {
        setState(() {
          profileImageBytes = response.bodyBytes;
        });
      } else {
        print('Failed to fetch profile image. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  // Display connection dialog
  Future<void> findConnection(String person1, String person2) async {
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/findshortesfriendtroute');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'person1': person1, 'person2': person2}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        if (result.isNotEmpty && result[0]['connections'] != null) {
          List<String> connections =
          List<String>.from(result[0]['connections']);
          _showConnectionDialog(connections);
        } else {
          _showNoConnectionsDialog();
        }
      } else {
        print('Failed to find connections.');
      }
    } catch (e) {
      print('Error finding connections: $e');
    }
  }

  // Show connection dialog
  void _showConnectionDialog(List<String> connections) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Path'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: connections
                .map((connection) => Text('- $connection'))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Show "no connections" dialog
  void _showNoConnectionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Connections'),
          content: Text('No connections found between these users.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Details')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : technicianDetails == null
          ? Center(child: Text('No details available'))
          : buildTechnicianDetails(),
    );
  }

  // Build UI for displaying technician details
  Widget buildTechnicianDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileImageBytes != null
                    ? MemoryImage(profileImageBytes!)
                    : AssetImage('assets/default_profile.png')
                as ImageProvider,
              ),
            ),
            SizedBox(height: 16),

            // Technician Information
            Text(
              'Name: ${technicianDetails!['name'] ?? 'N/A'}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('DOB: ${technicianDetails!['dob'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('City: ${technicianDetails!['city'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('State: ${technicianDetails!['state'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Country: ${technicianDetails!['personCountry'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Occupation: ${technicianDetails!['personOccupation'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Role: ${technicianDetails!['personRole'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Website: ${technicianDetails!['website'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'Availability: ${technicianDetails!['availability'] ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Description:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              technicianDetails!['description'] ?? 'No description available.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              technicianDetails!['contact'] ?? 'No contact available.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // Contact or Chat Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      sender: widget.technicianName,
                    ),
                  ),
                );
              },
              child: Text('Chat or Contact'),
            ),

            // Find Connection Button
            ElevatedButton(
              onPressed: () {
                String loggedInUserName = "rajkiran"; // Replace as needed
                findConnection(loggedInUserName, widget.technicianName);
              },
              child: Text('Find Connection'),
            ),
          ],
        ),
      ),
    );
  }
}

