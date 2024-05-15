import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(hintText: 'Phone'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                print('Pressed');

                try {
                  print('------1');

                  var body = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'password': passwordController.text,
                  };
                  print('------3');

                  final response = await http.post(
                    Uri.parse('http://192.168.5.172/api/registration.php'),
                    body: body,
                  );
                  print('------4');

                  print(response.body);

                  if (response.statusCode == 200) {
                    // Request was successful
                    print('Registration successful');
                  } else {
                    // Request failed
                    print('Failed to register: ${response.statusCode}');
                  }
                } catch (e) {
                  // Handle any exceptions that occur
                  print('Error during registration: $e');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
