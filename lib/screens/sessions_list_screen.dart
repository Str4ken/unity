import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:unity/constants.dart';
import 'package:unity/providers/sessions.dart';
import 'package:unity/screens/session_create_screen.dart';
import 'package:unity/screens/session_detail_screen.dart';
import 'package:unity/widgets/background.dart';
import 'package:unity/widgets/my_light_card.dart';

class SessionsListScreen extends StatefulWidget {
  static const routeName = '/list';

  @override
  _SessionsListScreenState createState() => _SessionsListScreenState();
}

class _SessionsListScreenState extends State<SessionsListScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double _currentSliderValue = 10;
    return Scaffold(
      appBar: AppBar(title: Text('Find your session')),
      body: FutureBuilder(
          future: Provider.of<Sessions>(context, listen: false)
              .fetchAndSetSessions(),
          builder: (context, snapshot) => snapshot.connectionState !=
                  ConnectionState.done
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Sessions>(
                  child: Stack(
                    children: [
                      Background(),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(uDefaultPadding),
                              child: Text('No Sessions near you.'),
                            ),
                            RaisedButton.icon(
                              icon: Icon(Icons.add),
                              label: Text('Announce Session'), // DoTranslate
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(SessionCreateScreen.routeName),
                              elevation: uDefaultElevation,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(uDefaultBorderRadius),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  builder: (context, sessions, child) =>
                      sessions.items.length <= 0
                          ? child
                          : Stack(
                              children: [
                                Background(),
                                Column(
                                  children: [
                                    Text(
                                        'Maximum distance: ${_currentSliderValue.round().toString()} km'),
                                    Slider(
                                      value: _currentSliderValue,
                                      min: 1,
                                      max: 100,
                                      divisions: 20,
                                      label: _currentSliderValue
                                              .round()
                                              .toString() +
                                          ' km',
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      inactiveColor: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(123),
                                      onChanged: (double value) {
                                        setState(() {
                                          _currentSliderValue = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  itemCount: sessions.items.length,
                                  itemBuilder: (context, index) {
                                    DateTime dateTime =
                                        sessions.items[index].dateTime;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          SessionDetailScreen.routeName,
                                          arguments: sessions.items[index].id,
                                        );
                                      },
                                      child: MyLightCard(
                                        child: ListTile(
                                          title: Text(
                                            sessions.items[index].description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          leading: Text(
                                              '${DateFormat('kk:mm').format(dateTime)}'),
                                          trailing: Text(
                                              '${(sessions.items[index].distance / 1000).toStringAsFixed(1)} km'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                )),
    );
  }
}
