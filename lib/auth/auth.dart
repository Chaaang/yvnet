import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yvnet/auth/login_or_register.dart';
import 'package:yvnet/screens/home_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return  const HomePage();
            // return AnimatedSplashScreen(
            //   splash: 'Images/logo.png', 
            //   nextScreen: HomePage(),
            //   splashTransition: SplashTransition.fadeTransition,);            
          }else{
            return const LoginOrRegister();
            // return AnimatedSplashScreen(
            //   splash: 'Images/logo.png', 
            //   nextScreen: LoginOrRegister(),
            //   splashTransition: SplashTransition.fadeTransition,);
          }
        },
      ),
    );
  }
}