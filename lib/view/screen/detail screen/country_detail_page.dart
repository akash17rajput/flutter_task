import 'package:flutter/material.dart';

class CountryDetailPage extends StatelessWidget {
  final Map<String, dynamic> country;

  const CountryDetailPage({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var capital = country['capital'] ?? ['Unknown'];
    return Scaffold(
      appBar: AppBar(
        title: Text(country['name']['common']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Center(
              child: SizedBox(
                height: size.height * .3,
                width: size.width,
                child: Image.network(
                  country['flags']['png'],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  // Capital
                  Row(
                    children: [
                      const Text(
                        'Capital : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Text(
                        '${capital.join(', ')}',
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Population
                  Row(
                    children: [
                      const Text(
                        'Population : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Text(
                        '${country['population']}',
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Region
                  Row(
                    children: [
                      const Text(
                        'Region : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Text(
                        '${country['region']}',
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Subregion
                  Row(
                    children: [
                      const Text(
                        'Subregion : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Text(
                        '${country['subregion'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
