import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:unity/constants.dart';
import 'package:unity/models/session.dart';
import 'package:unity/providers/current_user.dart';
import 'package:unity/screens/session_create_screen.dart';
import 'package:unity/screens/sessions_list_screen.dart';
import 'package:unity/widgets/app_drawer.dart';
import 'package:unity/widgets/background.dart';
import 'package:unity/widgets/my_circular_progress_indicator.dart';
import 'package:unity/widgets/my_light_card.dart';
import 'package:unity/helpers/extensions.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CurrentUser>(context).fetchAndSetUser().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final auth = FirebaseAuth.instance;
    // CurrentUser currentUser = Provider.of<CurrentUser>(context);

    return Scaffold(
        appBar: AppBar(),
        drawer: AppDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SessionCreateScreen.routeName);
          },
          backgroundColor: Theme.of(context).buttonColor,
          elevation: uDefaultElevation,
          child: Icon(Icons.add),
        ),
        body: Stack(
          children: [
            Background(),
            _isLoading
                ? MyCircularProgreesInidcator()
                : Consumer<CurrentUser>(
                    builder: (context, user, child) {
                      Session nextSession = user.getNextSession(context);
                      return Container(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Welcome\n${user.user.name}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(shadows: [
                                      Shadow(
                                        offset: Offset(3.0, 3.0),
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                      ),
                                    ]),
                                  ),
                                  SizedBox(height: 20),
                                  if (nextSession != null)
                                    NextSession(nextSession: nextSession),
                                ],
                              ),
                            ),
                            Center(child: SessionFinder()),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ));
  }
}

class NextSession extends StatelessWidget {
  const NextSession({
    Key key,
    @required this.nextSession,
  }) : super(key: key);

  final Session nextSession;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your next session:',
          style: Theme.of(context).textTheme.headline5,
        ),
        MyLightCard(
            child: Container(
                padding: EdgeInsets.all(uDefaultPadding),
                width: double.infinity,
                child: Row(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(nextSession.title),
                        Column(
                          children: [
                            nextSession.dateTime.isSameDate(DateTime.now())
                                ? Text(
                                    'Today',
                                  )
                                : Text(
                                    'Tommorow',
                                  ),
                            Text(
                              '${DateFormat('kk:mm').format(nextSession.dateTime)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ))),
      ],
    );
  }
}

class SessionFinder extends StatefulWidget {
  @override
  _SessionFinderState createState() => _SessionFinderState();
}

class _SessionFinderState extends State<SessionFinder> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return RaisedButton(
      elevation: uDefaultElevation,
      color: Theme.of(context).buttonColor,
      shape: CircleBorder(),
      clipBehavior: Clip.none,
      onPressed: () {
        Navigator.of(context).pushNamed(SessionsListScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(uDefaultPadding),
        child: Icon(
          Icons.search,
          size: deviceSize.width * 0.2,
        ),
      ),
    );
  }
}
