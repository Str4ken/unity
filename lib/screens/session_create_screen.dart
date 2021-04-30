import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/constants.dart';
import 'package:unity/helpers/location_helper.dart';
import 'package:unity/models/session.dart';
import 'package:unity/providers/current_user.dart';
import 'package:unity/providers/sessions.dart';
import 'package:unity/widgets/background.dart';
import 'package:unity/widgets/location_input.dart';
import 'package:unity/widgets/my_light_card.dart';
import 'package:unity/widgets/tags.dart';

class SessionCreateScreen extends StatefulWidget {
  static const routeName = '/create';

  @override
  _SessionCreateScreenState createState() => _SessionCreateScreenState();
}

class _SessionCreateScreenState extends State<SessionCreateScreen> {
  SessionLocation _pickedLocation;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay _pickedTime;
  String _todayOrTommorow;
  bool _inPast = false;
  final auth = FirebaseAuth.instance;
  UnityUser unityUser;
  CurrentUser currentUser;
  List<Tag> tags = [];

  @override
  void didChangeDependencies() {
    currentUser = Provider.of<CurrentUser>(context);
    unityUser = currentUser.user;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Announce a session'),
          // DoTranslate
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check_circle_outlined),
              onPressed: _saveSession,
            ),
          ],
        ),
        body: Stack(
          children: [
            Background(),
            // Unfocuses when tapping out of textField or when scrolling
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTitleInput(context),
                    buildDescriptionInput(context),
                    MyLightCard(child: TagsInput(tags)),
                    MyLightCard(child: LocationInput(_selectPlace)),
                    buildTimeInput(context),
                    SizedBox(height: 10),
                    RaisedButton.icon(
                      icon: Icon(Icons.check_circle_outlined),
                      label: Text('Announce Session'), // DoTranslate
                      onPressed: _saveSession,
                      elevation: uDefaultElevation,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(uDefaultBorderRadius),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildTitleInput(BuildContext context) {
    return MyLightCard(
      child: Container(
        margin: EdgeInsets.all(uDefaultMargin),
        child: Column(
          children: [
            Text(
              'Title',
              style: Theme.of(context).textTheme.headline6,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Give your session a title', // DoTranslate
                  hintText: 'Breathing meditation'), // DoTranslate
              controller: _titleController,
              minLines: 1,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDescriptionInput(BuildContext context) {
    return MyLightCard(
      child: Container(
        margin: EdgeInsets.all(uDefaultMargin),
        child: Column(
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.headline6,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText:
                      'Describe your session... (optional)', // DoTranslate
                  hintText:
                      'Breathing mediation followed by a short yoga routine.\nI would advise to bring a mat and a seat cushion.\nFeel free to join :)'), // DoTranslate
              controller: _descriptionController,
              minLines: 1,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimeInput(BuildContext context) {
    return MyLightCard(
      child: Container(
        margin: EdgeInsets.only(top: uDefaultMargin),
        child: Column(
          children: [
            Text(
              'When?', // DoTranslate
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColor,
                    onTap: () {
                      setState(() {
                        _todayOrTommorow = 'today';
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(uDefaultPadding),
                      margin: EdgeInsets.symmetric(horizontal: uDefaultMargin),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(uDefaultBorderRadius),
                          border: Border.all(
                              width: 1, color: Theme.of(context).primaryColor),
                          color: _todayOrTommorow == 'today'
                              ? Theme.of(context).primaryColor
                              : Colors.white),
                      child: Text('Today'), // DoTranslate
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColor,
                    onTap: () {
                      setState(() {
                        _todayOrTommorow = 'tommorow';
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(uDefaultPadding),
                      margin: EdgeInsets.symmetric(horizontal: uDefaultMargin),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Theme.of(context).primaryColor),
                          borderRadius:
                              BorderRadius.circular(uDefaultBorderRadius),
                          color: _todayOrTommorow == 'tommorow'
                              ? Theme.of(context).primaryColor
                              : Colors.white),
                      child: Text('Tommorow'), // DoTranslate
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              onTap: () async {
                TimeOfDay selectedTime = await showTimePicker(
                  cancelText: 'Cancel'.toUpperCase(), // DoTranslate
                  confirmText: 'OK'.toUpperCase(), // DoTranslate
                  helpText: 'Select Time'.toUpperCase(), // DoTranslate
                  initialTime: TimeOfDay.now(),
                  context: context,
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child,
                    );
                  },
                );
                if (selectedTime != null) {
                  setState(() {
                    _pickedTime = selectedTime;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(uDefaultPadding),
                margin: EdgeInsets.all(uDefaultMargin),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(uDefaultBorderRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 15,
                    ),
                    SizedBox(width: 20),
                    _pickedTime == null
                        ? Text('Choose Time') // DoTranslate
                        : Text('${_pickedTime.format(context)}'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = SessionLocation(latitude: lat, longitude: lng);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(
                Icons.help_outline,
                size: 40,
              ),
              Text('Missing Information'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (_titleController.text.isEmpty)
                  Text('Fill out the session title!\n'), // DoTranslate
                // if (_descriptionController.text.isEmpty)
                //   Text('Fill out the session description!\n'), // DoTranslate
                if (_pickedLocation == null)
                  Text('Choose a location for your session!\n'), // DoTranslate
                if (_todayOrTommorow == null)
                  Text('Choose a date for your session!\n'), // DoTranslate
                if (_pickedTime == null)
                  Text('Choose a time for your session!\n'), // DoTranslate
                if (_inPast)
                  Text(
                      'Your choosen time must not be in the past!\n'), // DoTranslate
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveSession() async {
    print(' _saveSession');
    if (_todayOrTommorow == 'today' && _pickedTime != null) {
      TimeOfDay nowTime = TimeOfDay.now();
      double _doublePickedTime =
          _pickedTime.hour.toDouble() + (_pickedTime.minute.toDouble() / 60);
      double _doubleNowTime =
          nowTime.hour.toDouble() + (nowTime.minute.toDouble() / 60);

      double _timeDiff = _doublePickedTime - _doubleNowTime;
      // This has a tolerance of around 3 minutes
      if (_timeDiff < -0.05) {
        _inPast = true;
      } else {
        _inPast = false;
      }
    }
    if (_titleController.text.isEmpty ||
        _pickedLocation == null ||
        _todayOrTommorow == null ||
        _pickedTime == null ||
        _inPast) {
      _showMyDialog();

      return;
    }
    // final _address = await LocationHelper.getPlaceAddress(
    //     _pickedLocation.latitude, _pickedLocation.longitude);
    final _locationToSave = SessionLocation(
      latitude: _pickedLocation.latitude,
      longitude: _pickedLocation.longitude,
      // address: _address,
    );
    final now = DateTime.now();
    DateTime _dateTimeToSave = DateTime(
        now.year, now.month, now.day, _pickedTime.hour, _pickedTime.minute);
    if (_todayOrTommorow == 'tommorow') {
      _dateTimeToSave = _dateTimeToSave.add(Duration(days: 1));
    }
    Session newSession = Session(
        creator: unityUser.docId,
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: _dateTimeToSave,
        location: _locationToSave,
        tags: tags);
    Provider.of<Sessions>(context, listen: false).addSession(newSession);
    Navigator.of(context).pop();
  }
}
