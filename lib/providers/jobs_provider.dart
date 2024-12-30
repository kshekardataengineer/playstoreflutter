import 'package:flutter/material.dart';
import '../service/friend_service.dart';
import '../model/friend.dart';

class JobsProvider with ChangeNotifier {
  List<Friend> _friends = [];
  List<Friend> _filteredFriends = [];

  List<Friend> get friends => _filteredFriends;

  FriendProvider() {
    fetchDefaultFriends();
  }

  Future<void> fetchDefaultFriends() async {
    try {
      print('Fetching default friends');
      // Fetch friends using the service
      _friends = await FriendService().fetchFriends('rajkiran', '17.3730', '78.5476');
      _filteredFriends = List.from(_friends); // Ensure a new list is created
      print('Default friends fetched and set');
      notifyListeners();
    } catch (e) {
      print('Error fetching default friends: $e');
      // You might want to show an error message to the user or handle it accordingly
    }
  }

  void filterFriends(String query) {
    if (query.isEmpty) {
      _filteredFriends = List.from(_friends); // Reset to the original list
    } else {
      _filteredFriends = _friends.where((friend) {
        final lowerCaseQuery = query.toLowerCase();
        return friend.name.toLowerCase().contains(lowerCaseQuery) ||
            friend.occupation.toLowerCase().contains(lowerCaseQuery) ||
            friend.city.toLowerCase().contains(lowerCaseQuery) ||
            friend.role.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    }
    notifyListeners();
  }
}
