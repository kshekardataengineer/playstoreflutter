// fetch_jobs.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'job.dart';

Future<List<Job>> fetchJobs() async {
  final response = await http.get(Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievealljobs')); // Replace with your API URL

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return Job.fromJsonList(data); // Parse the JSON list into a list of Job objects
  } else {
    throw Exception('Failed to load jobs');
  }
}
