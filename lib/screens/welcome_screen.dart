import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:unity/constants.dart';
import 'package:unity/screens/login_screen.dart';
import 'package:unity/screens/signup_screen.dart';
import 'package:unity/widgets/background.dart';
import 'package:unity/widgets/unity_title.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Padding(
            padding: const EdgeInsets.all(uDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UnityTitle(),
                SizedBox(height: 30),
                Container(
                  height: 80,
                  child: Marquee(
                    text:
                        'Meditation - Health - Awareness - Yoga - Wim Hof - Mindfulnes - Relaxation - Breathing - Healing - Teaching - Mind, Body & Soul - ',
                    velocity: 20,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Together',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 10.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          elevation: uDefaultElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(uDefaultBorderRadius),
                          ),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(LoginScreen.routeName),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                    SizedBox(
                      width: uDefaultPadding,
                    ),
                    Expanded(
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          elevation: uDefaultElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(uDefaultBorderRadius),
                          ),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(SignupScreen.routeName),
                          child:
                              Text('Sign Up', style: TextStyle(fontSize: 18))),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
