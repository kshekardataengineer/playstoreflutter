/* perfectly working only filter not there
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konktapp/pages/techniciandetailsscreen.dart';


class CategoryScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> services;

  CategoryScreen({required this.category, required this.services});

  @override
  Widget build(BuildContext context) {
    final filteredServices = services.where((service) => service['Category'] == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          final service = filteredServices[index];
          return ListTile(
            title: Text(service['Service']),
            subtitle: Text('Technician: ${service['Technician']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TechnicianDetailsScreen(technicianName: service['Technician']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/

//applying filter need to test

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konktapp/pages/techniciandetailsscreen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> services;

  CategoryScreen({required this.category, required this.services});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<Map<String, dynamic>> filteredServices;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Initially, show all services in the selected category
    filteredServices = widget.services
        .where((service) => service['Category'] == widget.category)
        .toList();
  }

  void filterServices(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      final terms = searchQuery
          .split(RegExp(r'[,\s]+')) // Split by commas or spaces
          .where((term) => term.isNotEmpty)
          .toList();

      // Filter services based on the search query
      filteredServices = widget.services.where((service) {
        // Ensure service is in the selected category
        if (service['Category'] != widget.category) return false;

        // Extract service fields for filtering
        final name = service['Service'].toLowerCase();
        final technician = service['Technician'].toLowerCase();
        final city = service['City']?.toLowerCase() ?? "";
        final state = service['State']?.toLowerCase() ?? "";
        final country = service['Country']?.toLowerCase() ?? "";
        final occupation = service['Occupation']?.toLowerCase() ?? "";
        final role = service['Role']?.toLowerCase() ?? "";

        // Check if all terms match at least one property
        return terms.every((term) =>
        name.contains(term) ||
            technician.contains(term) ||
            city.contains(term) ||
            state.contains(term) ||
            country.contains(term) ||
            occupation.contains(term) ||
            role.contains(term));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: filterServices,
              decoration: InputDecoration(
                hintText: 'Search by name, city, state, etc.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          final service = filteredServices[index];
          return ListTile(
            title: Text(service['Service']),
            subtitle: Text('Technician: ${service['Technician']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TechnicianDetailsScreen(
                    technicianName: service['Technician'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
/* ABOVE CODE working code perfectly*/

/* updating to pull from api*/
/*NOT WORKING*/
/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konktapp/pages/techniciandetailsscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryScreen extends StatefulWidget {
  final String category; // Category passed in the constructor

  // Constructor to receive the category
  CategoryScreen({required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<Map<String, dynamic>> filteredServices = [];
  String searchQuery = "";
  bool isLoading = true;  // To track loading state
  String errorMessage = '';  // To store error messages

  @override
  void initState() {
    super.initState();
    _fetchServices();  // Fetch the services based on the category
  }

  // Fetching the services based on the category passed in the constructor
  Future<void> _fetchServices() async {
    setState(() {
      isLoading = true;  // Show loading indicator
      errorMessage = '';  // Clear any previous error message
    });

    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/techniciansbycategory');

    // Prepare the request body with the category passed through the constructor
    final requestBody = json.encode({
      'category': widget.category,  // Use widget.category here
    });

    try {
      // Log category and request details for debugging
      print('Fetching services for category: ${widget.category}');
      print('Request body: $requestBody');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      // Log response details for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> servicesData = json.decode(response.body);

        // Log the entire service data for debugging
        print('API Response: $servicesData');

        // Filter services based on the category and log the filtered result
        filteredServices = servicesData
            .where((service) {
          // Log the category of each service for debugging
          print('Service Category: ${service['Category']}');
          print('Widget Category: ${widget.category}');
          return service['Category'] == widget.category;
        })
            .map((service) => Map<String, dynamic>.from(service))
            .toList();

        // Log filtered services to ensure filtering is done correctly
        print('Filtered Services: $filteredServices');

        setState(() {
          isLoading = false;  // Data is successfully loaded
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;  // Stop loading if data fails
        });
      }
    } catch (e) {
      // Log the error for debugging
      print('Error during API call: $e');

      setState(() {
        errorMessage = 'Error: $e';  // Handle network error or exception
        isLoading = false;
      });
    }
  }

  // Filter services based on the search query
  void filterServices(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      final terms = searchQuery
          .split(RegExp(r'[,\s]+')) // Split by commas or spaces
          .where((term) => term.isNotEmpty)
          .toList();

      // Filter services based on the search query
      filteredServices = filteredServices.where((service) {
        // Extract service fields for filtering
        final name = service['Service'].toLowerCase();
        final technician = service['Technician'].toLowerCase();
        final city = service['TechnicianLocation']?.toLowerCase() ?? "";
        final rating = service['TechnicianRating'].toString().toLowerCase();

        // Check if all terms match at least one property
        return terms.every((term) =>
        name.contains(term) ||
            technician.contains(term) ||
            city.contains(term) ||
            rating.contains(term));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category), // Use widget.category here
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: filterServices,
              decoration: InputDecoration(
                hintText: 'Search by name, city, rating, etc.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage)) // Show error message if any
          : filteredServices.isEmpty
          ? Center(child: Text('No services found'))
          : ListView.builder(
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          final service = filteredServices[index];
          return ListTile(
            title: Text(service['Service']),
            subtitle: Text('Technician: ${service['Technician']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TechnicianDetailsScreen(
                    technicianName: service['Technician'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/