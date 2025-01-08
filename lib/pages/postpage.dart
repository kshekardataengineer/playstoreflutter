
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:konktapp/pages/readcontacts.dart';

import 'package:intl/intl.dart';
import 'package:konktapp/pages/sosonoff.dart';
import 'package:konktapp/pages/userlistscreenmessages.dart';

import 'package:provider/provider.dart';

import '../providers/UserProvider.dart';
import '../providers/auth_provider.dart';

import 'ProfileScreen.dart';
import 'appsosnotifications.dart';
import 'friendscreenlist.dart';
import 'friendsonmap.dart';

import 'login.dart';
import 'microservices.dart';

import 'package:shared_preferences/shared_preferences.dart';
//commented to received loogedinpersonname
/*class PostScreen extends StatefulWidget {
  static const String page_id = "PostScreen";
  final String filename = 'ee4883e8-31b0-4e2c-80dd-dfba43c92b10.jpg'; // Example filename
  final String name = 'rajesh';


  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {*/
class PostScreen extends StatefulWidget {
  static const String page_id = "PostScreen";

  final String loggedInPerson; // Add loggedInPerson here

  // Constructor to accept loggedInPerson
  const PostScreen({Key? key, required this.loggedInPerson}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int _selectedIndex = 0;
  //String username='rajesh';
  String? loggedInPerson;
  late String username;



  List posts = [];
  Map<String, int> likeCounts = {};
  Map<String, List<dynamic>> comments = {};
  Map<String, List<String>> likedByUsers = {};
  //String loggedInPerson = "rajkiran"; // Example logged-in user
  String? errorMessage;
  int currentPage = 0; // Track current page
  final int pageSize = 10; // Number of posts to load per page
  bool isLoading = false; // Loading state
  bool hasMorePosts = true; // Flag to check if more posts are available

//added new functions
  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');

    // Optimistically update UI
    setState(() {


      if (likedByUsers[filename] == null) {
        likedByUsers[filename] = [];
      }
      // Add the current user if not already liked
      if (!likedByUsers[filename]!.contains(loggedInPerson)) {
        likedByUsers[filename]!.add(loggedInPerson!);
        likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
      }
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
    } else {
      print('Failed to like post. Status code: ${response.statusCode}');
    }
  }

  Future<void> removeLike(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');

    // Optimistically update UI
    setState(() {
      if (likedByUsers[filename] != null) {
        likedByUsers[filename]!.remove(loggedInPerson);
        likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
      }
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
    } else {
      print('Failed to remove like. Status code: ${response.statusCode}');
    }
  }

  Future<void> fetchLikes(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likers = List<String>.from(data.map((like) => like['liker']));

      setState(() {
        likeCounts[filename] = likers.length;
        likedByUsers[filename] = likers;
      });
    } else {
      print('Failed to fetch likes. Status code: ${response.statusCode}');
    }
  }

  Future<void> commentPost(String filename, String name, String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to add comment');
    }
  }
  Future<void> reportPostApi(String filename, String name, String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/reportPost');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to add comment');
    }
  }

  Future<void> fetchComments(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      setState(() {
        comments[filename] = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch comments');
    }
  }

  void reportPost(String filename) {
    String commentContent = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Report"),
        content: TextField(
          onChanged: (value) {
            commentContent = value;
          },
          decoration: InputDecoration(hintText: "Enter your report"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (commentContent.isNotEmpty) {
                commentPost(filename, loggedInPerson!, commentContent);
                Navigator.pop(context);
              }
            },
            child: Text("Submit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void showCommentDialog(String filename) {
    String commentContent = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          onChanged: (value) {
            commentContent = value;
          },
          decoration: InputDecoration(hintText: "Enter your comment"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (commentContent.isNotEmpty) {
                commentPost(filename, loggedInPerson!, commentContent);
                Navigator.pop(context);
              }
            },
            child: Text("Submit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void showCommentsDialog(String filename) {
    fetchComments(filename);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Comments & Likes"),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              // Likes Section
              Expanded(
                child: likedByUsers[filename] != null && likedByUsers[filename]!.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Liked by:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Expanded(
                      child: ListView(
                        children: likedByUsers[filename]!.map((user) => Text(user)).toList(),
                      ),
                    ),
                  ],
                )
                    : Text("No likes yet.", style: TextStyle(color: Colors.grey)),
              ),
              Divider(),
              // Comments Section
              Text("Comments:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Expanded(
                child: comments[filename] != null && comments[filename]!.isNotEmpty
                    ? ListView(
                  children: comments[filename]!.map((comment) {
                    return ListTile(
                      title: Text(comment['content']),
                      subtitle: Text("by ${comment['name']}"),
                    );
                  }).toList(),
                )
                    : Text("No comments yet.", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat.yMMMd().format(dateTime); // Format timestamp
  }





  final List<Widget> _widgetOptions = <Widget>[
    //PostScreen(),
    PostsScreen(),
    //PostsScreen(),
   // FriendsScreen(name: '',),
    FriendsScreen(name: 'rajkian', lat: '17.3730', lng: '78.5476'),
    //reels(),
    //post(),
    ReadContacts(name: 'rajkian'),
    //MapScreen(),
    MapScreen( name:'rajkiran',lat: '17.3730',lng:'78.5476'),
    //ProfileScreen(friendName: 'rajkiran',),
    ProfileScreen(friendName: '',),
    //ServiceScreen(),
    //KonktServicesScreen()
  ];
//updated
  List<Post> _posts = [];
  Set<String> _fetchedPostIds = {}; // Track unique post identifiers
  bool _isFetching = false;
  bool _hasMorePosts = true;
  int _currentPage = 1;
  final int _postsPerPage = 10; // Number of posts to load per request
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;




  @override
  void initState() {
    super.initState();
    _loadLoggedInPerson();




    _fetchPosts();
    _scrollController.addListener(_scrollListener);

    // Set up a timer to fetch new posts periodically (e.g., every 30 seconds)
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _fetchNewPosts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchPosts() async {
    if (_isFetching || !_hasMorePosts) return;

    setState(() {
      _isFetching = true;
    });

    try {
      final newPosts = await fetchPosts(_currentPage, _postsPerPage);

      // Filter out duplicate posts based on a unique identifier (e.g., filename)
      final uniqueNewPosts = newPosts.where((post) => !_fetchedPostIds.contains(post.filename)).toList();

      setState(() {
        _posts.addAll(uniqueNewPosts);
        _fetchedPostIds.addAll(uniqueNewPosts.map((post) => post.filename));
        _currentPage++;
        _hasMorePosts = uniqueNewPosts.length == _postsPerPage;
        _posts.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by timestamp
      });
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  Future<void> _fetchNewPosts() async {
    // Fetch new posts and add them to the top of the list
    try {
      final newPosts = await fetchPosts(1, _postsPerPage);

      // Filter out duplicate posts based on a unique identifier (e.g., filename)
      final uniqueNewPosts = newPosts.where((post) => !_fetchedPostIds.contains(post.filename)).toList();

      if (uniqueNewPosts.isNotEmpty) {
        setState(() {
          _posts.insertAll(0, uniqueNewPosts);
          _fetchedPostIds.addAll(uniqueNewPosts.map((post) => post.filename));
          _posts.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by timestamp
        });

        // Automatically scroll down if new posts are added
        if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    } catch (e) {
      print('Error fetching new posts: $e');
    }
  }
  /*
  //"name": "rajkiran",
  Future<List<Post>> fetchPosts(int page, int limit) async {
    final response = await http.post(
      //Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts'),
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends__posts_L1'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({

        "name": loggedInPerson,
        "page": page,
        "limit": limit,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return Future.wait(data.map((postJson) async {
        final post = Post.fromJson(postJson);
        post.imageBytes = await fetchImageData(post.filename);
        return post;
      }));
    } else {
      throw Exception('Failed to load posts');
    }
  } working code */
  // Load the loggedInPerson from SharedPreferences
  Future<void> _loadLoggedInPerson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInPerson = prefs.getString('loggedInPerson');
    if (loggedInPerson != null && loggedInPerson.isNotEmpty) {
      setState(() {
        loggedInPerson = loggedInPerson;
      });
    } else {
      setState(() {
        loggedInPerson = 'Guest'; // Default to 'Guest' if not found
      });
    }
  }

  Future<List<Post>> fetchPosts(int page, int limit) async {
    try {

      // Make the API call
      final response = await http.post(
        Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends__posts_L1'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": "rajkiran",  // Ensure loggedInPerson is correctly initialized

        }),
      );

      // Check the response status code
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // If the response is successful, parse the data
        List<dynamic> data = json.decode(response.body);

        // Return a list of posts by fetching image data asynchronously
        return Future.wait(data.map((postJson) async {
          final post = Post.fromJson(postJson);  // Assuming Post.fromJson is implemented correctly
          print('Post filename: ${post.filename}');  // Debug log

          try {
            // Fetch the image data
            post.imageBytes = await fetchImageData(post.filename);
            print('Image loaded for: ${post.filename}');  // Debug log
          } catch (e) {
            // Handle image fetching error
            print('Error loading image for ${post.filename}: $e');
            post.imageBytes = null;  // Assign null if image fetching fails
          }

          return post;
        }));
      } else {
        // If the response code is not 200, throw an exception
        throw Exception('Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the HTTP request or image fetching
      print('Error fetching posts: $e');
      throw Exception('Failed to load posts');
    }
  }


  Future<Uint8List> fetchImageData(String filename) async {
    final response = await http.post(
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'filename': filename}),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }



  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchPosts(); // Load more posts when the user reaches the bottom
    }
  }
//working  but only preview issue

  File? _imageFile;
  bool _isLoading = false; // Track loading state
  String _postContent = ""; // Store post content

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  void _showAddPostDialog() {
    // Reset the image before showing the dialog to ensure it starts fresh
    _imageFile = null;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add a New Post"),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 400), // Set a max height
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: "What's on your mind?",
                        ),
                        maxLines: null, // Allow for multiple lines if needed
                        onChanged: (value) {
                          setState(() {
                            _postContent = value; // Update content as user types
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      if (_imageFile != null) // Show selected image if available
                        Column(
                          children: [
                            Image.file(_imageFile!, height: 200),
                            SizedBox(height: 10),
                            /* Text(
                              'Selected: ${_imageFile!.path.split('/').last}', // Display filename
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),*/
                          ],
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await _pickImage(); // Pick an image
                          if (_imageFile != null) {
                            setState(() {}); // Refresh dialog to show updated button text
                          }
                        },
                        child: Text(_imageFile != null ? "Image Selected" : "Select Image"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                _imageFile = null; // Clear image selection on cancel
              },
            ),
            TextButton(
              child: Text("Post"),
              onPressed: () {
                if (_postContent.isNotEmpty && _imageFile != null) {
                  Navigator.of(context).pop(); // Close the dialog
                  _postNewContent(_postContent); // Call your posting function
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter content and select an image.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _postNewContent(String content) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createpost'),
    );

    request.fields['content'] = content; // Content of the post
    request.fields['name'] = 'varun'; // Logged-in username

    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', _imageFile!.path), // 'file' is the field name for the image
      );
    }

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await request.send();

      // Close loading state
      setState(() {
        _isLoading = false; // Reset loading state
      });

      if (response.statusCode == 200) {
        // Post was successful
        _fetchPosts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post successfully added!'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset the image file and post content after successful post
        setState(() {
          _imageFile = null; // Clear the selected image
          _postContent = ""; // Clear the post content
        });
        _buildPostScreen();
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add post: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading state
      setState(() {
        _isLoading = false; // Reset loading state
      });
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
/*working perfectly*/
/* added code o refresh after successful post*/


  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    //String loggedinperson='rajkiran';
    String? loggedInPerson; // This can be null
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Image.asset(
              'assets/images/konkt_jpeg_logo.jpeg', // Path to your logo image
              width: 140, // Set the width you want
              height: 160, // Set the height you want
            ),
            /* Text(
              'Konkt',
              style: TextStyle(
                  fontFamily: 'bold', fontSize: 24, color: Colors.black),
            ),*/
            //Icon(Icons.keyboard_arrow_down)
          ],
        ),
        actions: [
          Row(
            children: [

              IconButton(

                onPressed: () {
                  Navigator.push(context,
                      //MaterialPageRoute(builder: (context) => messageScreen()));
                      //MaterialPageRoute(builder: (context) => SenderListScreen()));
                      MaterialPageRoute(builder: (context) => UserListScreen(loggedinPerson: loggedInPerson!)));
                },
                icon: Icon(Icons.message_outlined),
              ),

              IconButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(1000, 80, 0, 0),
                    items: [
                      PopupMenuItem(
                        child: Text('App Notifications'),
                        value: 'app_notifications',
                      ),
                      PopupMenuItem(
                        child: Text('SOS Notifications'),
                        value: 'sos_notifications',
                      ),
                    ],
                  ).then((value) {
                    if (value == 'app_notifications') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationsScreen(notificationType: 'app')),
                      );
                    } else if (value == 'sos_notifications') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationsScreen(notificationType: 'sos')),
                      );
                    }
                  });
                },
                icon: Icon(Icons.notifications),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      //MaterialPageRoute(builder: (context) => messageScreen()));
                      MaterialPageRoute(builder: (context) => SOSApp(name:widget.loggedInPerson)));
                },
                icon: Icon(Icons.sos_rounded),
              ),
              /* commenting as in home screen its working
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      //MaterialPageRoute(builder: (context) => messageScreen()));
                      //MaterialPageRoute(builder: (context) => PostsScreen()));
                      MaterialPageRoute(builder: (context) => PostsScreen()));
                  // MaterialPageRoute(builder: (context) => PostsScreen1()));
                },
                icon: Icon(Icons.image),
              ),*/
              /*IconButton(
                onPressed: () {
                  Navigator.push(context,

                      MaterialPageRoute(builder: (context) => ReadContacts()));
                },
                icon: Icon(Icons.contact_phone),
              ),*/
              PopupMenuButton(
                padding: EdgeInsets.all(0),
                onSelected: (value) async {
                  if (value == 5) {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.logout();
                    Navigator.of(context).pushReplacementNamed(login.page_id);
                  }
                },
                itemBuilder: (context) => [

                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded),
                        SizedBox(width: 10),
                        Text('Logout', style: TextStyle(color: Colors.black, fontSize: 17)),
                      ],
                    ),
                    value: 5,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildPostScreen() : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Near By',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog, // This will trigger the dialog
        child: Icon(Icons.add),
      ),

    );
  }


  Widget _buildPostScreen() {
    return RefreshIndicator(
      onRefresh: _fetchNewPosts, // Refresh posts on pull-to-refresh
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Container for KonktServicesScreen
            Container(//changed height 120 to 90
              height: 90 , // Set an appropriate height for the services section
              child: MicroServicesScreen(), // Your services screen
            ),

            Container(
              height: MediaQuery.of(context).size.height - 200, // Take remaining height
              child: PostsScreen(), // This now integrates your PostsScreen widget
            ),

          ],
        ),
      ),
    );
  }




