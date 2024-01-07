import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yvnet/auth/auth.dart';
import 'package:yvnet/firebase_options.dart';
import 'package:yvnet/theme/light_mode.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // NotificationServices().initNotifications();
  // NotificationServices().initLocationNotification();
  //await FirebaseMessaging.instance.getInitialMessage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
    );
  }

}
