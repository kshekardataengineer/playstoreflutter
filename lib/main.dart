import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konktapp/pages/userlistscreenmessages.dart';
import 'package:konktapp/providers/UserProvider.dart';

import 'package:konktapp/providers/post_provider.dart';
import 'package:konktapp/providers/posts_provider.dart';
import 'package:konktapp/testingsession.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'helper/style.dart';
import 'pages/postpage.dart';
import 'providers/friend_provider.dart'; // Import your provider
import 'providers/auth_provider.dart'; // Import AuthProvider
import 'pages/friendscreenlist.dart'; // Import your screen
import 'pages/login.dart';
import 'pages/tabs.dart';
//import 'pages/home.dart';
//import 'pages/job_screen.dart';
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
  runApp(const MyApp(initialRoute: '',));//commented for logout
  /*runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child:const MyApp(),
    ),
  );*/

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required String initialRoute}) : super(key: key);

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
            home: PostScreen(loggedInPerson: 'rajkiran',),
            routes: {
              login.page_id: (context) => login(),
              tabs.page_id: (context) => tabs(),
              home.page_id: (context) => home(),
              PostScreen.page_id: (context) =>  PostScreen(loggedInPerson: 'rajkiran',),
              FriendsScreen.page_id: (context) => FriendsScreen(name: 'rajkiran', lat: '17.3730', lng: '78.5476'),

            },
          );
        },
      ),
    );
  }
}*/

/*
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


/* working code */
/*commenting      for shravan Anna*/
class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return



      MaterialApp(
      title: 'KonktApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      home:HomeScreen(name:'',),
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
*/

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the secure storage
  const secureStorage = FlutterSecureStorage();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check for stored token and username
  String? token = await secureStorage.read(key: 'jwt_token');
  String? name = prefs.getString('loggedInPerson');

  runApp(MyApp(token: token, name: name, initialRoute: '',));
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? name;

  MyApp({required this.token, required this.name, required String initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token != null && name != null
          ? HomeScreen(name: name!) // Directly navigate to HomeScreen
          : login(), // Navigate to Login if no session exists
    );
  }
}

working but next time opening login screen */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure storage and shared preferences
  const secureStorage = FlutterSecureStorage();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check for stored token and username
  String? token = await secureStorage.read(key: 'jwt_token');
  String? name = prefs.getString('loggedInPerson');

  // Debugging output (remove in production)
  print('Token: $token, Name: $name');

  runApp(MyApp(
    token: token,
    name: name, initialRoute: '',
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? name;

  MyApp({required this.token, required this.name, required String initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token != null && name != null
          ? HomeScreen(name: name!) // Navigate to HomeScreen if session exists
          : login(), // Navigate to Login if no session exists
    );
  }
}

