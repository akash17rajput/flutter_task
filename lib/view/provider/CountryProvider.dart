import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CountryProvider extends ChangeNotifier {
  final List<dynamic> _countries = [];
  String _searchQuery = '';

  // Getter for countries list
  List<dynamic> get countries {
    if (_searchQuery.isEmpty) {
      // If search query is empty, return all countries
      return _countries;
    } else {
      // If search query is not empty, filter countries based on search query
      return _countries.where((country) {
        return country['name']['common']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  // Getter for search query
  String get searchQuery => _searchQuery;

  // Method to update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); // Notify listeners to update UI
  }

  // Loading state
  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Method to fetch countries from API
  Future<void> fetchCountries() async {
    try {
      var response =
          await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

      if (response.statusCode == 200) {
        // If the request is successful, parse the response data
        var data = json.decode(response.body);
        _countries.clear(); // Clear existing countries list
        _countries.addAll(data); // Add new countries to the list
        notifyListeners(); // Notify listeners to update UI
      } else {
        // If the request is not successful, throw an exception
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        // Handle socket exception (no internet connection)
        throw Exception('No internet connection');
      } else {
        // Handle other exceptions
        throw Exception('Failed to load countries: $e');
      }
    }
  }
}
