import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:unity/screens/home_screen.dart';
import 'package:unity/screens/welcome_screen.dart';

class Startup extends StatelessWidget {
  static const routeName = '/startup';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: saveSecrets(),
      builder: (context, snapshot) {
        return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.data == null) {
                return WelcomeScreen();
              } else {
                return HomeScreen();
              }
            });
      },
    );
  }

  Future<void> saveSecrets() async {
    final storage = new FlutterSecureStorage();
    rootBundle.loadStructuredData('secrets.json', (jsonStr) async {
      await storage.write(
          key: 'google_maps_api_key',
          value: json.decode(jsonStr)['google_maps_api_key']);
    });
  }
}
