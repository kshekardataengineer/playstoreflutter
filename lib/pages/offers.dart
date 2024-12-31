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
      home: JobListOffer(),
    );
  }
}

class JobListOffer extends StatefulWidget {
  @override
  _JobListOfferState createState() => _JobListOfferState();
}

class _JobListOfferState extends State<JobListOffer> {
  List<dynamic> _jobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    const url = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/personselectedforjobs';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'person': 'venkatesh'});

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
        title: Text('Job Offers'),
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
