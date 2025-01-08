/*
  Authors : flutter_ninja (Flutter Ninja)
  Website : https://codecanyon.net/user/flutter_ninja/
  App Name : Grocery Template
  This App Template Source code is licensed as per the
  terms found in the Website https://codecanyon.net/licenses/standard/
  Copyright and Good Faith Purchasers © 2022-present flutter_ninja.
*/
/*
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:konktapp/helper/style.dart';
import 'package:konktapp/pages/signup.dart';
import 'package:konktapp/pages/tabs.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  static const String page_id = "Login";

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: 'regular'),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Sign up.',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: 'regular'),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => signup()));
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'English (United States)',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Konkt',
                style: TextStyle(fontFamily: 'bold', fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(),
                    //hintText: 'Phone number, email or username'),
                    hintText: 'Phone number'),
              ),
              SizedBox(
                height: 20,
              ),
              /*TextField(
                obscureText: false,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility_off_outlined),
                    hintText: 'Password'),
              ),*/
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => tabs()));
                },
                child: Text(
                  'Log in',
                  style: TextStyle(fontFamily: 'medium', fontSize: 18),
                ),
                style: appButton(),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: 'Forgot your login details? ',
                  style: TextStyle(
                      color: Colors.black, fontSize: 14, fontFamily: 'regular'),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Get help logging in.',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontFamily: 'regular'),
                      // recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/insta.png',
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Log in with Facebook',
                    style: TextStyle(
                        color: appColor, fontSize: 16, fontFamily: 'medium'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/postpage.dart';
import 'package:konktapp/pages/signup.dart';
import 'package:konktapp/pages/tokenstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:konktapp/helper/style.dart';
import 'package:konktapp/pages/tabs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../newproject.dart';
import '../providers/UserProvider.dart';
import '../testingsession.dart';
/*
// Login screen with OTP functionality
class login extends StatefulWidget {
  static const String page_id = "login";
  login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  Future<void> onLoginSuccess(BuildContext context, String token) async {
    // Save token securely
    await TokenStorage.saveToken(token);

    // Update provider
    Provider.of<AuthProvider>(context, listen: false).setToken(token);
  }


  // Request OTP
  Future<void> requestOtp(String phoneNumber) async {
    //flask url
    //final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/request_otp');
    //nodejsurl
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/request_otp');


    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'OTP sent successfully') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(phoneNumber: phoneNumber),
          ),
        );
      } else {
        showError('Failed to send OTP');
      }
    } else {
      showError('Failed to send OTP');
    }
  }

  void showError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: 'regular'),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Sign up.',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: 'regular'),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      }

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'English (United States)',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/konkt_jpeg_logo.jpeg', // Path to your logo image
                width: 150, // Set the width you want
                height: 150, // Set the height you want
              ),
              SizedBox(height: 20), // Add some space below the logo
              Text(
                'Welcome to Konkt',
                style: TextStyle(fontFamily: 'bold', fontSize: 24),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(),
                        hintText: 'Phone number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !RegExp(r'^\+\d{12}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          requestOtp(phoneController.text);
                        }
                      },
                      child: Text(
                        'Request OTP',
                        style: TextStyle(fontFamily: 'medium', fontSize: 18),
                      ),
                      style: appButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class UserNotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Not Found"),
      ),
      body: Center(
        child: Text(
          "No account was found with this mobile number.",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


// OTP Verification Screen
class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  VerifyOtpScreen({required this.phoneNumber});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

/*
class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  bool isResendingOtp = false;

  // Verify OTP and fetch user details
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    //flask url

  //nodejs url
    final verifyUrl = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/verify_otp');

    final response = await http.post(
      verifyUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'OTP verified successfully') {
        // Fetch user name


        // Call fetchAndStoreUserName to fetch the user's name
        String? name = await fetchAndStoreUserName(phoneNumber);
        print("${name}name retrieved successfully");

        Navigator.pushReplacement(
          context,
         // MaterialPageRoute(builder: (context) => PostScreen(loggedInPerson: name??"",), // Navigate to home screen
            MaterialPageRoute(builder: (context) => HomeScreen(name: "${name}",),
             )        );
      } else {
        showError('Invalid OTP');
      }
    } else {
      //showError('Failed to verify OTP');
      showError('user not found please register');
    }
  }
working code but for access token updated*/







  class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  bool isResendingOtp = false;
  // Secure storage instance
  final _secureStorage = const FlutterSecureStorage();

  // Verify OTP and fetch user details
  Future<void> verifyOtp(String phoneNumber, String otp) async {
  final verifyUrl = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/verify_otp_protected');

  try {
  final response = await http.post(
  verifyUrl,
  headers: {'Content-Type': 'application/json'},
  body: json.encode({'phone_number': phoneNumber, 'otp': otp}),
  );

  if (response.statusCode == 200) {
  var jsonResponse = json.decode(response.body);

  if (jsonResponse['message'] == 'OTP verified successfully') {
  // Save the token securely
  String token = jsonResponse['token'];
  await _secureStorage.write(key: 'jwt_token', value: token);

  // Call fetchAndStoreUserName to fetch the user's name
  String? name = await fetchAndStoreUserName(phoneNumber);
  print("${name}name retrieved successfully");

  Navigator.pushReplacement(
      context,
      // MaterialPageRoute(builder: (context) => PostScreen(loggedInPerson: name??"",), // Navigate to home screen
      MaterialPageRoute(builder: (context) => HomeScreen(name: "${name}",),
      )        );


  } else {
  showError('Invalid OTP');
  }
  } else {
  showError('Failed to verify OTP');
  }
  } catch (error) {
  print('Error verifying OTP: $error');
  showError('An error occurred. Please try again.');
  }
  }
/*
  void showError(String error) {
  showDialog(
  context: context,
  builder: (context) => AlertDialog(
  title: Text('Error'),
  content: Text(error),
  actions: [
  TextButton(
  onPressed: () => Navigator.pop(context),
  child: Text('OK'),
  ),
  ],
  )
  );
  }*/
/* working but updated for handling when user not there
  // Fetch and store user name
  Future<void> fetchAndStoreUserName(String phoneNumber) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getname');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber}),
    );




    if (response.statusCode == 200) {
      var nameResponse = json.decode(response.body);
      if (nameResponse.isNotEmpty && nameResponse[0].containsKey('name')) {
        String name = nameResponse[0]['name'];

        // Store name in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', name);
      } else {
        showError('Failed to retrieve name');
      }
    } else {
      showError('Failed to retrieve name');
    }
  }*/

  void setUserDetails(context,String newLoggedInPerson) {
    Provider.of<UserProvider>(context, listen: false).setUserName(newLoggedInPerson);
  }



/* working code
// Fetch and store user name
  Future<void> fetchAndStoreUserName(String phoneNumber) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getname');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone_number': phoneNumber}),
      );

      if (response.statusCode == 200) {
        var nameResponse = json.decode(response.body);

        String name = nameResponse[0]['name'];
        setUserDetails(context,name);

        final data = jsonDecode(response.body); // Parse API response
        final loggedInPerson = data['name']; // Adjust based on API response
        final userName = data['name'];
        print(userName+"storing in session");
        print(loggedInPerson+"storing in session");

        // Save user details in UserProvider
        Provider.of<UserProvider>(context, listen: false).saveUser(loggedInPerson);


        if (nameResponse.isNotEmpty && nameResponse[0].containsKey('name')) {
          String? name = nameResponse[0]['name'];

          if (name == null || name.trim().isEmpty) {
            // Name is null or empty: Redirect to "User Not Found" login page
            showError('User not found. Please register.');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserNotFoundPage()),
            );
          } else {
            // Name exists: Store in SharedPreferences
            String name = nameResponse[0]['name'];
            setUserDetails(context,name);

            final data = jsonDecode(response.body); // Parse API response
            final loggedInPerson = data['name']; // Adjust based on API response
            final userName = data['name'];
            print(userName+"storing in session");
            print(loggedInPerson+"storing in session");

            // Save user details in UserProvider
            Provider.of<UserProvider>(context, listen: false).saveUser(loggedInPerson);

            // Navigate to dashboard or next screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TabsScreen()),
            );
          }
        } else {
          // Invalid response structure
          showError('Failed to retrieve name. Please try again.');
        }
      } else {
        // HTTP error
        showError('Failed to retrieve name. Server responded with ${response.statusCode}');
      }
    } catch (e) {
      // Exception handling
      showError('An error occurred: $e');
    }
  }*/

  /*Future<void> fetchAndStoreUserName(String phoneNumber) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getname');

    try {
      // Make the POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone_number': phoneNumber}),
      );

      // Check for a successful response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Validate response structure
        if (data is Map<String, dynamic> && data.containsKey('name')) {
          final String? name = data['name'];
          print("${name}name retrieved");

          if (name == null || name.trim().isEmpty) {
            // Handle case where name is empty or null
            showError('User not found. Please register.');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserNotFoundPage()),
            );
          } else {
            // Store user details
            setUserDetails(context, name);
            print('$name storing in session');

            // Save user details in UserProvider
            Provider.of<UserProvider>(context, listen: false).saveUser(name);

            // Navigate to the dashboard or next screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PostScreen()),
            );
          }
        } else {
          // Handle unexpected response structure
          showError('Unexpected response from the server. Please try again.');
        }
      } else {
        // Handle non-200 HTTP responses
        showError('Failed to retrieve name. Server responded with ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      showError('An error occurred: $e');
    }
  }
working but ot storing in session
*/


  Future<String?> fetchAndStoreUserName(String phoneNumber) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getname');

    try {
      // Make the POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone_number': phoneNumber}),
      );

      // Check for a successful response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Validate response structure
        if (data is Map<String, dynamic> && data.containsKey('name')) {
          final String? name = data['name'];
          print("$name name retrieved");

          if (name == null || name.trim().isEmpty) {
            // Handle case where name is empty or null
            return null; // User not found
          } else {
            // Store user details in SharedPreferences (session storage)
            await _storeLoggedInPerson(name);
            print('$name storing in session');
            return name; // Return the user's name
          }
        } else {
          // Handle unexpected response structure
          return null; // Invalid response
        }
      } else {
        // Handle non-200 HTTP responses
        return null; // Failed request
      }
    } catch (e) {
      // Handle any exceptions
      print('An error occurred: $e');
      return null; // Return null in case of error
    }
  }

