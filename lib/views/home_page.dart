import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/views/add_item.dart';
import 'package:flutter_front/views/my_listings_page.dart';
import 'package:flutter_front/views/profile_page.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  int selectedIndex = 0;
  List routes = [
    Icons.home,
    Icons.list,
    Icons.add,
    Icons.person_rounded,
  ];

  List pages = [
    HomePage(),
    MyListingsPage(),
    AddItem(),
    ProfilePage()
  ];

  List <Widget> widgets = [
    Center(child: Text("HomePage")),
    Center(child: Text("MyListings")),
    Center(child: Text("Add Item")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightBlue[900],
          child: Container(
            height: 50,
            width: double.infinity,
            child: ListView.builder(
                itemCount: routes.length,
                scrollDirection: Axis.horizontal,

                itemBuilder: (context, index) {

                  final page = routes[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(
                          milliseconds: 300
                        ),
                        width: 50,
                        decoration: BoxDecoration(
                          color: index == selectedIndex ? Colors.white : null,
                          border: index == selectedIndex ? Border.all(color: Colors.black38) : null,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Icon(routes[index],
                          size: 35,
                          color: index == selectedIndex ? Colors.grey[800]: Colors.white
                        ),
                      ),
                    ),
                  );
                }),
          ),
        )
      ),
    );
  }
}
