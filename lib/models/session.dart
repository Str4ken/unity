import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unity/widgets/tags.dart';

class SessionLocation {
  final double latitude;
  final double longitude;
  final String address; // TODO Is the address actually needed?

  const SessionLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      };

  factory SessionLocation.fromMap(Map data) {
    data = data ?? {};
    return SessionLocation(
      latitude: data['latitude'] ?? 30.0,
      longitude: data['longitude'] ?? 30.0,
      address: data['address'] ?? 'default_address',
    );
  }
}

class Comment {
  final String text;
  final String creator;
  final DateTime dateTime;

  Comment(
      {@required this.text, @required this.creator, @required this.dateTime});

  factory Comment.fromMap(Map data) {
    data = data ?? {};
    return Comment(
      text: data['text'] ?? 'No Text found',
      creator: data['creator'] ?? 'No Text found',
      dateTime: data['dateTime'].toDate() ?? DateTime.now(),
    );
  }
}

class Session {
  final String creator;
  final String title;
  final String description;
  final SessionLocation location;
  final DateTime dateTime;
  String id;
  double distance;
  List participants = [];
  List<Tag> tags = [];
  List<Comment> comments = [];

  Session(
      {@required this.creator,
      @required this.title,
      @required this.description,
      @required this.dateTime,
      @required this.location,
      this.id,
      this.participants,
      this.tags,
      this.comments,
      this.distance});

  @override
  String toString() => "Session<$description>";

  Map<String, dynamic> toJson() => {
        'creator': creator,
        'title': title,
        'description': description,
        'dateTime': dateTime,
        'location': location.toJson(),
        'participants': participants,
        'tags': tags.map((tag) => tag.title).toList(),
        'comments': comments,
      };

  factory Session.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Session(
      id: doc.id,
      creator: data['creator'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dateTime: data['dateTime'].toDate() ?? DateTime.now(),
      location: SessionLocation.fromMap(data['location']) ?? {},
      participants: data['participants'] ?? [],
      comments: data['comments'] ?? [], // TODO not working yet
    );
  }
}
