import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/views/navigated_pages/main_page.dart';
import 'package:flutter_front/views/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(

        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen())
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool? loggedIn;

  getPreferences () async {

    final pref = await SharedPreferences.getInstance();

    setState(() {
      loggedIn = pref.getBool("loggedIn");
    });

    print(loggedIn);
  }


  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  AnimatedSplashScreen(
      splash: Image.asset('assets/OnlySells.png'),
      splashIconSize: 1000,
      duration: 3000,
      nextScreen: loggedIn == null || loggedIn == false ? const LoginPage() : MainPage(),
    );
  }
}
