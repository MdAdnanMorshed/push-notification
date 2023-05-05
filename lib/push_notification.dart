import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'notification_helper.dart';

class PushNotification extends StatefulWidget {
  const PushNotification({Key? key}) : super(key: key);

  @override
  State<PushNotification> createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {

  NotificationHelper notificationHelper= NotificationHelper();
  @override
  void initState() {
    // TODO: implement initState
   notificationHelper.requestNotificationPermission();
   notificationHelper.getDeviceToken().then((value) {
     print('Get Device Token : $value');
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notification'),
      ),
    );
  }
}
