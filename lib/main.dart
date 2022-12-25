import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/views/login_page.dart';
import 'package:flutter_front/views/register_page.dart';

void main() async {

  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        debugShowCheckedModeBanner: false,
        home: RegisterPage()/*AnimatedSplashScreen(
          splash: Image.asset('assets/OnlySells.png'),
          splashIconSize: 1000,
          duration: 4000,
          nextScreen: const LoginPage(),
        )*/
      ));
}