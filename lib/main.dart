import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task/view/provider/CountryProvider.dart';
import 'package:task/view/screen/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Checking internet connectivity...");
  bool isInternetActive = await checkInternetConnectivity();
  print("Internet connectivity result: $isInternetActive");

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Country Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 239, 239),
      ),
      home: isInternetActive ? const MyApp() : const NoInternetScreen(),
    ),
  );
}

Future<bool> checkInternetConnectivity() async {
  try {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  } catch (e) {
    print("Error checking internet connectivity: $e");
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CountryProvider(),
      child: const CountryListScreen(),
    );
  }
}

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('No Internet Connection'),
      ),
    );
  }
}
