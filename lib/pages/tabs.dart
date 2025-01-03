/*
  Authors : flutter_ninja (Flutter Ninja)
  Website : https://codecanyon.net/user/flutter_ninja/
  App Name : Grocery Template
  This App Template Source code is licensed as per the
  terms found in the Website https://codecanyon.net/licenses/standard/
  Copyright and Good Faith Purchasers © 2022-present flutter_ninja.
*/
import 'package:flutter/material.dart';
//import 'package:konktapp/pages/activity.dart';
//import 'package:konktapp/pages/home.dart';
import 'package:konktapp/pages/postpage.dart';
//import 'package:konktapp/pages/profile.dart';
//import 'package:konktapp/pages/reels.dart';
//import 'package:konktapp/pages/search.dart';

import '../pages/friendscreenlist.dart';
import 'package:konktapp/pages/friendscreenlist.dart';
import '../pages/friendsonmap.dart';
//import 'package:konktapp/pages/job_screen.dart';
//import 'package:konktapp/pages/ServiceScreen.dart';

class tabs extends StatefulWidget {
  tabs({Key? key}) : super(key: key);

  static const String page_id = "Tabs";

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<tabs> {
  int _currentIndex = 0;

  // List to hold the cached content of each tab
  final List<Widget> _pages = [
    PostScreen(loggedInPerson: "rajkiran"??""),
    FriendsScreen(name: 'rajkian', lat: '17.3730', lng: '78.5476'),
    //reels(),
    //MapScreen(),

    MapScreen( name:'rajkiran',lat: '17.3730',lng:'78.5476'),
   // profile(),


  ];

  // To handle lazy loading of tabs and caching
  final List<Widget?> _cachedPages = List<Widget?>.filled(5, null);

  @override
  void initState() {
    super.initState();
    // Load the initial tab (Home) into cache
    _cachedPages[0] = _pages[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Cache the tab content if not already cached
            if (_cachedPages[index] == null) {
              _cachedPages[index] = _pages[index];
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _cachedPages.map((page) {
          // Return the cached page if available, otherwise an empty container
          return page ?? Container();
        }).toList(),
      ),
    );
  }
}
