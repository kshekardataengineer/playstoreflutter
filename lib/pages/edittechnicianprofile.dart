/*
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditTechnicianFormScreen extends StatefulWidget {
  @override
  _EditTechnicianFormScreenState createState() => _EditTechnicianFormScreenState();
}

class _EditTechnicianFormScreenState extends State<EditTechnicianFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _selectedImage;

  // Function to upload profile picture
  Future<http.StreamedResponse> _uploadProfilePicture(File file, String name) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/uploadinglogo'),
    );

    request.fields['name'] = name;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    return await request.send();
  }

  // Function to save form changes
  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        // Update profile picture if selected
        if (_selectedImage != null) {
          final uploadResponse = await _uploadProfilePicture(_selectedImage!, nameController.text);
          if (uploadResponse.statusCode != 200) {
            _showErrorDialog('Failed to upload profile picture. Status code: ${uploadResponse.statusCode}');
            return; // Stop if image upload fails
          }
        }

        // Update other technician details
        final response = await http.post(
          Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/updateTechnician'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'name': nameController.text,
            'contact': contactController.text,
            'availability': availabilityController.text,
            'location': locationController.text,
            'services': servicesController.text.split(',').map((s) => s.trim()).toList(),
            'website': websiteController.text,
            'description': descriptionController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        } else {
          _showErrorDialog('Failed to update profile. Status code: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  // Function to pick an image
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
                controller: servicesController,
                decoration: InputDecoration(
                  labelText: 'Services',
                  hintText: 'Enter services separated by commas',
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Enter at least one service' : null,
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
                validator: (value) => value?.isEmpty ?? true ? 'Enter a description' : null,
              ),
              SizedBox(height: 20),
              Row(
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
