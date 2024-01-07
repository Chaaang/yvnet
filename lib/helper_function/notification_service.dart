import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackGroundMessage(RemoteMessage message) async{
  print('TESTING');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}


class NotificationServices{
  FirebaseMessaging _firebaseMessaging= FirebaseMessaging.instance;

  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();


  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notification',
    description: 'This channel is used for important notification',
    importance: Importance.defaultImportance
  );


Future initLocationNotification() async{
  //const IOS = IOSInitializationSettings();
  //const android = AndroidInitializationSettings();
  const settings = InitializationSettings();

  await _localNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (details) {
      print(details);
    },
    onDidReceiveBackgroundNotificationResponse: (details) {
      print(details);
    },
  );

  final platform = _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  await platform?.createNotificationChannel(_androidChannel);
}


  Future<void> initNotifications()async{
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('Token: $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if(notification == null) return;

      _localNotificationsPlugin.show(
        notification.hashCode, 
        notification.title, 
        notification.body, 
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id, 
            _androidChannel.name,
            channelDescription: _androidChannel.description,

            )
        ),
        payload: jsonEncode(message.toMap()),
        );
    });
    //initLocationNotification();
  }

  // Future<void> requestPermission() async{

  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true
  //   );

  //   if(settings.authorizationStatus == AuthorizationStatus.authorized){
  //     print('User granted Permission');
  //   }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
  //     print('User granted provisional Permission');
  //   }else{
  //     print('Permission declined');
  //   }
  // }


  // void getDeviceToken() async{
  //    await messaging.getToken().then((value) {
  //     SaveToken(value!);
  //     print('Token: $value');
  //   } );
    
      
  // }

  // void SaveToken(String token) async{
  //   await FirebaseFirestore.instance.collection('Users').doc('chang@gmail.com').update({
  //     'token': token
  //   });
  // }
  
}