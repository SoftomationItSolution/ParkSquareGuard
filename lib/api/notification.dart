import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api.dart';

Future<bool> sendNotifications({
  required String fcmToken,
  required String title,
  required String body,
}) async {
  List<Map<String, String>> notifications = [
    {
      "token": fcmToken,
      "title": title,
      "body": body
    },
  ];

  String jsonBody = jsonEncode({"notifications": notifications});
  print("jsonBody, $jsonBody");

  Uri url = Uri.parse('${ApiConfig.baseUrl}api/flutterNotification/send');
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonBody,
  );

  if (response.statusCode == 200) {
    print("Notifications sent successfully");
    return true;
  } else {
    print("Failed to send notifications. Error: ${response.statusCode}");
     print("Response body: ${response.body}"); 
    return false;
  }
}