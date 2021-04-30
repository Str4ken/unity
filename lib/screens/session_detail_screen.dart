import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:unity/constants.dart';
import 'package:unity/helpers/extensions.dart';
import 'package:unity/helpers/location_helper.dart';
import 'package:unity/models/session.dart';
import 'package:unity/providers/current_user.dart';
import 'package:unity/providers/sessions.dart';
import 'package:unity/widgets/background.dart';
import 'package:unity/widgets/my_light_card.dart';

class SessionDetailScreen extends StatefulWidget {
  static const routeName = '/detail';

  @override
  _SessionDetailScreenState createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  Session session;
  String _previewImageUrl;
  User firebaseUser = FirebaseAuth.instance.currentUser;
  UnityUser unityUser;
  CurrentUser currentUser;

  @override
  void didChangeDependencies() {
    final sessionId = ModalRoute.of(context).settings.arguments as String;
    session = Provider.of<Sessions>(
      context,
      listen: false,
    ).findById(sessionId);
    currentUser = Provider.of<CurrentUser>(context);
    unityUser = currentUser.user;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    _showPreview(session.location.latitude, session.location.longitude);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Background(),
          MyLightCard(
              child: Container(
            padding: EdgeInsets.all(uDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 40,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  session.dateTime.isSameDate(DateTime.now())
                                      ? Text(
                                          'Today',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        )
                                      : Text(
                                          'Tommorow',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                  Text(
                                    '${DateFormat('kk:mm').format(session.dateTime)}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    if (_previewImageUrl != null)
                      Expanded(
                        child: GestureDetector(
                          onTap: _launchGoogleMapsURL,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).primaryColor),
                                ),
                                child: Image.network(
                                  _previewImageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.map),
                                  Flexible(
                                      child: Text(
                                    'Check on Maps',
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                        height: deviceSize.height * 0.5,
                        child: Text(
                          session.description,
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group),
                    SizedBox(width: 10),
                    session.participants.length > 1
                        ? Text('${session.participants.length} Participants')
                        : Text('${session.participants.length} Participant')
                  ],
                ),
                RaisedButton.icon(
                  // icon: Icon(Icons.check_circle_outlined),
                  icon: Icon(Icons.person_add),
                  label: Text('Participate Session'), // DoTranslate
                  onPressed: _participate,
                  elevation: uDefaultElevation,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(uDefaultBorderRadius),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _showPreview(double lat, double lng) async {
    try {
      final staticMapImageUrl =
          await LocationHelper.generateLocationPreviewImage(
        latitude: lat,
        longitude: lng,
      );
      setState(() {
        _previewImageUrl = staticMapImageUrl;
      });
    } catch (e) {
      print(e);
    }
  }

  _launchGoogleMapsURL() async {
    final url =
        'http://www.google.com/maps/place/${session.location.latitude},${session.location.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _participate() {
    Provider.of<Sessions>(context, listen: false)
        .addPartcipant(session.id, unityUser.docId);
    currentUser.addSession(session.id);
  }
}
