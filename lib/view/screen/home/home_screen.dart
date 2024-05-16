import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task/view/screen/detail%20screen/country_detail_page.dart';
import 'package:task/view/provider/CountryProvider.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final ScrollController _scrollController = ScrollController();
  late CountryProvider _countryProvider;

  @override
  void initState() {
    super.initState();
    // Initialize the scroll listener
    _scrollController.addListener(_scrollListener);
    // Get the instance of CountryProvider
    _countryProvider = Provider.of<CountryProvider>(context, listen: false);
    // Fetch the initial list of countries
    _countryProvider.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Info'),
      ),
      body: Consumer<CountryProvider>(
        builder: (context, provider, __) {
          var countries = provider.countries;
          Map<String, List<dynamic>> groupedCountries = {};
          for (var country in countries) {
            var region = country['region'];
            if (groupedCountries.containsKey(region)) {
              groupedCountries[region]!.add(country);
            } else {
              groupedCountries[region] = [country];
            }
          }

          groupedCountries.forEach((key, value) {
            value.sort(
                (a, b) => a['name']['common'].compareTo(b['name']['common']));
          });

          var sortedRegions = groupedCountries.keys.toList()..sort();

          return RefreshIndicator(
            // Pull-to-refresh functionality
            onRefresh: () => _countryProvider.fetchCountries(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total Continents : ${sortedRegions.length.toString()}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.blue, width: 1.5)),
                    child: Center(
                      child: TextField(
                        onChanged: (value) {
                          provider.updateSearchQuery(value);
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search by country name',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),

                // List of countries
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: sortedRegions.length,
                    itemBuilder: (context, index) {
                      var region = sortedRegions[index];
                      var countriesInRegion = groupedCountries[region]!;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(0),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all()),
                          child: ExpansionTile(
                            dense: true,
                            backgroundColor: Colors.white,
                            title: provider.isLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 24,
                                      width: 200,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    region,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                            children: provider.isLoading
                                ? [Container()]
                                : countriesInRegion.map((country) {
                                    var capital =
                                        country['capital'] ?? ['Unknown'];
                                    return Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CountryDetailPage(
                                                        country: country),
                                              ),
                                            );
                                          },
                                          leading: provider.isLoading
                                              ? Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    height: 70,
                                                    width: 100,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Container(
                                                  height: 70,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        country['flags']['png'],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          title: Text(
                                            country['name']['common'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                            'Capital: ${capital.join(', ')} | Population: ${country['population']}',
                                          ),
                                        ),
                                        const Divider()
                                      ],
                                    );
                                  }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Scroll listener to fetch more countries when reaching the end of the list
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _countryProvider.fetchCountries();
    }
  }

  @override
  void dispose() {
    // Dispose the scroll controller
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
