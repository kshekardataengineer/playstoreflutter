import 'dart:convert';
import 'package:http/http.dart' as http;

//import '../jobmodel.dart';
import '../model/job.dart';
//import 'job.dart';
//import 'jobmodel.dart'; // Import the Job model

Future<List<Job>> fetchJobs() async {
  final response = await http.post(
    Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievealljobs'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({}),
  );

  if (response.statusCode == 200) {
    // Parse the JSON response
    final List<dynamic> jobsJson = json.decode(response.body);
    // Map JSON data to Job objects
    return jobsJson.map((json) => Job.fromJson(json['j'])).toList();
  } else {
    throw Exception('Failed to load jobs');
  }
}
