import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _userName = 'Guest'; // Default value
  bool _isLoggedIn = false;   // Track if user is logged in

  // Getter for user name
  String get userName => _userName;

  // Getter for login status
  bool get isLoggedIn => _isLoggedIn;

  // Method to set user name and login status
  void setUserName(String name) {
    _userName = name;
    _loggedInPerson=name;
    // _loggedInPerson = name;
    setLoggedInPerson(name);
    _isLoggedIn = true;  // Mark as logged in
    notifyListeners(); // Notify listeners to rebuild UI
  }
  String _loggedInPerson = '';

  String get loggedInPerson => _loggedInPerson;

  void setLoggedInPerson(String person) {
    _loggedInPerson = person;
    _isLoggedIn = true;
    notifyListeners();
  }
  // Method to log out by removing user data from SharedPreferences
  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInPerson'); // Remove user name from SharedPreferences
    _userName = 'Guest';  // Reset to default value
    _loggedInPerson = 'Guest';
    _isLoggedIn = false;  // Mark as logged out
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to load user from SharedPreferences
  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('loggedInPerson') ?? 'Guest'; // Default to 'Guest' if not found
    _loggedInPerson = prefs.getString('loggedInPerson') ?? 'Guest'; // Default to 'Guest' if not found
    _isLoggedIn = _userName != 'Guest'; // If user is not 'Guest', assume logged in
    _isLoggedIn = _loggedInPerson != 'Guest';
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to save user name to SharedPreferences
  Future<void> saveUser(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInPerson', name);
    _userName = name;
    _loggedInPerson = name;
    _isLoggedIn = true;
    notifyListeners(); // Notify listeners to rebuild UI
  }
}