// Function to store the loggedInPerson in SharedPreferences
  Future<void> _storeLoggedInPerson(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInPerson', name); // Store the name as loggedInPerson
  }



  Future<void> resendOtp() async {
    setState(() {
      isResendingOtp = true;
    });
    await requestOtp(widget.phoneNumber);
    setState(() {
      isResendingOtp = false;
    });
  }

  Future<void> requestOtp(String phoneNumber) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/request_otp');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber}),
    );
  }

  void showError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Phone Number: ${widget.phoneNumber}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    verifyOtp(widget.phoneNumber, otpController.text);
                  }
                },
                child: Text('Verify OTP'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: isResendingOtp ? null : resendOtp,
                child: isResendingOtp
                    ? CircularProgressIndicator()
                    : Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home screen (after successful login)
class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  // Load user name from SharedPreferences
  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
    });
  }

  // Logout and clear session
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${userName ?? 'User'}'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}

*/

import 'package:konktapp/pages/signup.dart';

class login extends StatefulWidget {
  static const String page_id = "login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();

  Future<void> onLoginSuccess(String token, String username) async {
    // Store token and username securely
    await _secureStorage.write(key: 'jwt_token', value: token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInPerson', username);

    // Navigate to HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(name: username)),
    );
  }





  Future<void> requestOtp(String phoneNumber) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/request_otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'OTP sent successfully') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(phoneNumber: phoneNumber),
          ),
        );
      } else {
        showError('Failed to send OTP');
      }
    } else {
      showError('Failed to send OTP');
    }
  }

  void showError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/konkt_jpeg_logo.jpeg', // Path to your logo image
                width: 150, // Set the width you want
                height: 150, // Set the height you want
              ),
              SizedBox(height: 20), // Add some space below the logo
              Text(
                'Welcome to Konkt',
                style: TextStyle(fontFamily: 'bold', fontSize: 24),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    requestOtp(phoneController.text);
                  }
                },
                child: Text('Request OTP'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: 'regular'),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Sign up.',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: 'regular'),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignupPage()));
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

















