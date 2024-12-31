/*services not working*/
/*
working code*/
/*
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TechnicianFormScreen extends StatefulWidget {
  @override
  _TechnicianFormScreenState createState() => _TechnicianFormScreenState();
}

class _TechnicianFormScreenState extends State<TechnicianFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isRegistered = false; // Track if registration is successful

  // Define controllers to capture user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();



/* this code working but services not saving*
  // Function to post data to API
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Prepare the data in JSON format
      final Map<String, dynamic> technicianData = {
        'name': nameController.text,
        'contact': contactController.text,
        'rating': 4.9,  // Set rating to a default value
        'availability': availabilityController.text,
        'location': locationController.text,
        'services': servicesController.text.split(',').map((s) => s.trim()).toList(),  // Convert services to a list
      };

      const String apiUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/registerTechnician';

      try {
        // Call the REST API
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(technicianData),
        );

        // Check response and parse message
        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          // Display success message from response
          if (responseData['message'] != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'])),
            );
          } else {
            // Display a generic success message if message field is missing
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Technician registered successfully!')),
            );
          }
        } else {
          // Error handling with specific message
          _showErrorDialog('Failed to submit data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        // Show dialog with the error details
        _showErrorDialog('An error occurred: $e');
      }
    }
  }*/

  /* to correct to save services testing*/
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Ensure all values are captured properly
      final Map<String, dynamic> technicianData = {
        'name': nameController.text.trim(),
        'contact': contactController.text.trim(),
        'rating': 4.9, // Set to default value
        'availability': availabilityController.text.trim(),
        'location': locationController.text.trim(),
        'website' : websiteController.text.trim(),
        'description' :descriptionController.text.trim(),
        'services': servicesController.text.split(',').map((s) => s.trim()).toList(),
      };

      // Debugging: Log the payload
      print('Payload being sent: ${jsonEncode(technicianData)}');

      const String apiUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/registerTechnician';

      try {
        // Send the request to the API
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(technicianData),
        );

        // Log the response
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          // Display success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Technician registered successfully!')),
          );
        } else {
          // Handle error response
          _showErrorDialog('Failed to submit data. Response: ${response.body}');
        }
      } catch (e) {
        // Handle network or JSON errors
        _showErrorDialog('An error occurred: $e');
      }
    }
  }
// Function to upload the logo (image) separately
  Future<void> _uploadLogo() async {
    if (_selectedImage != null) {
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadinglogo'),
        );

        // Add the image file
        request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

        // Add technician name for image upload
        request.fields['name'] = nameController.text;

        // Send the request for image upload
        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logo uploaded successfully!')),
          );
        } else {
          _showErrorDialog('Failed to upload logo. Status code: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred while uploading the logo: $e');
      }
    } else {
      _showErrorDialog('No logo selected. Please select a logo first.');
    }
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to show error dialog
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

  // Function to open the logo upload dialog
  void _showUploadLogoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Logo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
                  : Text('No image selected'),
              TextButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadLogo(); // Upload the selected logo
              },
              child: Text('Upload Logo'),
            ),
          ],
        );
      },
    );
  }

/*

  // Function to show an error dialog with exception details
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submission Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a contact' : null,
              ),
              TextFormField(
                controller: availabilityController,
                decoration: InputDecoration(labelText: 'Availability'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter availability' : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a location' : null,
              ),
              TextFormField(
                controller: websiteController,
                decoration: InputDecoration(labelText: 'Website'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter  a website' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              TextFormField(
                controller: servicesController,
                decoration: InputDecoration(
                  labelText: 'Services',
                  hintText: 'Enter services separated by commas',
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Enter at least one service' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} upload logo only not there code working perfectly*/

