import 'package:flutter/material.dart';
import 'package:unity/screens/ask_name_screen.dart';
import 'package:unity/screens/login_screen.dart';
import 'package:unity/screens/session_create_screen.dart';
import 'package:unity/screens/home_screen.dart';
import 'package:unity/screens/session_detail_screen.dart';
import 'package:unity/screens/sessions_list_screen.dart';
import 'package:unity/screens/signup_screen.dart';
import 'package:unity/screens/welcome_screen.dart';
import 'package:unity/widgets/startup.dart';

Map routes(BuildContext ctx) {
  return <String, WidgetBuilder>{
    Startup.routeName: (ctx) => Startup(),
    HomeScreen.routeName: (ctx) => HomeScreen(),
    SessionCreateScreen.routeName: (ctx) => SessionCreateScreen(),
    SessionsListScreen.routeName: (ctx) => SessionsListScreen(),
    SessionDetailScreen.routeName: (ctx) => SessionDetailScreen(),
    WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
    LoginScreen.routeName: (ctx) => LoginScreen(),
    SignupScreen.routeName: (ctx) => SignupScreen(),
    AskNameScreen.routeName: (ctx) => AskNameScreen(),
  };
}
