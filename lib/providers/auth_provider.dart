import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

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

  // Constructor to load the login status on provider initialization
  AuthProvider() {
    _loadLoginStatus();
  }

  // Method to load login status from SharedPreferences
  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners(); // Notify listeners about the change in login status
  }

  // Method to log in the user and update SharedPreferences
  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = true;
    await prefs.setBool('isLoggedIn', true); // Save login status in SharedPreferences
    notifyListeners(); // Notify listeners about the change in login status
  }

  // Method to log out the user and update SharedPreferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    await prefs.setBool('isLoggedIn', false); // Save logout status in SharedPreferences
    notifyListeners(); // Notify listeners about the change in login status
  }
}