class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  VerifyOtpScreen({required this.phoneNumber});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();





  Future<void> verifyOtp(String phoneNumber, String otp) async {
    final verifyUrl = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/verify_otp_protected');
    final getNameUrl = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getname');

    try {
      // Verify OTP
      final response = await http.post(
        verifyUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone_number': phoneNumber, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['message'] == 'OTP verified successfully') {
          String token = jsonResponse['token'];

          // Fetch the username
          final getNameResponse = await http.post(
            getNameUrl,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'phone_number': phoneNumber}),
          );

          if (getNameResponse.statusCode == 200) {
            final getNameData = json.decode(getNameResponse.body);

            if (getNameData is Map<String, dynamic> && getNameData.containsKey('name')) {
              final String username = getNameData['name'] ?? '';

              // Store the token and username in the session
              await onLoginSuccess( token, username);

              // Navigate to HomeScreen with the username
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(name: username)),
              );
            } else {
              showError('Failed to retrieve username.');
            }
          } else {
            showError('Failed to fetch username.');
          }
        } else {
          showError('Invalid OTP.');
        }
      } else {
        showError('Failed to verify OTP.');
      }
    } catch (error) {
      print('Error during OTP verification: $error');
      showError('An error occurred. Please try again.');
    }
  }

  Future<void> onLoginSuccess(String token, String username) async {
    // Store the token in secure storage
    await _secureStorage.write(key: 'jwt_token', value: token);

    // Store the username in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInPerson', username);

    // Debug logs to ensure values are stored correctly
    print('Token stored in secure storage: $token');
    print('Username stored in shared preferences: $username');

    // Navigate to HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(name: username)),
    );
  }


  Future<String?> fetchUserName(String phoneNumber) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getname');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'];
    } else {
      return null;
    }



  }

  void showError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Phone Number: ${widget.phoneNumber}'),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            ElevatedButton(
              onPressed: () {
                verifyOtp(widget.phoneNumber, otpController.text);
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
