import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:calender_logger/reusable_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'constants.dart';
import 'network.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'https://www.googleapis.com/auth/calendar',
    'https://www.googleapis.com/auth/calendar.events'
  ],
  clientId:
      '682182716144-f23vg25hnjnf8oqjk0dam56idqsp412i.apps.googleusercontent.com',
);
final DateTime timestamp = DateTime.now();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(days: 1));
  TextEditingController _titleDetail;
  TextEditingController _discriptionDetail;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAuth = false;
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    _titleDetail = TextEditingController();
    _discriptionDetail = TextEditingController();
    super.initState();

    // Detects when user signed in
    // googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   print('runnn');
    //   setState(() {
    //     _currentUser = account;
    //   });
    //   handleSignIn(account);
    // }, onError: (err) {
    //   print('Error signing in: $err');
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _titleDetail.dispose();
    _discriptionDetail.dispose();
  }

  // Future<void> sendCalenderEvent() async {
  //   log((await _currentUser.authHeaders).toString());
  //   log((await _currentUser.authentication).toString());
  //   log('https://www.googleapis.com/calendar/v3/calendars/primary/events?key=AIzaSyCPNSttW2_pBOr9h2LzIgTi85aWpWEqMkc');

  //   // final http.Response response = await http.post(
  //   //   'https://www.googleapis.com/calendar/v3/calendars/primary/events?key=AIzaSyCPNSttW2_pBOr9h2LzIgTi85aWpWEqMkc',
  //   //   body: jsonEncode({
  //   //     'summary': 'Google I/O 2015',
  //   //     'location': '800 Howard St., San Francisco, CA 94103',
  //   //     'description':
  //   //         'A chance to hear more about Google\'s developer products.',
  //   //     'start': {
  //   //       'dateTime': '2020-10-30T09:00:00+05:30',
  //   //       'timeZone': 'Asia/Kolkata'
  //   //     },
  //   //     'end': {
  //   //       'dateTime': '2020-10-31T17:00:00+05:30',
  //   //       'timeZone': 'Asia/Kolkata'
  //   //     },
  //   //     'recurrence': ['RRULE:FREQ=DAILY;COUNT=2'],
  //   //     'attendees': [
  //   //       {'email': 'lpage@example.com'},
  //   //       {'email': 'sbrin@example.com'}
  //   //     ],
  //   //     'reminders': {
  //   //       'useDefault': false,
  //   //       'overrides': [
  //   //         {'method': 'email', 'minutes': 24 * 60},
  //   //         {'method': 'popup', 'minutes': 10}
  //   //       ]
  //   //     }
  //   //   }),
  //   //   headers: {
  //   //     'Accept': 'application/json',
  //   //     'Content-Type': 'application/json',
  //   //     'Authorization': (await _currentUser.authHeaders)['Authorization'],
  //   //     'X-Goog-AuthUser': (await _currentUser.authHeaders)['X-Goog-AuthUser']
  //   //   },
  //   // );
  //   // log(response.statusCode.toString());
  //   // if (response.statusCode == 200) {
  //   //   log(response.body);
  //   // }
  // }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      print('User logged in as $account');
      final GoogleSignInAccount user = googleSignIn.currentUser;
      log(account.id);
    }
  }

  logout() {
    googleSignIn.signOut();
  }

  Scaffold buildAuthScreen(context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Google Event Logger'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ReusableCard(
                colour: kCardColour,
                cardChild: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _titleDetail,
                        minLines: 1,
                        maxLines: 5,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          // hintText: 'Write your title here',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.greenAccent),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _discriptionDetail,
                        minLines: 5,
                        maxLines: 10,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          // hintText: 'Write your title here',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.greenAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ReusableCard(
                colour: kCardColour,
                cardChild: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        "${startTime.toLocal()}".split(' ')[0],
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${startTime.toLocal()}".split(' ')[1].substring(0, 8),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        onPressed: () => DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2019, 3, 5),
                            maxTime: DateTime(2200, 6, 7), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          setState(() {
                            this.startTime = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en),
                        child: Text(
                          'Select Start Date',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.greenAccent,
                      ),
                    ],
                  ),
                ),
              ),
              ReusableCard(
                colour: kCardColour,
                cardChild: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        "${endTime.toLocal()}".split(' ')[0],
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${endTime.toLocal()}".split(' ')[1].substring(0, 8),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        onPressed: () => DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2019, 3, 5),
                            maxTime: DateTime(2200, 6, 7), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          setState(() {
                            this.endTime = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en),
                        child: Text(
                          'Select End Date',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.greenAccent,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  //log('add event pressed');
                  try {
                    GoogleSignInAccount _currentUser =
                        await googleSignIn.signIn();

                    http.Response response = await CalenderApi.setCalender(
                      'https://www.googleapis.com/calendar/v3/calendars/primary/events?key=AIzaSyCPNSttW2_pBOr9h2LzIgTi85aWpWEqMkc',
                      user: _currentUser,
                      startDate: startTime,
                      endDate: endTime,
                      summary: _titleDetail.text,
                      discription: _discriptionDetail.text,
                    );
                    var jsonResponse = jsonDecode(response.body);
                    if (response.statusCode == 200) {
                      SnackBar snackbar =
                          SnackBar(content: Text("Event Successfully Added"));
                      _scaffoldKey.currentState.showSnackBar(snackbar);
                      _titleDetail.clear();
                      _discriptionDetail.clear();
                      setState(() {
                        startTime = DateTime.now();
                        endTime = DateTime.now().add(Duration(days: 1));
                      });
                    } else {
                      SnackBar snackbar = SnackBar(
                          content: Text(
                              '${jsonResponse['error']['errors'][0]['message']}'));
                      _scaffoldKey.currentState.showSnackBar(snackbar);
                    }
                    await googleSignIn.signOut();
                  } on Exception catch (_) {
                    SnackBar snackbar =
                        SnackBar(content: Text("Error Occured"));
                    _scaffoldKey.currentState.showSnackBar(snackbar);
                  }
                },
                child: Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Insert Event',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: logout,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen(context);
  }
}
