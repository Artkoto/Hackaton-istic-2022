import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> sendNotification(title,body) async{

  var postUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

  final data = {
    "notification": {"title": title, "body": body},
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "sound": 'default',
      "screen": "all",
    },
    "to": "/topics/all"
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': 'key=AAAAHLJuyQk:APA91bGwy-dmJzSiOvRzT0TzDqVwpwD73KjmEBi52kTR8AfVfVMOXw36oJNVLUMa_dUOqLO78hdsHoBvYN4MUaPYyo2Xb4FzLwAVHJUnWebXs-qaK2GVaWuSWnrU5KiEmrd74pbgoZk3'

  };

  final response = await http.post(postUrl,
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
// on success do
    print("true");
  } else {
// on failure do
    print("false");

  }
}