import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:konktapp/pages/ProfileScreen.dart';
import 'package:konktapp/pages/appsosnotifications.dart';
import 'package:konktapp/pages/friendscreenlist.dart';
import 'package:konktapp/pages/friendsonmap.dart';
import 'package:konktapp/pages/login.dart';
import 'package:konktapp/pages/microservices.dart';
//import 'package:konktapp/pages/postpage.dart';
import 'package:konktapp/pages/readcontacts.dart';
import 'package:konktapp/pages/sosonoff.dart';
import 'package:konktapp/pages/userlistscreenmessages.dart';
import 'package:konktapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:konktapp/pages/loadposts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to the appropriate screen based on login status
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(name: '',)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('name', username);
      prefs.setDouble('lat', 0.0); // Default lat
      prefs.setDouble('lng', 0.0); // Default lng

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(name: '',)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Enter Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
/* working code
class HomeScreen extends StatefulWidget {
  HomeScreen(String? name);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? currentPosition;
  bool isLoading = true;

  get name => null;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied.');
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Fetch current position
    try {
      currentPosition = await Geolocator.getCurrentPosition();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Failed to get location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: currentPosition == null
            ? Text('No location data available.')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Current Location:'),
            SizedBox(height: 10),
            Text('name: ${name}'),
           
            Text('Latitude: ${currentPosition!.latitude}'),
            Text('Longitude: ${currentPosition!.longitude}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('Refresh Location'),
            ),
          ],
        ),
      ),
    );
  }
}

 */
/* working could retrieve name from login and lat long as well

class HomeScreen extends StatefulWidget {
  final String name;

  // Accept the name as a parameter
  HomeScreen({required this.name});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied.');
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Fetch current position
    try {
      currentPosition = await Geolocator.getCurrentPosition();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Failed to get location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: currentPosition == null
            ? Text('No location data available.')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, ${widget.name}'),
            SizedBox(height: 10),
            Text('Your Current Location:'),
            SizedBox(height: 10),
            Text('Latitude: ${currentPosition!.latitude}'),
            Text('Longitude: ${currentPosition!.longitude}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('Refresh Location'),
            ),
          ],
        ),
      ),
    );
  }
}
*/



/*
class HomeScreen extends StatefulWidget {
  final String name;

  // Accept the name as a parameter
  HomeScreen({required this.name});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? currentPosition;
  bool isLoading = true;
  int _selectedIndex = 0; // To track the selected tab

  List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home Screen Content')),
    Center(child: Text('Search Screen')),
    Center(child: Text('Add Post Screen')),
    Center(child: Text('Near By Screen')),
    Center(child: Text('Profile Screen')),


    PostsScreen(),
    //PostsScreen(),
    FriendsScreen(),
    //reels(),
    //post(),
    ReadContacts(),
    MapScreen(),
    //ProfileScreen(friendName: 'rajkiran',),
    ProfileScreen(friendName: '',),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied.');
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Fetch current position
    try {
      currentPosition = await Geolocator.getCurrentPosition();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Failed to get location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear session data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Handle BottomNavigationBar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to show Add Post Dialog (as an example)
  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create a New Post'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter your post here'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add logic to save the post here
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Image.asset(
              'assets/images/konkt_jpeg_logo.jpeg', // Path to your logo image
              width: 140, // Set the width you want
              height: 160, // Set the height you want
            ),
        /*    Text(
              'Konkt',
              style: TextStyle(fontFamily: 'bold', fontSize: 24, color: Colors.black),
            ),*/
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to message screen
                },
                icon: Icon(Icons.message_outlined),
              ),
              IconButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(1000, 80, 0, 0),
                    items: [
                      PopupMenuItem(
                        child: Text('App Notifications'),
                        value: 'app_notifications',
                      ),
                      PopupMenuItem(
                        child: Text('SOS Notifications'),
                        value: 'sos_notifications',
                      ),
                    ],
                  ).then((value) {
                    if (value == 'app_notifications') {
                      // Navigate to App Notifications screen
                    } else if (value == 'sos_notifications') {
                      // Navigate to SOS Notifications screen
                    }
                  });
                },
                icon: Icon(Icons.notifications),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to SOS screen
                },
                icon: Icon(Icons.sos_rounded),
              ),
              PopupMenuButton(
                padding: EdgeInsets.all(0),
                onSelected: (value) async {
                  if (value == 5) {
                    // Logout logic
                    await _logout();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded),
                        SizedBox(width: 10),
                        Text('Logout', style: TextStyle(color: Colors.black, fontSize: 17)),
                      ],
                    ),
                    value: 5,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? (isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello, ${widget.name}'),
          SizedBox(height: 10),
          Text('Your Current Location:'),
          SizedBox(height: 10),
          Text('Latitude: ${currentPosition?.latitude ?? 'N/A'}'),
          Text('Longitude: ${currentPosition?.longitude ?? 'N/A'}'),
        ],
      ))
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Near By',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog, // Show the add post dialog
        child: Icon(Icons.add),
      ),
    );
  }
}
working code perfectly*/

