import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tkw/providers/app_state.dart' ;

class LocationSearch extends StatefulWidget {
  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  List<dynamic> searchResults = [];

  void _search(String query) async {
    try {
      final results = await searchLocation(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Location')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                labelText: 'Enter location',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return ListTile(
                  title: Text(result['display_name']),
                  onTap: () {
                    print('Selected: ${result['display_name']}');
                    // Use the result['lat'] and result['lon'] for mapping
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Future<List<dynamic>> searchLocation(String query) async {
  final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=Türkiye $query&format=json&addressdetails=1&limit=5');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load location data');
  }
}

}
