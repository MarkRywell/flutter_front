import 'package:flutter/material.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({Key? key}) : super(key: key);

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container (
          child: Center(
            child: Text("My Listings Page"),
          )
        )
    );
  }
}