//adding code to get app functionality bottom navigation

class HomeScreen extends StatefulWidget {
  final String name;



  static const String page_id = "home";





  // Accept the name as a parameter
  HomeScreen({required this.name});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
/*updating to passname received
class _HomeScreenState extends State<HomeScreen> {
  Position? currentPosition;
  bool isLoading = true;
  int _selectedIndex = 0; // To track the selected tab

  List<Widget> _widgetOptions = <Widget>[
    /*Center(child: Text('Home Screen Content')),
    Center(child: Text('Search Screen')),
    Center(child: Text('Add Post Screen')),
    Center(child: Text('Near By Screen')),
    Center(child: Text('Profile Screen')),*/

    PostsScreen(),
    //PostsScreen(),
    FriendsScreen(),
    //reels(),
    //post(),
    ReadContacts(),
    MapScreen(),
    //ProfileScreen(friendName: 'rajkiran',),
    ProfileScreen(friendName: 'rajkiran',),

  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied.');
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Fetch current position
    try {
      currentPosition = await Geolocator.getCurrentPosition();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Failed to get location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear session data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Handle BottomNavigationBar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to show Add Post Dialog (as an example)
  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create a New Post'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter your post here'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add logic to save the post here
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Image.asset(
              'assets/images/konkt_jpeg_logo.jpeg', // Path to your logo image
              width: 140, // Set the width you want
              height: 160, // Set the height you want
            ),
            Text(
              'Konkt',
              style: TextStyle(fontFamily: 'bold', fontSize: 24, color: Colors.black),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to ProfileScreen, passing the name from HomeScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(friendName: widget.name),
                    ),
                  );
                },
                icon: Icon(Icons.person),
              ),
              PopupMenuButton(
                padding: EdgeInsets.all(0),
                onSelected: (value) async {
                  if (value == 5) {
                    // Logout logic
                    await _logout();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded),
                        SizedBox(width: 10),
                        Text('Logout', style: TextStyle(color: Colors.black, fontSize: 17)),
                      ],
                    ),
                    value: 5,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? (isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello, ${widget.name}'),
          SizedBox(height: 10),
          Text('Your Current Location:'),
          SizedBox(height: 10),
          Text('Latitude: ${currentPosition?.latitude ?? 'N/A'}'),
          Text('Longitude: ${currentPosition?.longitude ?? 'N/A'}'),
        ],
      ))
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Near By',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog, // Show the add post dialog
        child: Icon(Icons.add),
      ),
    );
  }
} */

/*class ProfileScreen extends StatelessWidget {
  final String friendName;

  // Accept friendName as a parameter
  ProfileScreen({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$friendName\'s Profile'),
      ),
      body: Center(
        child: Text('Welcome to $friendName\'s profile'),
      ),
    );
  }
}*/
class _HomeScreenState extends State<HomeScreen> {
  Position? currentPosition;
  bool isLoading = true;
  int _selectedIndex = 0;

