import 'dart:convert'; // For encoding and decoding JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JobListScreen1(),
    );
  }
}

class JobListScreen1 extends StatefulWidget {
  @override
  _JobListScreenState1 createState() => _JobListScreenState1();
}

class _JobListScreenState1 extends State<JobListScreen1> {
  List<dynamic> _jobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    const url = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/lisitofselectedjobs';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'person': 'Ganesh'});

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        setState(() {
          _jobs = json.decode(response.body);
        });
      } else {
        // Handle the error response
        print('Failed to load jobs. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job List'),
      ),
      body: _jobs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          final role = job['j']['role'];
          final status = job['r.status'];

          return ListTile(
            title: Text(role),
            subtitle: Text('Status: $status'),
          );
        },
      ),
    );
  }
}
