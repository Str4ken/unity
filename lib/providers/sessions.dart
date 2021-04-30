import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:unity/models/session.dart';

class Sessions with ChangeNotifier {
  CollectionReference sessionsFS =
      FirebaseFirestore.instance.collection('sessions');
  LocationData _currentUserLocation;
  List<Session> _items = [];

  List<Session> get items {
    return [..._items];
  }

  Session findById(String id) {
    return _items.firstWhere((session) => session.id == id);
  }

  Future<void> addSession(Session session) async {
    _items.add(session);
    notifyListeners();
    sessionsFS
        .add(session.toJson())
        .then((value) => print("Session added"))
        .catchError((error) => print("Failed to add session: $error"));
  }

  Future<void> fetchAndSetSessions({double maxDistance = 10000.0}) async {
    DateTime now = DateTime.now().subtract(Duration(hours: 2));
    final dataList =
        await sessionsFS.where('dateTime', isGreaterThan: now).get();
    await _getCurrentUserLocation();
    // TODO: Make location filter logic server side, e.g. https://pub.dev/packages/geoflutterfire
    _items = dataList.docs.map((doc) => Session.fromFirestore(doc)).toList();
    _items.forEach((session) {
      session.distance = Geolocator.distanceBetween(
          session.location.latitude,
          session.location.longitude,
          _currentUserLocation.latitude,
          _currentUserLocation.longitude);
    });
    _items.removeWhere((session) => maxDistance < session.distance);
    notifyListeners();
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      _currentUserLocation = await Location().getLocation();
    } catch (error) {
      print(error);
      return;
    }
  }

  Future<void> addPartcipant(String sessionId, String currentUserId) async {
    final sessionIndex =
        _items.indexWhere((session) => session.id == sessionId);
    if (sessionIndex >= 0) {
      _items[sessionIndex].participants.add(currentUserId);
      sessionsFS
          .doc(sessionId)
          .update({'participants': _items[sessionIndex].participants});
      notifyListeners();
    } else {
      print('Session $sessionId not found. Can not add participant!'); // DoLog
    }
  }

  getSessionsOfUnityUser(String unityUserId) {
    _items.where((session) =>
        session.participants.contains(unityUserId) ||
        session.creator == unityUserId);
  }
}
