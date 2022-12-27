import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/views/main_page.dart';
import 'package:flutter_front/views/login_page.dart';
import 'package:flutter_front/views/profile_page.dart';
import 'package:page_transition/page_transition.dart';

void main() async {

  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(   //Loading Screen when the App is first launched
          splash: Image.asset('assets/OnlySells.png'),
          splashIconSize: 1000,
          duration: 3000,
          nextScreen: const ProfilePage(),
        )
      ));
}