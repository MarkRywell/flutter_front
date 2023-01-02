import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map userData = {};

  getPreferences () async {
    final pref = await SharedPreferences.getInstance();

    Map user = convert.jsonDecode(pref.getString("user")!);

    return user;
  }

  fetchUserData () async {
    userData = await getPreferences();
    setState(() {
      userData;
    });


  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry> [
              PopupMenuItem(
                onTap: () {

                },
                child: const Text("Log Out"))
            ],
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.3,
                child: Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height * 0.2,
                      color: Colors.blue
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.blue.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 180,
                        bottom: 20,
                        child: SizedBox(
                          width: size.width * 0.4,
                          height: 50,
                          child: Text(userData['name'],
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900]
                              )),
                        ))
                  ],
                ),
              ),
              const Divider(thickness: 8, height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                child: GestureDetector(
                    onTap: () {
                      print("Go to Purchases");
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.shopping_bag),
                        SizedBox(width: 10),
                        Text("View Purchases",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),)
                      ],
                    )
                ),
                  ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text("Email Address:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(userData['email'],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text("Home Address:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(userData['address'],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text("Mobile Number:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(userData['contactNo'],
                style: const TextStyle(
                  fontSize: 18,
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
