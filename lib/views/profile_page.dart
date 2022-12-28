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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        leading: IconButton(
          onPressed: (){
          }, 
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 5,
                            color: Colors.white
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 3,
                              blurRadius: 10,
                              color: Colors.blue.withOpacity(0.1)
                            )
                          ],
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            fit: BoxFit.fill, 
                            image: NetworkImage(
                              'https://i.mydramalist.com/27Z1Rc.jpg'
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
                        ),
                        color: Colors.blue.shade200,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: (){

                          }, 
                          icon: const Icon(Icons.edit),
                          iconSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
    );
  }
}
