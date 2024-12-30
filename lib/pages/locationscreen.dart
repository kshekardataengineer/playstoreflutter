import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied.');
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Fetch current position
    try {
      currentPosition = await Geolocator.getCurrentPosition();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Failed to get location: $e');
      setState(() {
        isLoading = false;
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
      appBar: AppBar(title: Text('Location Screen')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: currentPosition == null
            ? Text('No location data available.')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude: ${currentPosition!.latitude}'),
            Text('Longitude: ${currentPosition!.longitude}'),
          ],
        ),
      ),
    );
  }
}
