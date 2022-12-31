import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 280;
  
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height * 0.3,
                color: Colors.red,
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Text("Oh Se Hun",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Email Address:",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("ohsehun@gmail.com",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Home Address:",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Seoul, South Korea",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Mobile Number:",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("010-6303-3087",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
