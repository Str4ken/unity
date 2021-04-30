import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:unity/constants.dart';
import 'package:unity/providers/current_user.dart';
import 'package:unity/screens/ask_name_screen.dart';
import 'package:unity/screens/login_screen.dart';
import 'package:unity/widgets/background.dart';
import 'package:unity/widgets/my_light_card.dart';
import 'package:unity/widgets/or_divider.dart';
import 'package:unity/widgets/social_icon.dart';
import 'package:unity/widgets/unity_title.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _email, _password;
  String _errorText = '';
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Stack(
        children: [
          Background(),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  UnityTitle(),
                  MyLightCard(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(uDefaultPadding),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(hintText: 'Email'),
                            onChanged: (value) {
                              setState(() {
                                _email = value.trim();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(uDefaultPadding),
                          child: TextField(
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              // labelText: 'Password',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _password = value.trim();
                              });
                            },
                          ),
                        ),
                        FlatButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(uDefaultBorderRadius),
                            ),
                            onPressed: _submit,
                            child: Text('Sign Up'))
                      ],
                    ),
                  ),
                  OrDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocalIcon(
                        iconSrc: "assets/icons/google.svg",
                        press: () {},
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/facebook.svg",
                        press: () {},
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/twitter.svg",
                        press: () {},
                      ),
                      // https://developer.apple.com/design/resources/
                      // SocalIcon(
                      //   iconSrc: "assets/icons/apple.svg",
                      //   press: () {},
                      // ),
                    ],
                  ),
                  OrDivider(),
                  GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName),
                      child: Text(
                        'Already have an account?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submit() async {
    _errorText = '';
    if (_email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(_email)) {
      _errorText = 'Invalid email!';
      return _showErrorDialog(context);
    }
    try {
      await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorText = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _errorText = 'The account already exists for that email.';
      }
    } catch (e) {
      print(e); // DoLog
      _errorText = 'Something went wrong....';
    }
    if (_errorText.isNotEmpty) {
      return _showErrorDialog(context);
    } else {
      Navigator.of(context).pushReplacementNamed(AskNameScreen.routeName);
    }
  }

  Future<void> _showErrorDialog(BuildContext context) {
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