/* only preview was issue logo uploading and text data as well perfect
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TechnicianFormScreen extends StatefulWidget {
  @override
  _TechnicianFormScreenState createState() => _TechnicianFormScreenState();
}

class _TechnicianFormScreenState extends State<TechnicianFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isRegistered = false; // Track if registration is successful

  // Define controllers to capture user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Ensure all values are captured properly
      final Map<String, dynamic> technicianData = {
        'name': nameController.text.trim(),
        'contact': contactController.text.trim(),
        'rating': 4.9, // Set to default value
        'availability': availabilityController.text.trim(),
        'location': locationController.text.trim(),
        'website': websiteController.text.trim(),
        'description': descriptionController.text.trim(),
        'services': servicesController.text.split(',').map((s) => s.trim()).toList(),
      };

      // Debugging: Log the payload
      print('Payload being sent: ${jsonEncode(technicianData)}');

      const String apiUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/registerTechnician';

      try {
        // Send the request to the API
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(technicianData),
        );

        // Log the response
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          // Update the registration status and display success message
          setState(() {
            isRegistered = true; // Mark as registered
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Technician registered successfully!')),
          );
        } else {
          // Handle error response
          _showErrorDialog('Failed to submit data. Response: ${response.body}');
        }
      } catch (e) {
        // Handle network or JSON errors
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  Future<void> _uploadLogo() async {
    if (_selectedImage != null) {
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadinglogo'),
        );

        // Add the image file
        request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

        // Add technician name for image upload
        request.fields['name'] = nameController.text;

        // Send the request for image upload
        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logo uploaded successfully!')),
          );
        } else {
          _showErrorDialog('Failed to upload logo. Status code: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred while uploading the logo: $e');
      }
    } else {
      _showErrorDialog('No logo selected. Please select a logo first.');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a contact' : null,
              ),
              TextFormField(
                controller: availabilityController,
                decoration: InputDecoration(labelText: 'Availability'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter availability' : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a location' : null,
              ),
              TextFormField(
                controller: websiteController,
                decoration: InputDecoration(labelText: 'Website'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a website' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              TextFormField(
                controller: servicesController,
                decoration: InputDecoration(
                  labelText: 'Services',
                  hintText: 'Enter services separated by commas',
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Enter at least one service' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              if (isRegistered)
                ElevatedButton(
                  onPressed: _showUploadLogoDialog,
                  child: Text('Upload Logo'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadLogoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Logo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
                  : Text('No image selected'),
              TextButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadLogo();
              },
              child: Text('Upload Logo'),
            ),
          ],
        );
      },
    );
  }
}
only preview was not showing */
/*
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TechnicianFormScreen extends StatefulWidget {
  @override
  _TechnicianFormScreenState createState() => _TechnicianFormScreenState();
}

class _TechnicianFormScreenState extends State<TechnicianFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isRegistered = false; // Track if registration is successful

  // Define controllers to capture user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();
  // Category selection
  String? selectedCategory;
  List<String> categories = []; // List to store categories
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> technicianData = {
        'name': nameController.text.trim(),
        'contact': contactController.text.trim(),
        'rating': 4.9, // Set to default value
        'availability': availabilityController.text.trim(),
        'location': locationController.text.trim(),
        'website': websiteController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': categoryController.text.trim(),
        'services': servicesController.text.split(',').map((s) => s.trim()).toList(),
      };

      print('Payload being sent: ${jsonEncode(technicianData)}');

      const String apiUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/registerTechnician';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(technicianData),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          setState(() {
            isRegistered = true; // Mark as registered
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Technician registered successfully!')),
          );
        } else {
          _showErrorDialog('Failed to submit data. Response: ${response.body}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  Future<void> _uploadLogo() async {
    if (_selectedImage != null) {
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadinglogo'),
        );

        request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
        request.fields['name'] = nameController.text;

        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logo uploaded successfully!')),
          );
        } else {
          _showErrorDialog('Failed to upload logo. Status code: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred while uploading the logo: $e');
      }
    } else {
      _showErrorDialog('No logo selected. Please select a logo first.');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Update the selected image
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a contact' : null,
              ),
              TextFormField(
                controller: availabilityController,
                decoration: InputDecoration(labelText: 'Availability'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter availability' : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a location' : null,
              ),
              TextFormField(
                controller: websiteController,
                decoration: InputDecoration(labelText: 'Website'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a website' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              TextFormField(
                controller: servicesController,
                decoration: InputDecoration(
                  labelText: 'Services',
                  hintText: 'Enter services separated by commas',
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Enter at least one service' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              if (isRegistered)
                Column(
                  children: [
                    if (_selectedImage != null)
                      Image.file(
                        _selectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Logo'),
                    ),
                    ElevatedButton(
                      onPressed: _uploadLogo,
                      child: Text('Upload Logo'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
/* above code working perfectly logo preview and uploading services as well*/
/*testing category*/
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TechnicianFormScreen extends StatefulWidget {
  @override
  _TechnicianFormScreenState createState() => _TechnicianFormScreenState();
}

