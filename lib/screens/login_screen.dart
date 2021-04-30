import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unity/constants.dart';
import 'package:unity/screens/ask_name_screen.dart';
import 'package:unity/screens/home_screen.dart';
import 'package:unity/screens/signup_screen.dart';
import 'package:unity/widgets/background.dart';
import 'package:unity/widgets/my_light_card.dart';
import 'package:unity/widgets/or_divider.dart';
import 'package:unity/widgets/social_icon.dart';
import 'package:unity/widgets/startup.dart';
import 'package:unity/widgets/unity_title.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Stack(
          children: [
            Background(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: _login,
                          child: Text('Login'),
                        ),
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
                          .pushReplacementNamed(SignupScreen.routeName),
                      child: Text(
                        'Don`t have an account? Register here!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> _login() async {
    _errorText = '';
    try {
      await auth.signInWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorText = 'No user found for that email.';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _errorText = 'Wrong password provided for that user.';
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e); // DoLog
      _errorText = 'Something went wrong....';
    }
    if (_errorText.isNotEmpty) {
      return _showErrorDialog(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, Startup.routeName, (Route<dynamic> route) => false);
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
