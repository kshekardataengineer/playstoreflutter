import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../testingsession.dart';
import 'login.dart'; // Import your login screen
//import 'home.dart';  // Import your home screen
/* working but fresh install gives homescreen
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if a user is logged in
  String? loggedInUser = await getLoggedInUser();

  runApp(MyApp(initialRoute: loggedInUser == null ? login.page_id : HomeScreen.page_id));
}*/

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KonktApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        login.page_id: (context) => login(),
        HomeScreen.page_id: (context) => HomeScreen(name:'',),
      },
    );
  }
}

// Utility functions to handle login status

// Store login status after successful login
Future<void> storeLoginStatus(String phoneNumber) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('loggedInUser', phoneNumber);
}

// Check login status
Future<String?> getLoggedInUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('loggedInUser');
}

// Clear login status on logout
Future<void> clearLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('loggedInUser');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Clear all data temporarily for testing
  // Uncomment the following line if you want to ensure a fresh state:
  // await clearAllData();

  // Check login status
  String? loggedInUser = await getLoggedInUser();
  String initialRoute = loggedInUser == null ? login.page_id : HomeScreen.page_id;

  print('Initial route: $initialRoute'); // Debug log
  runApp(MyApp(initialRoute: initialRoute));
}

Future<void> clearAllData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print('All SharedPreferences data cleared');
}