class _TechnicianFormScreenState extends State<TechnicianFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isRegistered = false; // Track if registration is successful

  // Define controllers to capture user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Category selection
  String? selectedCategory;
  List<String> categories = []; // List to store categories

  @override
  void initState() {
    super.initState();
    _fetchCategories();  // Fetch categories when the screen initializes
  }

  Future<void> _fetchCategories() async {
    const String apiUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/categories'; // Your API endpoint
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the response body
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if the 'categories' key exists and handle the data
        if (data.containsKey('categories')) {
          final List<dynamic> categoryData = data['categories'];

          print('Categories loaded: $categoryData'); // Debug: check the response

          setState(() {
            categories = List<String>.from(categoryData);  // Ensure proper conversion to List<String>
          });
        } else {
          _showErrorDialog('Categories key is missing in the response.');
        }
      } else {
        _showErrorDialog('Failed to load categories. Response code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('An error occurred while fetching categories: $e');
    }
  }


  // Function to submit form data
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> technicianData = {
        'name': nameController.text.trim(),
        'contact': contactController.text.trim(),
        'rating': 4.9, // Set to default value
        'availability': availabilityController.text.trim(),
        'location': locationController.text.trim(),
        'website': websiteController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory, // Add selected category here
        'services': servicesController.text.split(',').map((s) => s.trim()).toList(),
      };

      print('Payload being sent: ${jsonEncode(technicianData)}');

      const String apiUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/registerTechnician';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(technicianData),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          setState(() {
            isRegistered = true; // Mark as registered
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Technician registered successfully!')),
          );
        } else {
          _showErrorDialog('Failed to submit data. Response: ${response.body}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  // Function to upload logo
  Future<void> _uploadLogo() async {
    if (_selectedImage != null) {
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadinglogo'),
        );

        request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
        request.fields['name'] = nameController.text;

        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logo uploaded successfully!')),
          );
        } else {
          _showErrorDialog('Failed to upload logo. Status code: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred while uploading the logo: $e');
      }
    } else {
      _showErrorDialog('No logo selected. Please select a logo first.');
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Update the selected image
      });
    }
  }

  // Function to show error dialogs
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a contact' : null,
              ),
              TextFormField(
                controller: availabilityController,
                decoration: InputDecoration(labelText: 'Availability'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter availability' : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a location' : null,
              ),
              TextFormField(
                controller: websiteController,
                decoration: InputDecoration(labelText: 'Website'),
                validator: (value) => value?.isEmpty ?? true ? 'Enter a website' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              TextFormField(
                controller: servicesController,
                decoration: InputDecoration(
                  labelText: 'Services',
                  hintText: 'Enter services separated by commas',
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Enter at least one service' : null,
              ),
              // Dropdown for categories
              categories.isEmpty
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator while categories are being fetched
                  : DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Category'),
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              if (isRegistered)
                Column(
                  children: [
                    if (_selectedImage != null)
                      Image.file(
                        _selectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Logo'),
                    ),
                    ElevatedButton(
                      onPressed: _uploadLogo,
                      child: Text('Upload Logo'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
