import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_front/views/auth/login_page.dart';
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

  Future fetchUserData () async {
    var userPref = await getPreferences();

    return userPref;
  }

  @override
  void initState() {
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.grey[300],
            icon: Icon(Icons.person),
            itemBuilder: (BuildContext context) => <PopupMenuEntry> [
              PopupMenuItem(
                onTap: () async {
                  final pref = await SharedPreferences.getInstance();

                  pref.remove('loggedIn');
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>LoginPage()));
                },
                child: Row(children: [
                  Icon(Icons.logout, color: Colors.black),
                  Text("Log Out")
                ],))
            ],
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {

            if(snapshot.hasError) {
              return RefreshIndicator(
                  onRefresh: () async {
                    userData = await fetchUserData();
                    setState(() {
                      userData;
                    });
                  },
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: const Icon(Icons.error_outline,
                                size: 100,
                                color: Colors.redAccent
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Database Error: Problem Fetching Data",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  height: 1.5,
                                  fontSize: 20
                              ),),
                          )
                        ],
                      ),
                    ),
                  ),
              );
            }
            if(snapshot.hasData) {

              userData.isEmpty ? userData = snapshot.data! : null;

              return Padding(
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
                                left: 120,
                                bottom: 20,
                                child: CircleAvatar(
                                  child: IconButton(
                                    onPressed: () {

                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                )),
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
              );
            }
          }
          return const Center(
            child: Text("Loading"),
            // child: CircularProgressIndicator(
            //   valueColor: colorTween,
            // )
          );
        },
      )
    );
  }
}
