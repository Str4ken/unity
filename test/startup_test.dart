import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:unity/main.dart';
import 'mock.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  NavigatorObserver mockObserver;
  setupFirebaseAuthMocks();
  mockObserver = MockNavigatorObserver();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Start Up', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pump(Duration(seconds: 2));

    // Verify WelcomeScreen.
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Unity'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    // Tests to write

    // await tester.tap(find.text('Sign Up'));
    // await tester.pump(Duration(seconds: 1));
    // verify(mockObserver.didPush(any, any));
    // expect(find.text('or'), findsOneWidget);
    // expect(find.text('Registration'), findsOneWidget);
  });
}
