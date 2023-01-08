import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/views/auth/login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map userData = {};
  File? image;
  String? filePath;

  getPreferences () async {
    final pref = await SharedPreferences.getInstance();

    Map user = convert.jsonDecode(pref.getString("user")!);

    return user;
  }

  Future fetchUserData () async {
    var userPref = await getPreferences();

    return userPref;
  }

  showStatus({required Color color, required String text}) {    // Snackbar to show message of API Response

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(text),
            backgroundColor: color,
            padding: const EdgeInsets.all(15),
            behavior: SnackBarBehavior.fixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )
        )
    );
  }

  Future <ImageSource?> chooseMedia() async {

    var source = await showDialog(
        context: context,
        builder: (BuildContext context) {

          Size size = MediaQuery.of(context).size;

          return AlertDialog(
              content: Container(
                width: size.width * 0.6,
                height: 100,
                child: Column(
                  children: [
                    Container(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, ImageSource.camera);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera),
                            SizedBox(width: 20),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, ImageSource.gallery);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo),
                            SizedBox(width: 20),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
    if(source == null) {
      return null;
    };

    pickImage(source);

  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source,
          maxWidth: 200,
          maxHeight: 200
      );

      if(image == null) return;

      final imagePerm = await saveImage(image.path);

      filePath = imagePerm.path;

      final pref = await SharedPreferences.getInstance();

      var userData = convert.jsonDecode(pref.getString("user")!);

      var response = await Api.instance.updateProfPic(userData['id'], filePath!);

      if(response.runtimeType != List<Object>){
        if(response.statusCode == 500){
          showStatus(color: Colors.red, text: response.body);
          return;
        }
      }

      if(response[1] != 200){
        showStatus(color: Colors.red, text: response[0].message);
        return;
      }

      setState(() {
        userData['picture'] = response[0].data['picture'];
        this.image = imagePerm;
      } );



    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future <File> saveImage (String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
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
            icon: Icon(Icons.person, color: Colors.blueGrey),
            itemBuilder: (BuildContext context) => <PopupMenuEntry> [
              PopupMenuItem(
                onTap: () async {
                  final pref = await SharedPreferences.getInstance();

                  pref.remove('loggedIn');
                  pref.remove('token');
                  pref.remove('user');
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
                            child: Lottie.asset('assets/lotties/error.json')
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
                                color: Colors.blue[100],
                                child: Image.asset('assets/OnlySells1.png')
                            ),
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    height: 145,
                                    width: 145,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.4)
                                    ),
                                    child: userData['picture'] == null ?
                                      Lottie.asset('assets/lotties/profile.json') :
                                      FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: '${dotenv.env['API_URL']}/picture/${userData['picture']}')
                                  ),
                                )
                              ),
                            ),
                            Positioned(
                                left: 120,
                                bottom: 20,
                                child: CircleAvatar(
                                  child: IconButton(
                                    onPressed: () {
                                      chooseMedia();
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
