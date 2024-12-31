import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhoneNumberScreen(),
    );
  }
}

class PhoneNumberScreen extends StatelessWidget {
  // This screen could be where you collect the phone number
  @override
  Widget build(BuildContext context) {
    final String phoneNumber = "+447909032958"; // Example phone number

    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the Consent Screen and pass the phone number
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConsentScreen(phoneNumber: phoneNumber),
              ),
            );
          },
          child: Text('Proceed to Consent Screen'),
        ),
      ),
    );
  }
}

class ConsentScreen extends StatefulWidget {
  final String phoneNumber;

  // Constructor to receive the phone number
  ConsentScreen({required this.phoneNumber});

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool locationConsent = false;
  bool contactsConsent = false;
  bool photosConsent = false;
  bool promotionsConsent = false;
  bool termsAccepted = false;

  Future<void> submitConsentToServer(Map<String, dynamic> consentData) async {
    try {
      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/store-consent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(consentData),
      );

      if (response.statusCode == 200) {
        print("Consent data stored successfully!");
        //Navigator.pushReplacementNamed(context, '/login');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => login(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Consent submitted successfully!")),

        );
      } else {
        print("Failed to store consent data: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit consent. Please try again.")),
        );
      }
    } catch (error) {
      print("Error submitting consent: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  void submitConsent() {
    if (!termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must accept the terms and conditions to proceed.")),
      );
      return;
    }

    final consentData = {
      "phone_number": widget.phoneNumber,
      "location": locationConsent,
      "contacts": contactsConsent,
      "photos": photosConsent,
      "promotions": promotionsConsent,
      "termsAccepted": termsAccepted,
    };

    submitConsentToServer(consentData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consent Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Phone Number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Display phone number as non-editable text
              Text(
                widget.phoneNumber, // Display the passed phone number
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Text(
                "Permissions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text("Allow access to location for nearby services"),
                value: locationConsent,
                onChanged: (value) {
                  setState(() {
                    locationConsent = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Allow access to contacts for connecting with friends"),
                value: contactsConsent,
                onChanged: (value) {
                  setState(() {
                    contactsConsent = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Allow access to photos"),
                value: photosConsent,
                onChanged: (value) {
                  setState(() {
                    photosConsent = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Agree to receive promotional content from partners"),
                value: promotionsConsent,
                onChanged: (value) {
                  setState(() {
                    promotionsConsent = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("I accept the terms and conditions"),
                value: termsAccepted,
                onChanged: (value) {
                  setState(() {
                    termsAccepted = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitConsent,
                  child: Text("Submit Consent"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
