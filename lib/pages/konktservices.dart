/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import for caching

import 'categoryscreen.dart';
import 'microservices.dart';

class KonktServicesScreen extends StatefulWidget {
  @override
  _KonktServicesScreenState createState() => _KonktServicesScreenState();
}

class _KonktServicesScreenState extends State<KonktServicesScreen> {
  List<Map<String, dynamic>> _konktServices = [];

  @override
  void initState() {
    super.initState();
    _loadCachedServices();
    _fetchKonktServices();
  }

  // Function to load cached services
  Future<void> _loadCachedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedServices = prefs.getString('konktServices');

    if (cachedServices != null) {
      setState(() {
        _konktServices = List<Map<String, dynamic>>.from(json.decode(cachedServices));
      });
    }
  }

  // Fetch services from server and update cache
  Future<void> _fetchKonktServices() async {
    try {
      final response = await http.get(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktservices'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedServices =
        List<Map<String, dynamic>>.from(json.decode(response.body));

        // Compare new data with cached data
        if (!_isDataSame(fetchedServices, _konktServices)) {
          setState(() {
            _konktServices = fetchedServices;
          });

          // Save the new data to cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('konktServices', json.encode(fetchedServices));
        }
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  // Helper function to compare fetched data with cached data
  bool _isDataSame(List<Map<String, dynamic>> newData, List<Map<String, dynamic>> cachedData) {
    return json.encode(newData) == json.encode(cachedData);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _konktServices.map((service) => service['Category']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Services'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Text color in AppBar
      ),
      body: Column(
        children: [
          // Horizontal list of categories
          Container(
            height: 600,
            //height:double.infinity,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryScreen(category: category, services: _konktServices),
                      ),
                    );
                  },
                  child: /*Container(
                    color: Colors.white,
                    //width: 50,//changed here it was 50
                    width: 50,
                    margin: EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        category, // First letter of the category
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),


                  ),*/
                  Container(

                    width: 80, // Adjust width to fit both CircleAvatar and label
                    margin: EdgeInsets.all(10),
                    color: Colors.white, // Optional: Set a background color for the container
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 25, // Adjust the size as needed
                          child: Text(
                            category[0].toUpperCase(), // Display only the first letter of the category
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 8), // Space between the CircleAvatar and label
                        Text(
                          category, // Full category name as label
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )

                );
              },
            ),
          ),
          // If no category is selected, show a message (optional)
          // Expanded(child: Center(child: Text('Select a service category above'))),
        ],
      ),
    );
  }
}


working code*/
/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/technicianregisterform.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for caching

import 'categoryscreen.dart';
import 'microservices.dart';


class KonktServicesScreen extends StatefulWidget {
  @override
  _KonktServicesScreenState createState() => _KonktServicesScreenState();
}

class _KonktServicesScreenState extends State<KonktServicesScreen> {
  List<Map<String, dynamic>> _konktServices = [];

  @override
  void initState() {
    super.initState();
    _loadCachedServices();
    _fetchKonktServices();
  }

  // Function to load cached services
  Future<void> _loadCachedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedServices = prefs.getString('konktServices');

