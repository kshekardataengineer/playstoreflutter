import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../jobmodel.dart';
//import '../jobsmaintest.dart';
import '../model/job.dart';
//import 'jobssupport.dart'; // Import your Job model
//import 'selected.dart';
void main() {
  runApp(MaterialApp(
    home: ServiceScreen(),
  ));
}

class ServiceScreen extends StatefulWidget {
  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<ServiceScreen> {
  int _selectedMenuIndex = 0; // Default to "Jobs" tab

  final List<String> menuTitles = [
    "SERVICES",
    "Selected",
    "Offer",
    "Create SERVICE"
  ];

  final List<Widget> menuContents = [
    Center(child: Text("service Content Placeholder")),
    Center(child: Text("service selected Content Placeholder")),

    Center(child: Text("service offer Content Placeholder")),
    Center(child: Text("create service Content Placeholder")),
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
        title: Text('SERVICE TITTLE'),
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






