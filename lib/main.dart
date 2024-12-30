import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konktapp/pages/userlistscreenmessages.dart';
import 'package:konktapp/providers/UserProvider.dart';

import 'package:konktapp/providers/post_provider.dart';
import 'package:konktapp/providers/posts_provider.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'helper/style.dart';
import 'pages/postpage.dart';
import 'providers/friend_provider.dart'; // Import your provider
import 'providers/auth_provider.dart'; // Import AuthProvider
import 'pages/friendscreenlist.dart'; // Import your screen
import 'pages/login.dart';
import 'pages/tabs.dart';
import 'pages/home.dart';
import 'pages/job_screen.dart';
/*
void main() async {
  // Ensure all widgets have binding initialized before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the system overlay styles for status bar and navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // Navigation bar color
      statusBarColor: Colors.black, // Status bar color
    ),
  );

  // Run the app
  runApp(const MyApp());//commented for logout
  /*runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child:const MyApp(),
    ),
  );*/

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FriendProvider()), // FriendProvider
        ChangeNotifierProvider(create: (_) => AuthProvider()), // AuthProvider
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        //ChangeNotifierProvider(create: (_) => PostsProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'Konkt',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: appColor,
              fontFamily: 'regular',
            ),
            // Conditional routing based on login status
            //home: authProvider.isLoggedIn ? PostScreen() : login(),
            home: PostScreen(loggedInPerson: '',),
            routes: {
              login.page_id: (context) => login(),
              tabs.page_id: (context) => tabs(),
              home.page_id: (context) => home(),
              PostScreen.page_id: (context) =>  PostScreen(loggedInPerson: '',),
              FriendsScreen.page_id: (context) => FriendsScreen(name: 'rajkian', lat: '17.3730', lng: '78.5476'),

            },
          );
        },
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../testingsession.dart';
//import 'login.dart'; // Import your login screen
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
       //HomeScreen.page_id: (context) => HomeScreen(name:'rajkiran',),
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
