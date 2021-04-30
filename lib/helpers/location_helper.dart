import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  static Future<String> generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) async {
    final storage = new FlutterSecureStorage();
    String googleMapsApiKey = await storage.read(key: 'google_maps_api_key');
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$googleMapsApiKey';
  }

  // static Future<String> getPlaceAddress(double lat, double lng) async {
  //   final storage = new FlutterSecureStorage();
  //   String googleMapsApiKey = await storage.read(key: 'google_maps_api_key');
  //   final url =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApiKey';
  //   final response = await http.get(Uri.dataFromString(url));
  //   return json.decode(response.body)['results'][0]['formatted_address'];
  // }
}
