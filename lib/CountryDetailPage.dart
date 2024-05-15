import 'package:flutter/material.dart';

class CountryDetailPage extends StatelessWidget {
  final Map<String, dynamic> country;

  const CountryDetailPage({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var capital = country['capital'] ?? ['Unknown'];
    return Scaffold(
      appBar: AppBar(
        title: Text(country['name']['common']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                country['flags']['png'],
                height: 100,
              ),
            ),
            SizedBox(height: 16.0),
            Text('Capital: ${capital.join(', ')}'),
            SizedBox(height: 8.0),
            Text('Population: ${country['population']}'),
            SizedBox(height: 8.0),
            Text('Region: ${country['region']}'),
            SizedBox(height: 8.0),
            Text('Subregion: ${country['subregion'] ?? 'Unknown'}'),
          ],
        ),
      ),
    );
  }
}
