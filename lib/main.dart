import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/constants.dart';
import 'package:unity/providers/sessions.dart';
import 'package:unity/routes.dart';
import 'package:unity/screens/home_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unity/screens/welcome_screen.dart';
import 'package:unity/widgets/startup.dart';

import 'providers/current_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Sessions()),
        ChangeNotifierProvider(create: (_) => CurrentUser()),
      ],
      child: MaterialApp(
        title: 'unity',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: uBackgroundColor1,
          primaryColor: uPrimaryColor,
          brightness: Brightness.light,
          // primarySwatch: Colors.amber,
          accentColor: uBackgroundColor2,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: uButtonColor,
        ),
        localizationsDelegates: [
          // TODO add and test iOS (https://flutter.dev/docs/development/accessibility-and-localization/internationalization#localizing-for-ios-updating-the-ios-app-bundle)
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('de', ''),
        ],
        routes: routes(context),
        home: Startup(),
      ),
    );
  }
}