// Function to send the request with dynamic parameters
  Future<void> sendRequest(String filename, String name) async {
    // The URL endpoint
    var url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');

    // JSON body of the request
    Map<String, String> requestBody = {
      'filename': filename,
      'name': name
    };


    // Send the POST request
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    // Check the status code for success
    if (response.statusCode == 200) {
      print('Request successful!');
      // Parse the response body
      var responseData = jsonDecode(response.body);

      // Check if responseData is empty
      if (responseData.isEmpty) {
        print('Response is an empty list.');
      } else {
        print('Response data: $responseData');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  // Function to send the request with dynamic parameters
  Future<void> sendComment(String filename, String name,String content) async {

    // The URL endpoint
    var url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');

    // JSON body of the request
    Map<String, String> requestBody = {
      'filename': filename,
      'name': name,
      'content': content
    };


    // Send the POST request
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    // Check the status code for success
    if (response.statusCode == 200) {
      print('Request successful!');
      // Parse the response body
      var responseData = jsonDecode(response.body);

      // Check if responseData is empty
      if (responseData.isEmpty) {
        print('Response is an empty list.');
      } else {
        print('Response data: $responseData');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }



  Widget postCard(Post post) {
    // Getting the like count and checking if the user has liked the post
    final postLikes = likeCounts[post.filename] ?? 0;
    final userHasLiked = likedByUsers[post.filename]?.contains(loggedInPerson) ?? false;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header with user information
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.imageBytes != null ? MemoryImage(post.imageBytes!) : null,
              backgroundColor: Colors.grey.shade200,
            ),
            title: Text(
              post.friendName,
              style: TextStyle(fontFamily: 'medium'),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Posted by ${post.friendName}"),
                SizedBox(height: 5),
                Text(post.formattedTimestamp),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // Show options in a bottom sheet when the more icon is clicked
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.5,
                          child: bottomContainer(),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Display image if available
          if (post.imageBytes != null)
            InkWell(
              onTap: () {},
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(post.imageBytes!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          // Like, comment, and view comments row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                // Like button
                IconButton(
                  icon: Icon(
                    userHasLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: userHasLiked ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    if (userHasLiked) {
                      removeLike(post.filename);
                    } else {
                      likePost(post.filename);
                    }
                  },
                ),
                // Like count
                Text("$postLikes Likes"),
                // Comment button
                TextButton(
                  onPressed: () => showCommentDialog(post.filename),
                  child: Text("Comment"),
                ),
                // View Comments button
                TextButton(
                  onPressed: () => showCommentsDialog(post.filename),
                  child: Text("View Comments"),
                ),
                TextButton(
                  onPressed: () => reportPost(post.filename),
                  child: Text("Report"),
                ),
              ],
            ),
          ),

          // Post content
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: post.friendName,
                    style: TextStyle(fontFamily: 'medium', color: Colors.black),
                  ),
                  TextSpan(
                    text: ' ${post.content}',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // Timestamp or formatted date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              post.formattedTimestamp,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }








  Widget bottomContainer() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          /*Row(
            children: [
              Icon(Icons.info_outline),
              SizedBox(width: 10),
              Text(
                'About this account',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.remove_red_eye_outlined),
              SizedBox(width: 10),
              Text(
                'Hide this account',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.report_gmailerrorred_outlined),
              SizedBox(width: 10),
              Text(
                'Report this account',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.copy_outlined),
              SizedBox(width: 10),
              Text(
                'Copy link',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}

class Post {
  final String content;
  final String filename;
  final String friendName;
  final String timestamp;
  Uint8List? imageBytes;

  Post({
    required this.content,
    required this.filename,
    required this.friendName,
    required this.timestamp,
    this.imageBytes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'],
      filename: json['filename'],
      friendName: json['friendName'],
      timestamp: json['timestamp'],
    );
  }

  String get formattedTimestamp {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return 'Unknown time';
    }
  }
}



class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List posts = [];
  Map<String, int> likeCounts = {}; // Store like counts for each post
  Map<String, List<dynamic>> comments = {}; // Store comments for each post
  Map<String, List<String>> likedByUsers = {
  }; // Store users who liked each post
  //String loggedInPerson = "rajkiran";
  String? loggedInPerson; // Example logged-in user
  String? errorMessage; // Error message variable


  @override
  void initState() {
    super.initState();
   // loadLoggedInPerson();

    fetchPosts();




  }

/*working
  // Method to fetch posts
  Future<void> fetchPosts() async {
    // final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends_of_friends_posts');
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends__posts_L1');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": loggedInPerson}),
      );

      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          errorMessage = null; // Clear any previous error message
          for (var post in posts) {
            fetchLikes(post['filename']);
            fetchComments(post['filename']);
            // Fetch the image for each post
            fetchImageData(post['filename']).then((imageBytes) {
              setState(() {
                post['imageBytes'] =
                    imageBytes; // Store image bytes in the post
              });
            });
          }
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load posts: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching posts: $e'; // Update the error message
      });
    }
  }*/


  Future<void> fetchPosts() async {





    // Fetch loggedInPerson from UserProvider
    //String? loggedInPerson = Provider.of<UserProvider>(context, listen: false).loggedInPerson;


    // Ensure loggedInPerson is not null
   /* if (loggedInPerson == null) {
      throw Exception('User not logged in');
    }*/

    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_friends__posts_L1');

    try {

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
       body: jsonEncode({"name": "rajkiran"}),
        //body: jsonEncode({"name": loggedInPerson}),
      );
      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          errorMessage = null; // Clear any previous error message
          for (var post in posts) {
            // Fetch likes and comments for each post
            fetchLikes(post['filename']);
            fetchComments(post['filename']);

            // Fetch the image for each post (if exists)
            fetchImageData(post['filename']).then((imageBytes) {
              setState(() {
                post['imageBytes'] = imageBytes; // Store image bytes in the post
              });
            });
          }
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load posts: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching posts: $e'; // Update the error message
      });
    }
  }





  // Method to fetch image data
  Future<Uint8List?> fetchImageData(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/get_postimage');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // Return image data as bytes
    } else {
      print('Failed to fetch image');
      return null;
    }
  }

  Future<void> likePost(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createlike');
    print(
        'Liking post with filename: $filename by $loggedInPerson'); // Debug statement

    // Optimistically update UI
    setState(() {
      if (likedByUsers[filename] == null) {
        likedByUsers[filename] = [];
      }
      // Add the current user if not already liked
      if (!likedByUsers[filename]!.contains(loggedInPerson)) {
        likedByUsers[filename]!.add(loggedInPerson!);
        likeCounts[filename] = (likeCounts[filename] ?? 0) + 1;
      }
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson!}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after liking the post
      print('Liked successfully by $loggedInPerson'); // Debug statement
    } else {
      print('Failed to like post. Status code: ${response
          .statusCode}'); // Debug statement
      print('Response body: ${response
          .body}'); // Print response body for further debugging
    }
  }

  Future<void> removeLike(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/deleteliked');
    print(
        'Removing like for post with filename: $filename by $loggedInPerson'); // Debug statement

    // Optimistically update UI
    setState(() {
      if (likedByUsers[filename] != null) {
        likedByUsers[filename]!.remove(loggedInPerson);
        likeCounts[filename] = (likeCounts[filename] ?? 0) - 1;
      }
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": loggedInPerson}),
    );

    if (response.statusCode == 200) {
      fetchLikes(filename); // Fetch likes again after removing the like
      print('Like removed successfully by $loggedInPerson'); // Debug statement
    } else {
      print('Failed to remove like. Status code: ${response
          .statusCode}'); // Debug statement
      print('Response body: ${response
          .body}'); // Print response body for further debugging
    }
  }

  Future<void> fetchLikes(String filename) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostlikedby');
    print('Fetching likes for post: $filename'); // Debug statement
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likers = List<String>.from(data.map((like) => like['liker']));
      print('Likers: $likers'); // Debug statement

      setState(() {
        likeCounts[filename] = likers.length;
        likedByUsers[filename] = likers;
      });
    } else {
      print('Failed to fetch likes. Status code: ${response.statusCode}');
      print('Response body: ${response
          .body}'); // Print response body for debugging
    }
  }

  Future<void> commentPost(String filename, String name, String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/createcomment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      print('Comment added');
      fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to add comment');
    }
  }

  Future<void> fetchComments(String filename) async {
    final url = Uri.parse(
        'https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/getpostcommentedby');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      setState(() {
        comments[filename] = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch comments');
    }
  }

  void showCommentDialog(String filename) {
    String commentContent = '';
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Add Comment"),
            content: TextField(
              onChanged: (value) {
                commentContent = value;
              },
              decoration: InputDecoration(hintText: "Enter your comment"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (commentContent.isNotEmpty) {
                    commentPost(filename, loggedInPerson!, commentContent);
                    Navigator.pop(context);
                  }
                },
                child: Text("Submit"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
          ),
    );
  }

  //debugging code to find error
  void showCommentsDialog(String filename) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Comments & Likes"),
        content: Container(
          width: double.maxFinite,
          height: 300, // Set a height for the dialog
          child: Column(
            children: [
              // Likes Section
              Expanded(
                child: likedByUsers[filename] != null &&
                    likedByUsers[filename]!.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Liked by:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Expanded(
                      child: ListView(
                        children: likedByUsers[filename]!
                            .map((user) => Text(user))
                            .toList(),
                      ),
                    ),
                  ],
                )
                    : Text("No likes yet.", style: TextStyle(color: Colors.grey)),
              ),
              Divider(),
              // Comments Section
              Text("Comments:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Expanded(
                child: comments[filename] != null &&
                    comments[filename]!.isNotEmpty
                    ? ListView.builder(
                  itemCount: comments[filename]!.length,
                  itemBuilder: (context, index) {
                    final comment = comments[filename]![index];

                    // Print the comment data to inspect its structure
                    print('Comment at index $index: $comment');

                    // Check if the comment has the required fields
                    if (comment is Map<String, dynamic> &&
                        comment.containsKey('commentContent') &&
                        comment.containsKey('commenter') &&
                        comment.containsKey('timestamp')) {
                      final commentContent =
                          comment['commentContent'] ?? "No content";
                      final commenter = comment['commenter'] ?? "Anonymous";
                      final timestamp =
                      formatTimestamp(comment['timestamp'] ?? "");

                      return ListTile(
                        title: Text(commentContent),
                        subtitle: Text('$commenter at $timestamp'),
                      );
                    } else {
                      // Log the invalid comment data
                      print("Invalid comment data at index $index: $comment");
                      return ListTile(
                        title: Text("Invalid comment data"),
                      );
                    }
                  },
                )
                    : Text("No comments yet.", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }



  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
    } catch (e) {
      return timestamp; // Return original timestamp if parsing fails
    }
  }
  Future<void> reportPostApi(String filename, String name, String content) async {
    final url = Uri.parse('https://nodejskonktapi-eybsepe4aeh9hzcy.eastus-01.azurewebsites.net/reportPost');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filename": filename, "name": name, "content": content}),
    );

    if (response.statusCode == 200) {
      print('reported successfully');
      fetchPosts();
     // fetchComments(filename); // Fetch comments again to update the view
    } else {
      print('Failed to report');
    }
  }

  void reportPost(String filename) {
    String commentContent = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Report"),
        content: TextField(
          onChanged: (value) {
            commentContent = value;
          },
          decoration: InputDecoration(hintText: "Enter your report"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (commentContent.isNotEmpty) {
                reportPostApi(filename, loggedInPerson!, commentContent);
                Navigator.pop(context);
              }
            },
            child: Text("Submit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: null,
      body: errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.red),
        ),
      )
          : posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .padding
                .bottom + 16, // Adjust for bottom navigation
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final postLikes = likeCounts[post['filename']] ?? 0;
            final userHasLiked =
                likedByUsers[post['filename']]?.contains(loggedInPerson) ??
                    false;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(post['content'] ?? "No title"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Posted by ${post['friendName']}"),
                        SizedBox(height: 5),
                        Text(formatTimestamp(post['timestamp'] ?? "")),
                      ],
                    ),
                  ),
                  if (post['imageBytes'] != null)
                    Image.memory(
                      post['imageBytes'], // Use the image bytes from the post
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          userHasLiked ? Icons.favorite : Icons.favorite_border,
                          color: userHasLiked ? Colors.red : null,
                        ),
                        onPressed: () {
                          if (userHasLiked) {
                            removeLike(post['filename']);
                          } else {
                            likePost(post['filename']);
                          }
                        },
                      ),
                      Text('$postLikes likes'),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          showCommentDialog(post['filename']);
                        },
                      ),
                      Text('${comments[post['filename']]?.length ?? 0} comments'),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          fetchLikes(post['filename']); // Fetch likes for this post
                          showCommentsDialog(post['filename']);
                        },
                        child: Text("View All"),
                      ),
                      PopupMenuButton<String>(
                      onSelected: (value) {
            if (value == 'Report') {
            // Call the API to report the post directly
            reportPostApi(
            post['filename'], // Pass the filename
              loggedInPerson!,  // Pass the logged-in user name
            "Content is not appropriate", // Default report content
            );
            }
            },
            itemBuilder: (context) => [
            PopupMenuItem(
            value: 'Report',
            child: Text('Report'),
            ),
            ],
            icon: Icon(Icons.more_vert),
                      )

                    ],
                  ),
                ],
              ),
            );


          },
        ),
      ),
    );
  }
}

