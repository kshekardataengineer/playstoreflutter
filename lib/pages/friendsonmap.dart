/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:konktapp/helper/style.dart';






class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  final String apiUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/friendsoffriendsradius20';

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  Future<void> _fetchMarkers() async {
    try {
      final requestBody = json.encode({
        'name': 'rajkiran',
        'lat': '17.3730',
        'lng': '78.5476'
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<String> latList = List<String>.from(data['lat'].values);
        final List<String> lngList = List<String>.from(data['lng'].values);
        final List<String> nameList = List<String>.from(data['friendName'].values);

        setState(() {
          _markers.clear();
          for (int i = 0; i < latList.length; i++) {
            final lat = double.parse(latList[i]);
            final lng = double.parse(lngList[i]);
            final name = nameList[i];

            _markers.add(
              Marker(
                markerId: MarkerId(name),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: 'Lat: $lat, Lng: $lng',
                ),
              ),
            );
          }
        });
      } else {
        throw Exception('Failed to load markers');
      }
    } catch (e) {
      print('Error fetching markers: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with Markers'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(17.3730, 78.5476), // Adjust to a central point
          zoom: 10.0,
        ),
        markers: _markers,
      ),
    );
  }
}
//updated api key

 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:konktapp/pages/viewprofile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen( name:'rajkiran',lat: '51.75703',lng:'-0.2260992'),
    );
  }
}

class MapScreen extends StatefulWidget {
  String name;
  String lat;
  String lng;

  // Accept the name as a parameter
  MapScreen( {required this.name,required this.lat,required this.lng});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  //late LatLng _initialPosition = LatLng(17.3730, 78.5476);hyd

  late final LatLng _initialPosition = LatLng(double.parse(widget.lat) , double.parse(widget.lng));
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchFriendsData();
  }

  Future<void> _fetchFriendsData() async {
 // const apiUrl = 'https://testkonkt.azurewebsites.net/friendsoffriendsradius20';
//nodejs url not showung map and static values working fine
   const apiUrl = 'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/friendsoffriendsradius20';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({
       /* "name": "rajkiran",
        "lat": "17.3730",
        "lng": "78.5476",*/
        /*testing dynamic */
      "name": widget.name,
      "lat":  widget.lat,
      "lng": widget.lng

      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      _initializeMarkers(data);
    } else {
      print("Failed to load data");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _initializeMarkers(Map<String, dynamic> data) {
    // Parse response data and create markers
    for (int i = 0; i < data["friendName"].length; i++) {
      final friendName = data["friendName"]["$i"];
      final occupation = data["occupation"]["$i"];
      final lat = double.parse(data["lat"]["$i"]);
      final lng = double.parse(data["lng"]["$i"]);
     //final lat = double.parse("17.3730");
     // final lng = double.parse("78.5476");


      final marker = Marker(
        markerId: MarkerId(friendName),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: friendName,
          snippet: occupation,
          onTap: () => _navigateToProfile({
            "name": friendName,
            "occupation": occupation,
            "lat": lat,
            "lng": lng,
          }),
        ),
      );

      _markers.add(marker);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _navigateToProfile(Map<String, dynamic> friend) {
    Navigator.of(context).push(
      MaterialPageRoute(
        //builder: (context) => ProfileScreenTest(friend: friend),
        builder: (context) => ViewProfile(loggedin:widget.name,friendName: friend["name"]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Friends Nearby")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        markers: _markers,
      ),
    );
  }
}


//added newly

class ProfileScreenTest extends StatelessWidget {
  final Map<String, dynamic> friend;

  ProfileScreenTest({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${friend["name"]}'s Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${friend["name"]}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Occupation: ${friend["occupation"]}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Location: ${friend["lat"]}, ${friend["lng"]}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
/*flask code */

