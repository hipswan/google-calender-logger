import 'dart:convert';
import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CalenderApi {
  static Future<http.Response> setCalender(
    String url, {
    GoogleSignInAccount user,
    DateTime startDate,
    DateTime endDate,
    String summary = '',
    String location = '',
    String discription = 'Lorem Ipsum',
  }) async {
    log('Network ${DateTime(2020, 10, 30, 09, 30).toString()}');
    final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    log('Network : ${formatter.format(DateTime(2020, 10, 30, 09, 30))}');
    http.Response response = await http.post(url,
        body: jsonEncode({
          'summary': summary,
          'location': location,
          'description': discription,
          'start': {
            'dateTime': formatter.format(startDate),
            'timeZone': 'Asia/Kolkata'
          },
          'end': {
            'dateTime': formatter.format(endDate),
            'timeZone': 'Asia/Kolkata'
          },
          'reminders': {
            'useDefault': false,
            'overrides': [
              {'method': 'popup', 'minutes': 60}
            ]
          }
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': (await user.authHeaders)['Authorization'],
          'X-Goog-AuthUser': (await user.authHeaders)['X-Goog-AuthUser']
        });
    log('Network : ${response.statusCode}');
    log('Network : ${response.body}');

    return response;
  }
}
