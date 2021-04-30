import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unity/screens/home_screen.dart';
import 'package:unity/widgets/startup.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.logout),
              title: Text('Ausloggen'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, Startup.routeName,
                    (Route<dynamic> route) => false);
              }),
        ],
      ),
    );
  }
}
