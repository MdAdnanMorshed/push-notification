import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User  granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User  granted permission Provisional');
    } else {
      AppSettings.openNotificationSettings();
      print('User  denied permission');
    }
  }

  void initLocalNotifications(BuildContext context,RemoteMessage message) {

    var initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings()
    );

    _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            (backgroundNotificationResponse) {},
        onDidReceiveNotificationResponse: (notificationResponse) {
          handleMessage(context,message);
        });
  }

  void showNotification(RemoteMessage message) {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(), '',
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(),
            channel.name.toString(),
            channelDescription: ' ',
            importance: Importance.high,
            priority:  Priority.high,
            ticker: 'Ticker');
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails (
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
      print('Notification title : ${message.notification!.title.toString()}');
      print('Notification body : ${message.notification!.body.toString()}');
      initLocalNotifications(context,message);
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print('NotificationHelper.getDeviceToken >> $token');
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      print('event $event');
    });
  }

  void handleMessage(BuildContext context,RemoteMessage message){

  }

}
