import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:unity/providers/current_user.dart';
import 'package:unity/providers/sessions.dart';
import 'package:unity/models/session.dart';
import 'package:unity/widgets/tags.dart';

void main() async {
  // !!!!!!!!!!!!! Careful this will delete database entries!!!!!!!!!!!!!
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Map<String, Map> testUsers = await createTestUsers();
  test('createUsers', () {
    expect(testUsers.length, 3);
  });
  print(testUsers);
  Map sessions = await deleteAndCreateSessions(testUsers);
  print(sessions);
  test('createSessions', () {
    expect(sessions.length, 3);
  });
}

// First clear users collection.
// Create ´countOfUsers´ users, if already created sign in.
// Create a UnityUser in ´users collection´ for each user.
Future<Map> createTestUsers() async {
  int countOfUsers = 3;
  Map<String, Map> testUsers = {};
  UserCredential userCredential;
  String password = 'testtest';
  CollectionReference uUserFS = FirebaseFirestore.instance.collection('users');
  WriteBatch batch = FirebaseFirestore.instance.batch();
  uUserFS.get().then((querySnapshot) {
    querySnapshot.docs.forEach((document) {
      batch.delete(document.reference);
    });
    return batch.commit();
  });

  for (int i = 0; i < countOfUsers; i++) {
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "test${i.toString()}@test.com", password: password);
      testUsers.addAll({
        userCredential.user.uid: {
          'username': userCredential.user.email,
          'password': password,
          'uid': userCredential.user.uid,
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        try {
          userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: "test${i.toString()}@test.com", password: password);
          testUsers.addAll({
            userCredential.user.uid: {
              'username': userCredential.user.email,
              'password': 'SuperSecretPassword!',
              'uid': userCredential.user.uid,
            }
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      }
    } catch (e) {
      print(e);
    }
    UnityUser uUser = UnityUser(
      firesbaseUserId: userCredential.user.uid,
      name: 'name$i',
    );
    await CurrentUser().createUnityUser(uUser);

    final query = await uUserFS
        .where('firesbaseUserId', isEqualTo: userCredential.user.uid)
        .get();
    uUser = UnityUser.fromFirestore(query.docs[0]);
    testUsers[userCredential.user.uid].addAll({'uUser': uUser.toJson()});
  }
  return testUsers;
}

// First clear sessions collection.
// Each created user creates a session.
// Aterwards every user partcitpates in every of the others sessions.
// Future<Map<String, Map>>
deleteAndCreateSessions(Map testUsers) async {
  var rng = new Random();
  CollectionReference sessionFS =
      FirebaseFirestore.instance.collection('sessions');
  WriteBatch batch = FirebaseFirestore.instance.batch();
  sessionFS.get().then((querySnapshot) {
    querySnapshot.docs.forEach((document) {
      batch.delete(document.reference);
    });
    return batch.commit();
  });
  testUsers.forEach((key, value) {
    SessionLocation location = SessionLocation(
        latitude: 48.95 + rng.nextDouble() * 0.1,
        longitude: 12.08 + rng.nextDouble() * 0.1);
    Session session = Session(
        creator: value['uUser']['docId'],
        title: 'Test title',
        description: 'Test Description \n Mit Umbruch und so',
        dateTime: DateTime.now().add(Duration(minutes: rng.nextInt(60 * 47))),
        location: location,
        tags: [Tag('TestTag1'), Tag('TestTag2')]);
    Sessions().addSession(session);
  });
  await Future.delayed(Duration(seconds: 1));
  final createdSessions = await sessionFS.get();
  await Future.delayed(Duration(seconds: 1));
  createdSessions.docs.forEach((doc) {
    Session xSession = Session.fromFirestore(doc);
    print('xSession.id');
    print(xSession.id);
    testUsers.forEach((key, value) {
      if (value['uUser']['docId'] != xSession.creator) {
        sessionFS
            .doc(xSession.id)
            .update({'participants': value['uUser']['docId']});
      }
    });
  });
  return createdSessions;
  // final participatedSessions = await sessionFS.get();
  // return participatedSessions.docs.map((doc) => Session.fromFirestore(doc));
}