    if (cachedServices != null) {
      setState(() {
        _konktServices = List<Map<String, dynamic>>.from(json.decode(cachedServices));
      });
    }
  }

  // Fetch services from server and update cache
  Future<void> _fetchKonktServices() async {
    try {
      final response = await http.get(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktservices'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedServices =
        List<Map<String, dynamic>>.from(json.decode(response.body));

        // Compare new data with cached data
        if (!_isDataSame(fetchedServices, _konktServices)) {
          setState(() {
            _konktServices = fetchedServices;
          });

          // Save the new data to cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('konktServices', json.encode(fetchedServices));
        }
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  // Helper function to compare fetched data with cached data
  bool _isDataSame(List<Map<String, dynamic>> newData, List<Map<String, dynamic>> cachedData) {
    return json.encode(newData) == json.encode(cachedData);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _konktServices.map((service) => service['Category']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Services'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Text color in AppBar
      ),
      body: Column(
        children: [
          // Horizontal grid of categories
          Container(
            height: 200, // You can adjust the height as needed
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Horizontal scrolling
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryScreen(category: category, services: _konktServices),
                      ),
                    );
                  },
                  child: Container(
                    width: 100, // Adjust width to fit both CircleAvatar and label
                    margin: EdgeInsets.all(10),
                    color: Colors.white, // Optional: Set a background color for the container
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30, // Adjust the size as needed
                          child: Text(
                            category[0].toUpperCase(), // Display only the first letter of the category
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 8), // Space between the CircleAvatar and label
                        Text(
                          category, // Full category name as label
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // Register Technician button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the Technician Form screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechnicianFormScreen(),
                  ),
                );
              },
              child: Text('Register as Technician'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/technicianregisterform.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for caching

import 'categoryscreen.dart';
import 'microservices.dart';

class KonktServicesScreen extends StatefulWidget {
  @override
  _KonktServicesScreenState createState() => _KonktServicesScreenState();
}

class _KonktServicesScreenState extends State<KonktServicesScreen> {
  List<Map<String, dynamic>> _konktServices = [];

  @override
  void initState() {
    super.initState();
    _loadCachedServices();
    _fetchKonktServices();
  }

  // Function to load cached services
  Future<void> _loadCachedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedServices = prefs.getString('konktServices');

    if (cachedServices != null) {
      setState(() {
        _konktServices = List<Map<String, dynamic>>.from(json.decode(cachedServices));
      });
    }
  }

  // Fetch services from server and update cache
  Future<void> _fetchKonktServices() async {
    try {
      final response = await http.get(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktservices'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedServices =
        List<Map<String, dynamic>>.from(json.decode(response.body));

        // Compare new data with cached data
        if (!_isDataSame(fetchedServices, _konktServices)) {
          setState(() {
            _konktServices = fetchedServices;
          });

          // Save the new data to cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('konktServices', json.encode(fetchedServices));
        }
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  // Helper function to compare fetched data with cached data
  bool _isDataSame(List<Map<String, dynamic>> newData, List<Map<String, dynamic>> cachedData) {
    return json.encode(newData) == json.encode(cachedData);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _konktServices.map((service) => service['Category']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Services'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Text color in AppBar
      ),
      body: Column(
        children: [
          // Grid view of categories (4 items per row)
          Container(
            height: 250, // Set a fixed height for the grid
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of icons per row
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 10, // Space between rows
                childAspectRatio: 1.2, // Adjust the size of each item
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryScreen(category: category, services: _konktServices),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.white, // Optional: Set a background color for the container
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30, // Adjust the size as needed
                          child: Text(
                            category[0].toUpperCase(), // Display only the first letter of the category
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 8), // Space between the CircleAvatar and label
                        Text(
                          category, // Full category name as label
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // Register Technician button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the Technician Form screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechnicianFormScreen(),
                  ),
                );
              },
              child: Text('Register as Technician'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/technicianregisterform.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for caching

import 'categoryscreen.dart';
import 'microservices.dart';

class KonktServicesScreen extends StatefulWidget {
  @override
  _KonktServicesScreenState createState() => _KonktServicesScreenState();
}

class _KonktServicesScreenState extends State<KonktServicesScreen> {
  List<Map<String, dynamic>> _konktServices = [];

  @override
  void initState() {
    super.initState();
    _loadCachedServices();
    _fetchKonktServices();
  }

  // Function to load cached services
  Future<void> _loadCachedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedServices = prefs.getString('konktServices');

    if (cachedServices != null) {
      setState(() {
        _konktServices = List<Map<String, dynamic>>.from(json.decode(cachedServices));
      });
    }
  }

  // Fetch services from server and update cache
  Future<void> _fetchKonktServices() async {
    try {
      final response = await http.get(
       // Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktservices'),//working perfect
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktserviceswithdetails'),//updated to add filter
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedServices =
        List<Map<String, dynamic>>.from(json.decode(response.body));

        // Compare new data with cached data
        if (!_isDataSame(fetchedServices, _konktServices)) {
          setState(() {
            _konktServices = fetchedServices;
          });

          // Save the new data to cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('konktServices', json.encode(fetchedServices));
        }
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  // Helper function to compare fetched data with cached data
  bool _isDataSame(List<Map<String, dynamic>> newData, List<Map<String, dynamic>> cachedData) {
    return json.encode(newData) == json.encode(cachedData);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _konktServices.map((service) => service['Category']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Services'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Text color in AppBar
      ),
      body: Column(
        children: [
          // Grid view of categories (4 items per row)
          Container(
            height: 300, // Adjusted height to allow more space for rows
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of icons per row
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 50, // Increased space between rows
                childAspectRatio: 1.2, // Adjust the size of each item
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                           //commented
                        CategoryScreen(category: category, services: _konktServices),
                          //CategoryScreen(category: category)
                      ),
                    );
                  child: Container(
                    color: Colors.white, // Optional: Set a background color for the container
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30, // Adjust the size as needed
                          child: Text(
                            category[0].toUpperCase(), // Display only the first letter of the category
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 8), // Space between the CircleAvatar and label
                        Text(
                          category, // Full category name as label
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // Register Technician button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the Technician Form screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechnicianFormScreen(),
                  ),
                );
              },
              child: Text('Register as Technician'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
just because of cache latest technicians not updating*/
/* working but after uninstall and install
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/technicianregisterform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'categoryscreen.dart';

class KonktServicesScreen extends StatefulWidget {
  @override
  _KonktServicesScreenState createState() => _KonktServicesScreenState();
}

class _KonktServicesScreenState extends State<KonktServicesScreen> {
  List<Map<String, dynamic>> _konktServices = [];
  bool _isLoading = true; // Loading indicator state

  @override
  void initState() {
    super.initState();
    _fetchKonktServices(); // Always fetch the latest data
  }

  // Fetch services from server and update cache
  Future<void> _fetchKonktServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktserviceswithdetails'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedServices =
        List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          _konktServices = fetchedServices;
          _isLoading = false;
        });

        // Update the cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('konktServices', json.encode(fetchedServices));
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _konktServices.map((service) => service['Category']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Services'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Column(
        children: [
          // Grid view of categories
          Container(
            height: 300,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of icons per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 50,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryScreen(category: category, services: _konktServices),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: Text(
                            category[0].toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // Register Technician button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechnicianFormScreen(),
                  ),
                );
              },
              child: Text('Register as Technician'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*some times not working
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/technicianregisterform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'categoryscreen.dart';

class KonktServicesScreen extends StatefulWidget {
  @override
  _KonktServicesScreenState createState() => _KonktServicesScreenState();
}

class _KonktServicesScreenState extends State<KonktServicesScreen> {
  List<Map<String, dynamic>> _konktServices = [];
  bool _isLoading = true; // For loading indicator

  @override
  void initState() {
    super.initState();
    _clearCacheAndFetchServices(); // Always clear cache and fetch latest data
  }

  /// Clear cached services and fetch the latest services
  Future<void> _clearCacheAndFetchServices() async {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear cached data
      await prefs.remove('konktServices');

      // Fetch latest data
      final response = await http.get(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktserviceswithdetails'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedServices =
        List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          _konktServices = fetchedServices;
          _isLoading = false;
        });

        // Save new data to cache
        await prefs.setString('konktServices', json.encode(fetchedServices));
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading indicator on error
      });
      print('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _konktServices.map((service) => service['Category']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Services'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show spinner while loading
          : Column(
        children: [
          // Grid view of categories
          Container(
            height: 300,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of icons per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 50,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryScreen(category: category, services: _konktServices),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: Text(
                            category[0].toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // Register Technician button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechnicianFormScreen(),
                  ),
                );
              },
              child: Text('Register as Technician'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'dart:convert';
import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/technicianregisterform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'categoryscreen.dart';

class KonktServicesScreen extends StatefulWidget {
  @override
  _KonktServicesScreenState createState() => _KonktServicesScreenState();
}

class _KonktServicesScreenState extends State<KonktServicesScreen> {
  List<Map<String, dynamic>> _konktServices = [];
  bool _isLoading = true; // For loading indicator
  Timer? _timer; // To manage the periodic refresh

  @override
  void initState() {
    super.initState();
    _clearCacheAndFetchServices(); // Fetch data on startup
    _startAutoRefresh(); // Start the background refresh every minute
  }
  void _showErrorDialog( String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Clear cached services and fetch the latest services
  Future<void> _clearCacheAndFetchServices() async {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching
    });
    final _secureStorage = const FlutterSecureStorage();
    // Initialize secure storage and shared preferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check for stored token and username

    String? token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      // Handle missing token (e.g., show a dialog or redirect to login)
      _showErrorDialog( 'Authentication error. Please log in again.');
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear cached data
      await prefs.remove('konktServices');

      // Fetch latest data
      final response = await http.get(
       // Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktserviceswithdetails'),
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/listkonktserviceswithdetailsprotected'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedServices =
        List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          _konktServices = fetchedServices;
          _isLoading = false;
        });

        // Save new data to cache
        await prefs.setString('konktServices', json.encode(fetchedServices));
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading indicator on error
      });
      print('Error fetching services: $e');
    }
  }

  // Start auto-refresh every minute
  void _startAutoRefresh() {
    // Print debug message to ensure the timer is being triggered
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      print("Timer triggered - Fetching latest data...");
      _clearCacheAndFetchServices();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _konktServices.map((service) => service['Category']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Services'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show spinner while loading
          : Column(
        children: [
          // Grid view of categories
          Container(
            height: 600,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of icons per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 50,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                // Construct the image path dynamically based on the category name
                String imagePath = 'assets/images/$category.png';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryScreen(category: category, services: _konktServices),
                      ),
                    );
                  }, //commenting for image
                  /*child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: Text(
                            category[0].toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),*/
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Use the Image.asset to load the category image or fallback image
                        ClipOval(
                          child: Image.asset(
                            imagePath,
                            width: 60, // Set width of the image
                            height: 60, // Set height of the image
                            fit: BoxFit.cover, // To ensure the image covers the entire circle
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              // If image not found, fallback to default image
                              return Image.asset(
                                'assets/images/default.png', // Default image asset
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30),
          // Register Technician button
          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechnicianFormScreen(),
                  ),
                );
              },
              child: Text('Register Your Service'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              ),
            ), */
          Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechnicianFormScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside the button
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Optional: Adjust button shape
                ),
              ),
              child: const Text(
                'Register Your Service',
                style: TextStyle(
                  color: Colors.black, // Move color definition to the text widget
                ),
              ),
            ),



          ),
        ],
      ),
    );
  }
}
