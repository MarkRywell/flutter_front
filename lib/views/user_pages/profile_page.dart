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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry> [
              PopupMenuItem(
                onTap: () {

                },
                child: Text("Log Out"))
            ],
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                          child: Text("Mark Rywell G. Gaje",
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              )),
                        ))
                  ],
                ),
              ),
              const Divider(thickness: 8, height: 5),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
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
