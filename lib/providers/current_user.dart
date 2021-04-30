import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/models/session.dart';
import 'package:unity/providers/sessions.dart';

class UnityUser {
  final String firesbaseUserId;
  final String name;
  final String docId;
  List<String> sessionIds = [];

  UnityUser(
      {this.docId,
      @required this.firesbaseUserId,
      @required this.name,
      this.sessionIds});

  @override
  String toString() => "UnityUser<$name>";

  Map<String, dynamic> toJson() => {
        if (docId != null) 'docId': docId,
        'firesbaseUserId': firesbaseUserId,
        'name': name,
        'sessionIds': sessionIds,
      };

  factory UnityUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data();
    return UnityUser(
      docId: doc.id,
      firesbaseUserId: data['firesbaseUserId'] ?? '',
      name: data['name'] ?? '',
      sessionIds: (data['sessionIds'] ?? []).cast<String>(),
    );
  }
}

class CurrentUser with ChangeNotifier {
  UnityUser _unityUser;
  final auth = FirebaseAuth.instance;
  CollectionReference uUserFS = FirebaseFirestore.instance.collection('users');

  UnityUser get user {
    return _unityUser;
  }

  Future<void> fetchAndSetUser() async {
    // TODO Do not query when already set properly
    // if (auth.currentUser.uid == _unityUser.firesbaseUserId) {
    //   return;
    // }

    final query = await uUserFS
        .where('firesbaseUserId', isEqualTo: auth.currentUser.uid)
        .get();
    _unityUser = UnityUser.fromFirestore(query.docs[0]);
    notifyListeners();
  }

  Future<void> createUnityUser(UnityUser uUser) async {
    uUserFS
        .add(uUser.toJson())
        .then((value) => print("UnityUser added"))
        .catchError((error) => print("Failed to add UnityUser: $error"));
  }

  Future<void> addSession(String sessionId) async {
    _unityUser.sessionIds.add(sessionId);
    await uUserFS
        .doc(_unityUser.docId)
        .update({'sessionIds': _unityUser.sessionIds});
  }

  Session getNextSession(BuildContext context) {
    final sessions = Provider.of<Sessions>(context).items;
    Iterable<Session> possibleSessions = sessions.where((session) =>
        ((session.creator == _unityUser.docId ||
                session.participants.contains(_unityUser.docId)) &&
            session.dateTime.isAfter(DateTime.now())));

    if (possibleSessions.isEmpty) {
      return null;
    }
    possibleSessions.toList().sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return possibleSessions.toList().first;
  }
}
