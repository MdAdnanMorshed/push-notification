
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper{

  FirebaseMessaging messaging=FirebaseMessaging.instance;

  void requestNotificationPermission()async{
    NotificationSettings settings= await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print('User  granted permission');
    }else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      print('User  granted permission Provisional');
    }else{
       AppSettings.openNotificationSettings();
      print('User  denied permission');
    }

  }


  Future<String> getDeviceToken()async{
    String? token=await messaging.getToken();
    print('NotificationHelper.getDeviceToken >> $token');
    return token!;
  }
}
