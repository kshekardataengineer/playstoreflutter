/*import 'package:flutter/material.dart';
//import 'job.dart'; // Import the Job model
import 'fetch_jobs.dart';
//import 'jobmodel.dart';
import '../model/job.dart';// Import the function to fetch jobs

/*void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Listings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JobListScreen(),
    );
  }
}*/

class JobListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Listings'),
      ),
      body: FutureBuilder<List<Job>>(
        future: fetchJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No jobs available.'));
          }

          final jobs = snapshot.data!;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return ListTile(
                title: Text(job.jobDesignation),
                subtitle: Text('${job.companyName} - ${job.salary}'),
                onTap: () {
                  // Optional: Show more details on tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(job: job),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class JobDetailScreen extends StatelessWidget {
  final Job job;

  JobDetailScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.jobDesignation),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: ${job.companyName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Contact Email: ${job.contactEmail}'),
            Text('Contact Name: ${job.contactName}'),
            Text('Website: ${job.contactWebsite}'),
            Text('Job Type: ${job.jobType}'),
            Text('Paid: ${job.paid}'),
            Text('Requirements: ${job.requirements}'),
            Text('Role: ${job.role}'),
            Text('Salary: ${job.salary}'),
            Text('Status: ${job.status}'),
            Text('Visa Status: ${job.visaStatus}'),
          ],
        ),
      ),
    );
  }
}*/
