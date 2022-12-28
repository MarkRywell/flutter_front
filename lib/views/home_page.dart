import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/models/query_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  List itemList = [];
  String networkStatus = " ";
  late StreamSubscription subscription;
  late AnimationController animationController;
  // ignore: prefer_typing_uninitialized_variables
  late var colorTween;

  Future <dynamic> fetchOtherItems () async {

    final pref = await SharedPreferences.getInstance();

    Map user = convert.jsonDecode(pref.getString("user")!);

    List items = await Api.instance.fetchOtherItems(user['id']);

    if(items.isEmpty) {
      return;
    }

    QueryBuilder.instance.truncateTable();

    for(int i = 0; i < items.length; i++) {
      QueryBuilder.instance.addItem(items[i]);
    }

    return items;
  }

  Future <void> checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();

    print(result);

    if(result == ConnectivityResult.mobile) {
      setState(() {
        networkStatus = "Mobile Network";
      });
    } else if(result == ConnectivityResult.wifi) {
      setState(() {
        networkStatus = "WiFi Network";
      });
    }
    else {
      setState(() {
        networkStatus = "none";
      });
    }
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

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2)
    );
    colorTween = animationController.drive(
        ColorTween(
            begin: Colors.indigo,
            end: Colors.amber
        ));
    animationController.repeat();

    checkConnectivity();
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      showStatus(color: event.name != "none" ? Colors.blueAccent : Colors.red,
          text: "Network: ${event.name}");

      setState(() {
        networkStatus = event.name;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Home Page")
      // ),
      body: FutureBuilder(
        future: networkStatus != "none" ? fetchOtherItems() : QueryBuilder.instance.items(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError) {
              print(snapshot.error);

              return Center(
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
                  )
              );
            }
            if(snapshot.hasData) {

              itemList.isEmpty ? itemList = snapshot.data! :null;

              print("dri sa snapshot ${itemList.length}");

              return NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    const SliverAppBar(
                      title: Text("HomePage"),
                    )
                  ],
                  body: RefreshIndicator(
                    onRefresh: () async {
                      itemList = await fetchOtherItems();
                      setState(() {
                        itemList;
                      });
                    },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {

                          final item = itemList[index];

                          return Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(item.picture),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Text(item.name),
                                  )
                                ],
                              )
                          );
                        }),
                  ),
                  )
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
