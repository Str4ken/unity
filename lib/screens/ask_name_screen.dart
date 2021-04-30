import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/constants.dart';
import 'package:unity/providers/current_user.dart';
import 'package:unity/screens/home_screen.dart';
import 'package:unity/widgets/background.dart';
import 'package:unity/widgets/my_light_card.dart';
import 'package:unity/widgets/startup.dart';
import 'package:unity/widgets/unity_title.dart';

class AskNameScreen extends StatefulWidget {
  static const routeName = '/askname';

  @override
  _AskNameScreenState createState() => _AskNameScreenState();
}

class _AskNameScreenState extends State<AskNameScreen> {
  String _username;
  String _errorText;

  User user = FirebaseAuth.instance.currentUser;
  CurrentUser currentUser = CurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UnityTitle(),
              MyLightCard(
                child: Padding(
                  padding: const EdgeInsets.all(uDefaultPadding),
                  child: Column(
                    children: [
                      Text(
                        'Who are you?',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'My Nickname',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _username = value;
                          });
                          print(_username);
                        },
                      ),
                      SizedBox(
                        height: uDefaultPadding,
                      ),
                      FlatButton.icon(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(uDefaultBorderRadius),
                        ),
                        onPressed: _submit,
                        icon: Icon(Icons.check),
                        label: Text('That´s me'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() async {
    _errorText = '';
    if (_username.length < 2) {
      _errorText = 'Your Nickname must be at least 2 characters long!';
      return _showErrorDialog(context);
    }
    UnityUser uUser = UnityUser(firesbaseUserId: user.uid, name: _username);
    currentUser.createUnityUser(uUser);
    currentUser.fetchAndSetUser();
    Navigator.pushNamedAndRemoveUntil(
        context, Startup.routeName, (Route<dynamic> route) => false);
  }

  Future _showErrorDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_errorText),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
