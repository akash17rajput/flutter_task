import 'package:flutter/material.dart';

class CountryDetailPage extends StatelessWidget {
  final Map<String, dynamic> country;

  const CountryDetailPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var capital = country['capital'] ?? ['Unknown'];
    return Scaffold(
      appBar: AppBar(
        title: Text(country['name']['common']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: size.height * .15,
                width: size.width,
                child: Image.network(
                  country['flags']['png'],
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Capital: ${capital.join(', ')}'),
            const SizedBox(height: 8.0),
            Text('Population: ${country['population']}'),
            const SizedBox(height: 8.0),
            Text('Region: ${country['region']}'),
            const SizedBox(height: 8.0),
            Text('Subregion: ${country['subregion'] ?? 'Unknown'}'),
          ],
        ),
      ),
    );
  }
}
