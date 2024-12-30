import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../jobmodel.dart';
import '../jobsmaintest.dart';
import '../model/job.dart';
import 'jobssupport.dart'; // Import your Job model
import 'selected.dart';
void main() {
  runApp(MaterialApp(
    home: JobScreen(),
  ));
}

class JobScreen extends StatefulWidget {
  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedMenuIndex = 0; // Default to "Jobs" tab

  final List<String> menuTitles = [
    "Jobs",
    "Selected",
    "Offer",
    "Create Jobs"
  ];

  final List<Widget> menuContents = [
    JobsTab(), // Updated JobsTab with Search Bar
    //Center(child: Text("Selected Content Placeholder")),
    JobListScreen1(),
    Center(child: Text("Offer Content Placeholder")),
    //offerscreen(),
    CreateJobTab(), // Integrate the CreateJobTab here
  ];

  void _onMenuItemTap(int index) {
    setState(() {
      _selectedMenuIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job title'),
        backgroundColor: Colors.white, // Customize app bar color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(menuTitles.length, (index) {
                return GestureDetector(
                  onTap: () => _onMenuItemTap(index),
                  child: MenuItem(
                    title: menuTitles[index],
                    isActive: _selectedMenuIndex == index,
                  ),
                );
              }),
            ),
          ),
          Divider(thickness: 2),

          // Display search bar and content based on selected menu item
          if (_selectedMenuIndex == 0) // Only show the search bar in Jobs tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            ),

          // Display content based on selected menu item
          Expanded(
            child: menuContents[_selectedMenuIndex],
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const MenuItem({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 2,
          width: 60,
          color: isActive ? Colors.black : Colors.transparent,
        ),
      ],
    );
  }
}

// Updated JobsTab with Search and Fetch Jobs Functionality
class JobsTab extends StatefulWidget {
  @override
  _JobsTabState createState() => _JobsTabState();
}

class _JobsTabState extends State<JobsTab> {
  List<Job> _jobs = [];
  bool _isLoading = false; // To show a loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    _fetchJobs(); // Fetch jobs when the tab is loaded
  }

  Future<void> _fetchJobs() async {
    setState(() {
      _isLoading = true; // Start loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/retrievealljobs'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({}), // Send an empty JSON object as per your endpoint
      );
      print(response.statusCode);
      print(response);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> jobData = json.decode(response.body);
        print(jobData);

        // Map the JSON response to the Job model
        _jobs = jobData.map((data) => Job.fromJson(data['j'])).toList();
        print(_jobs);

        setState(() {
          _isLoading = false; // Stop loading indicator
        });
      } else {
        setState(() {
          _isLoading = false; // Stop loading indicator
        });
        // Show error if the response is not 200
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load jobs.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
      // Show error if there is an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_jobs.isEmpty) {
      return Center(child: Text('No jobs available.'));
    } else {
      return ListView.builder(
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return ListTile(
            title: Text(job.companyName),
            subtitle: Text(job.role),
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
    }
  }
}

class CreateJobTab extends StatefulWidget {
  @override
  _CreateJobTabState createState() => _CreateJobTabState();
}

class _CreateJobTabState extends State<CreateJobTab> {
  final _formKey = GlobalKey<FormState>();
  final _job = Job(
    companyName: '',
    role: '',
    paid: false,
    jobDesignation: '',
    jobType: 'Full-time', // Default value
    salary: '',
    visaStatus: 'Required', // Default value
    requirements: '',
    status: '',
    contactWebsite: '',
    contactEmail: '',
    contactName: '',
    country: '',
    state: '',
    location: '',
  );

  Future<void> _createJob() async {
    if (!_formKey.currentState!.validate()) {
      return; // If the form is not valid, do not proceed
    }

    _formKey.currentState!.save(); // Save the form fields

    try {
      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createjob'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "companyname": _job.companyName,
          "role": _job.role,
          "paid": _job.paid.toString(),
          "job_designation": _job.jobDesignation,
          "job_type": _job.jobType,
          "salary": _job.salary,
          "visa_status": _job.visaStatus,
          "requirements": _job.requirements,
          "status": _job.status,
          "contact_website": _job.contactWebsite,
          "contact_email": _job.contactEmail,
          "contact_name": _job.contactName,
          "country": _job.country,
          "state": _job.state,
          "location": _job.location,
        }),
      );

      if (response.statusCode == 200) {
        // Job creation successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Job created successfully!')),
        );
      } else {
        // Job creation failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create job.')),
        );
      }
    } catch (e) {
      // Error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Company Name'),
              onChanged: (value) => _job.companyName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the company name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Role'),
              onChanged: (value) => _job.role = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the role';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Country'),
              onChanged: (value) => _job.country = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the country';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'State'),
              onChanged: (value) => _job.state = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the state';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Location'),
              onChanged: (value) => _job.location = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the location';
                }
                return null;
              },
            ),
            SwitchListTile(
              title: Text('Paid'),
              value: _job.paid,
              onChanged: (value) => setState(() => _job.paid = value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Job Designation'),
              onChanged: (value) => _job.jobDesignation = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the job designation';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _job.jobType,
              decoration: InputDecoration(labelText: 'Job Type'),
              items: ['Full-time', 'Part-time'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _job.jobType = newValue!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Salary'),
              onChanged: (value) => _job.salary = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the salary';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _job.visaStatus,
              decoration: InputDecoration(labelText: 'Visa Status'),
              items: ['Required', 'Not Required'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _job.visaStatus = newValue!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Requirements'),
              onChanged: (value) => _job.requirements = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the requirements';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Status'),
              onChanged: (value) => _job.status = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the job status';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Contact Website'),
              onChanged: (value) => _job.contactWebsite = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the contact website';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Contact Email'),
              onChanged: (value) => _job.contactEmail = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the contact email';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Contact Name'),
              onChanged: (value) => _job.contactName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the contact name';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _createJob,
              child: Text('Create Job'),
            ),
          ],
        ),
      ),
    );
  }
}
