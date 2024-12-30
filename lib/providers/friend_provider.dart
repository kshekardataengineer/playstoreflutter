import 'package:flutter/material.dart';
import '../service/friend_service.dart';
import '../model/friend.dart';

class FriendProvider with ChangeNotifier {
  List<Friend> _friends = [];
  List<Friend> _filteredFriends = [];

  List<Friend> get friends => _filteredFriends;

  FriendProvider() {
    fetchDefaultFriends(name: '', lat: '', lng: '');
  }

  Future<void> fetchDefaultFriends({required name, required String lat, required String lng}) async {
    try {
      print('Fetching default friends');
      // Fetch friends using the service
     // _friends = await FriendService().fetchFriends('rajkiran', '17.3730', '78.5476');
      _friends = await FriendService().fetchFriends(name, lat, lng);
      _filteredFriends = List.from(_friends);
      print(_filteredFriends);// Ensure a new list is created
      print('Default friends fetched and set');
      notifyListeners();
    } catch (e) {
      print('Error fetching default friends: $e');
      // You might want to show an error message to the user or handle it accordingly
    }
  }

/*  void filterFriends(String query) {
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
  }*/
  /* only space as seperator
  void filterFriends(String query) {

    if (query.isEmpty) {
      _filteredFriends = List.from(_friends); // Reset to the original list
    } else {
      // Split the query into individual terms and convert to lowercase
      final terms = query.toLowerCase().split(RegExp(r'\s+')); // Split by spaces

      _filteredFriends = _friends.where((friend) {
        // Convert friend properties to lowercase for case-insensitive search
        final name = friend.name.toLowerCase();
        final occupation = friend.occupation.toLowerCase();
        final city = friend.city.toLowerCase();
        final role = friend.role.toLowerCase();

        // Check if all terms are present in at least one property
        return terms.every((term) =>
        name.contains(term) ||
            occupation.contains(term) ||
            city.contains(term) ||
            role.contains(term));
      }).toList();
    }
    notifyListeners();
  }*/
  /*void filterFriends(String query) {
    if (query.isEmpty) {
      _filteredFriends = List.from(_friends); // Reset to the original list
    } else {
      // Split the query by commas or spaces using a regular expression
      final terms = query
          .toLowerCase()
          .split(RegExp(r'[,\s]+')) // Matches commas or spaces as separators
          .where((term) => term.isNotEmpty) // Remove empty terms
          .toList();

      _filteredFriends = _friends.where((friend) {
        // Convert friend properties to lowercase for case-insensitive search
        final name = friend.name.toLowerCase();
        final occupation = friend.occupation.toLowerCase();
        final city = friend.city.toLowerCase();
        final role = friend.role.toLowerCase();


        // Check if all terms are present in at least one property
        return terms.every((term) =>
        name.contains(term) ||
            occupation.contains(term) ||
            city.contains(term) ||

            role.contains(term));
      }).toList();
    }
    notifyListeners();
  }
  */
  void filterFriends(String query) {
    if (query.isEmpty) {
      _filteredFriends = List.from(_friends); // Reset to the original list
    } else {
      // Split the query into terms by commas or spaces
      final terms = query
          .toLowerCase()
          .split(RegExp(r'[,\s]+')) // Match commas or spaces as separators
          .where((term) => term.isNotEmpty) // Exclude empty terms
          .toList();

      _filteredFriends = _friends.where((friend) {
        // Normalize friend properties for case-insensitive matching
        final name = friend.name?.toLowerCase() ?? '';
        final occupation = friend.occupation?.toLowerCase() ?? '';
        final city = friend.city?.toLowerCase() ?? '';
        final role = friend.role?.toLowerCase() ?? '';
        final country = friend.country?.toLowerCase() ?? '';
        final state = friend.state?.toLowerCase() ?? '';

        // Ensure all terms match at least one property
        return terms.every((term) =>
        name.contains(term) ||
            occupation.contains(term) ||
            city.contains(term) ||
            role.contains(term) ||
            state.contains(term) ||
            country.contains(term));
      }).toList();
    }
    notifyListeners();
  }

}
