import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:unity/constants.dart';
import 'package:unity/models/session.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) async {
    final staticMapImageUrl = await LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          initialLocation: SessionLocation(
              latitude: locData.latitude, longitude: locData.longitude),
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: uDefaultMargin),
      child: Column(
        children: <Widget>[
          Text(
            'Where?', // DoTranslate
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 10),
          if (_previewImageUrl != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: uDefaultPadding),
              // padding: EdgeInsets.symmetric(horizontal: uDefaultPadding),
              height: 170,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: Theme.of(context).primaryColor),
              ),
              child: Image.network(
                _previewImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          SizedBox(height: 10),
          InkWell(
            splashColor: Theme.of(context).primaryColor,
            onTap: _selectOnMap,
            child: Container(
              padding: EdgeInsets.all(uDefaultPadding),
              margin: EdgeInsets.symmetric(horizontal: uDefaultMargin),
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(width: 1, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(uDefaultBorderRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 20,
                  ),
                  SizedBox(width: 5),
                  Flexible(
                      child: Text(
                    'Select on Map',
                    textAlign: TextAlign.center,
                  )), // DoTranslate
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
