import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => CountryProvider(),
        child: CountryListScreen(),
      ),
    );
  }
}

class CountryProvider extends ChangeNotifier {
  List<dynamic> _countries = [];
  int _currentPage = 1;
  int _totalPages = 1;
  String _searchQuery = '';

  List<dynamic> get countries => _countries;
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchCountries() async {
    if (_currentPage <= _totalPages) {
      try {
        var response = await http.get(Uri.parse(
            'https://restcountries.com/v3.1/all?limit=10&page=$_currentPage'));
        var data = json.decode(response.body);
        _totalPages = (response.headers['x-total-pages'] != null)
            ? int.parse(response.headers['x-total-pages']!)
            : 1;
        _countries.addAll(data);
        _currentPage++;
        notifyListeners();
      } catch (e) {
        print('Error fetching countries: $e');
      }
    }
  }
}

class CountryListScreen extends StatefulWidget {
  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<CountryProvider>(context, listen: false).fetchCountries();
    }
  }

  @override
  Widget build(BuildContext context) {
    var countryProvider = Provider.of<CountryProvider>(context);
    var countries = countryProvider.countries;

    Map<String, List<dynamic>> groupedCountries = {};
    for (var country in countries) {
      var region = country['region'];
      if (groupedCountries.containsKey(region)) {
        groupedCountries[region]!.add(country);
      } else {
        groupedCountries[region] = [country];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Country Info'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: groupedCountries.length,
        itemBuilder: (context, index) {
          var region = groupedCountries.keys.toList()[index];
          var countriesInRegion = groupedCountries[region]!;

          return ExpansionTile(
            title: Text(region),
            children: countriesInRegion.map((country) {
              var capital = country['capital'] ?? ['Unknown'];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountryDetailPage(country: country),
                    ),
                  );
                },
                leading: Image.network(country['flags']['png']),
                title: Text(country['name']['common']),
                subtitle: Text(
                  'Capital: ${capital.join(', ')} | Population: ${country['population']}',
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
