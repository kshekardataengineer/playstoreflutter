import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:konktapp/pages/login.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
//import 'token_storage.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final _storage = FlutterSecureStorage();

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }
}





class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void clearToken() {
    _token = null;
    notifyListeners();
  }
}


/*Future<void> onLoginSuccess(BuildContext context, String token) async {
  // Save token securely
  await TokenStorage.saveToken(token);

  // Update provider
  Provider.of<AuthProvider>(context, listen: false).setToken(token);
}*/
Future<void> onLoginSuccess(BuildContext context, String token, String username) async {
  // Save token securely
  await TokenStorage.saveToken(token);

  // Store username in shared preferences (optional)
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('loggedInUserName', username);

  // Update your authentication provider with the token
  Provider.of<AuthProvider>(context, listen: false).setToken(token);
}


Future<void> sendProtectedRequest(String url) async {
  String? token = await TokenStorage.getToken();

  if (token != null) {
    final response = await http.post(
      // Uri.parse('https://example.com/protected'),
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: '{"data": "This is a test"}',
    );

    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
    } else {
      print('Request failed: ${response.statusCode}');
    }
  } else {
    print('No token found');
  }
}
Future<void> sendProtectedRequestGet(String url) async {
  String? token = await TokenStorage.getToken();

  if (token != null) {
    final response = await http.get(
     // Uri.parse('https://example.com/protected'),
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      //body: '{"data": "This is a test"}',
    );

    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
    } else {
      print('Request failed: ${response.statusCode}');
    }
  } else {
    print('No token found');
  }
}

class ProtectedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? token = Provider.of<AuthProvider>(context).token;

    return Scaffold(
      appBar: AppBar(title: Text('Protected Screen')),
      body: Center(
        child: token != null
            ? Text('Token: $token')
            : Text('No token found. Please log in.'),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await TokenStorage.deleteToken(); // Clear token from storage
  Provider.of<AuthProvider>(context, listen: false).clearToken(); // Clear provider
}


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.token == null ? login() : ProtectedScreen();
        },
      ),
    );
  }
}
