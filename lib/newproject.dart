import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OTP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RequestOtpScreen(),
    );
  }
}

// Screen 1: Request OTP
class RequestOtpScreen extends StatefulWidget {
  @override
  _RequestOtpScreenState createState() => _RequestOtpScreenState();
}

class _RequestOtpScreenState extends State<RequestOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

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
      }
    } else {
      // Handle the error
      print('Failed to send OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request OTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Enter Mobile Number',
                  hintText: '+447903176512',
                ),
                maxLength: 13,
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
                child: Text('Request OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen 2: Verify OTP
class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  VerifyOtpScreen({required this.phoneNumber});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  bool isResendingOtp = false;

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/verify_otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'OTP verified successfully') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('OTP verified successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Navigate back to the first screen
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showError(jsonResponse['error'] ?? 'Invalid OTP');
      }
    } else {
      showError('Failed to verify OTP');
    }
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
                child: isResendingOtp ? CircularProgressIndicator() : Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
