import 'package:flutter/material.dart';
import 'package:flutter_front/views/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {

  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage()
      ));
}