  // Initialize an empty list here
  late List<Widget> _widgetOptions;

  //Text('Latitude: ${currentPosition!.latitude}'),
  //Text('Longitude: ${currentPosition!.longitude}'),


//added experiment code

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((_) {
      Position position = currentPosition!;
      setState(() {
        _widgetOptions = [
          PostsScreen(name: widget.name),
          FriendsScreen(name: widget.name, lat: position.latitude.toString(), lng: position.longitude.toString()),
          ReadContacts(),
          MapScreen(name: widget.name, lat: position.latitude.toString(), lng: position.longitude.toString()),
          ProfileScreen(friendName: widget.name),
        ];
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied');
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied, we cannot request permissions.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
      isLoading = false;
    });
  }
//working code
  /*
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Initialize the list in initState or build method, after widget.name is available
    _widgetOptions = <Widget>[
      PostsScreen(name: widget.name),
      FriendsScreen(name: widget.name, lat: '17.3730', lng: '78.5476'),
      ReadContacts(),
      // MapScreen( lat:'${currentPosition!.latitude}',lng:'${currentPosition!.longitude}'),
      //MapScreen( lat: '17.3730',lng:'78.5476'),
      MapScreen(name: widget.name, lat: '17.3730', lng: '78.5476'),
      ProfileScreen(friendName: widget.name),
      // Pass widget.name here
    ];
  }
*/



  Widget _buildPostScreen() {
    return RefreshIndicator(
      onRefresh: _fetchNewPosts, // Refresh posts on pull-to-refresh
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Container for KonktServicesScreen
            Container(//changed height 120 to 90
              height: 90 , // Set an appropriate height for the services section
              child: MicroServicesScreen(), // Your services screen
            ),

            Container(
              height: MediaQuery.of(context).size.height - 200, // Take remaining height
              child: PostsScreen(name: widget.name,), // This now integrates your PostsScreen widget
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Image.asset(
              'assets/images/konkt_jpeg_logo.jpeg',
              width: 140,
              height: 160,
            ),
            /* Text(
              'Konkt',
              style: TextStyle(fontFamily: 'bold', fontSize: 24, color: Colors.black),
            ),*/
          ],
        ),


        actions: [
          Row(
            children: [

              IconButton(

                onPressed: () {
                  Navigator.push(context,
                      //MaterialPageRoute(builder: (context) => messageScreen()));
                      //MaterialPageRoute(builder: (context) => SenderListScreen()));
                      MaterialPageRoute(builder: (context) =>
                          UserListScreen(loggedinPerson: widget.name)));
                },
                icon: Icon(Icons.message_outlined),
              ),

              IconButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(1000, 80, 0, 0),
                    items: [
                      PopupMenuItem(
                        child: Text('App Notifications'),
                        value: 'app_notifications',
                      ),
                      PopupMenuItem(
                        child: Text('SOS Notifications'),
                        value: 'sos_notifications',
                      ),
                    ],
                  ).then((value) {
                    if (value == 'app_notifications') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            NotificationsScreen(notificationType: 'app')),
                      );
                    } else if (value == 'sos_notifications') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            NotificationsScreen(notificationType: 'sos')),
                      );
                    }
                  });
                },
                icon: Icon(Icons.notifications),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      //MaterialPageRoute(builder: (context) => messageScreen()));
                      MaterialPageRoute(builder: (context) => SOSApp()));
                },
                icon: Icon(Icons.sos_rounded),
              ),
              /* commenting as in home screen its working
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      //MaterialPageRoute(builder: (context) => messageScreen()));
                      //MaterialPageRoute(builder: (context) => PostsScreen()));
                      MaterialPageRoute(builder: (context) => PostsScreen()));
                  // MaterialPageRoute(builder: (context) => PostsScreen1()));
                },
                icon: Icon(Icons.image),
              ),*/
              /*IconButton(
                onPressed: () {
                  Navigator.push(context,

                      MaterialPageRoute(builder: (context) => ReadContacts()));
                },
                icon: Icon(Icons.contact_phone),
              ),*/
              PopupMenuButton(
                padding: EdgeInsets.all(0),
                onSelected: (value) async {
                  if (value == 5) {
                    final authProvider = Provider.of<AuthProvider>(
                        context, listen: false);
                    await authProvider.logout();
                    Navigator.of(context).pushReplacementNamed(login.page_id);
                  }
                },
                itemBuilder: (context) =>
                [

                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded),
                        SizedBox(width: 10),
                        Text('Logout', style: TextStyle(color: Colors.black,
                            fontSize: 17)),
                      ],
                    ),
                    value: 5,
                  ),
                ],
              ),
            ],
          ),
        ],


      ),
      body: _selectedIndex == 0 ? _buildPostScreen() : _widgetOptions.elementAt(_selectedIndex),

     // _widgetOptions[_selectedIndex], // Use the updated list here
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Near By',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear session data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
/*
  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied.');
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Fetch current position
    try {
      currentPosition = await Geolocator.getCurrentPosition();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Failed to get location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


working code commented */

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }
  /* void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create a New Post'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter your post here'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add logic to save the post here
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }*/


  File? _imageFile;
  bool _isLoading = false; // Track loading state
  String _postContent = ""; // Store post content

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showAddPostDialog() {
    // Reset the image before showing the dialog to ensure it starts fresh
    _imageFile = null;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add a New Post"),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 400), // Set a max height
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: "What's on your mind?",
                        ),
                        maxLines: null, // Allow for multiple lines if needed
                        onChanged: (value) {
                          setState(() {
                            _postContent =
                                value; // Update content as user types
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      if (_imageFile !=
                          null) // Show selected image if available
                        Column(
                          children: [
                            Image.file(_imageFile!, height: 200),
                            SizedBox(height: 10),
                            /* Text(
                              'Selected: ${_imageFile!.path.split('/').last}', // Display filename
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),*/
                          ],
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await _pickImage(); // Pick an image
                          if (_imageFile != null) {
                            setState(() {}); // Refresh dialog to show updated button text
                          }
                        },
                        child: Text(_imageFile != null
                            ? "Image Selected"
                            : "Select Image"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                _imageFile = null; // Clear image selection on cancel
              },
            ),
            TextButton(
              child: Text("Post"),
              onPressed: () {
                if (_postContent.isNotEmpty && _imageFile != null) {
                  Navigator.of(context).pop(); // Close the dialog
                  _postNewContent(_postContent); // Call your posting function
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Please enter content and select an image.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

 /* Widget _buildPostScreen() {
    return RefreshIndicator(
     // onRefresh: _fetchNewPosts, // Refresh posts on pull-to-refresh
      onRefresh:  _getCurrentLocation(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Container for KonktServicesScreen
            Container( //changed height 120 to 90
              height: 90, // Set an appropriate height for the services section
              child: MicroServicesScreen(), // Your services screen
            ),

            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 200, // Take remaining height
              child: PostsScreen(name: widget
                  .name,), // This now integrates your PostsScreen widget
            ),

          ],
        ),
      ),
    );
  }
*/

  Future<void> _postNewContent(String content) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createpost'),
    );

    request.fields['content'] = content; // Content of the post
    request.fields['name'] = widget.name; // Logged-in username

    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'file', _imageFile!.path), // 'file' is the field name for the image
      );
    }

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await request.send();

      // Close loading state
      setState(() {
        _isLoading = false; // Reset loading state
      });

      if (response.statusCode == 200) {
        // Post was successful
        //_fetchPosts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post successfully added!'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset the image file and post content after successful post
        setState(() {
          _imageFile = null; // Clear the selected image
          _postContent = ""; // Clear the post content
        });
        //_buildPostScreen();
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add post: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading state
      setState(() {
        _isLoading = false; // Reset loading state
      });
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchNewPosts() async {
  }
}
