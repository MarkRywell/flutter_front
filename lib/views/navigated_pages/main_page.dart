import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/views/user_pages/add_item.dart';
import 'package:flutter_front/views/user_pages/home_page.dart';
import 'package:flutter_front/views/user_pages/my_listings_page.dart';
import 'package:flutter_front/views/user_pages/profile_page.dart';

class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{

  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  int currentIndex = 0;
  List routes = [
    Icons.home,
    Icons.list,
    Icons.add,
    Icons.person_rounded,
  ];

  List <Widget> widgets1 = const [
    Center(child: Text("Home")),
    Center(child: Text("Listings")),
    Center(child: Text("Add")),
    Center(child: Text("Profile")),
  ];

  List <Widget> widgets = const [
    HomePage(),
    MyListingsPage(),
    AddItem(),
    ProfilePage()
  ];

  TextStyle customStyle () {
    return const TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontFamily: "Poppins"
    );
  }
  bool showFAB = false;

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: showFAB ? Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            width: double.infinity,
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor: Colors.blue[100],
                labelTextStyle: MaterialStateProperty.all(
                    customStyle()
                ),
              ),
              child: NavigationBar(
                backgroundColor: Colors.lightBlue[600],
                height: 60,
                labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: "Home" ,),
                  NavigationDestination(
                      icon: Icon(Icons.list_outlined),
                      selectedIcon: Icon(Icons.list),
                      label: "My Listings"),
                  NavigationDestination(
                      icon: Icon(Icons.add_outlined),
                      selectedIcon: Icon(Icons.add),
                      label: "Add Item"),
                  NavigationDestination(
                      icon: Icon(Icons.person_outlined),
                      selectedIcon: Icon(Icons.person),
                      label: "Profile"),
                ],
                selectedIndex: currentIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                animationDuration: const Duration(milliseconds: 500),
              ),
            ),
          ),
        ),
      ) : null,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() {
              showFAB = true;
            });
          }
          else if (notification.direction == ScrollDirection.reverse) {
            setState(() {
              showFAB = false;
            });
          }

          return true;
        },
        child: IndexedStack(
          index: currentIndex,
          children: widgets,
        ),
      )
    );
  }
}
