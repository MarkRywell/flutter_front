// import 'dart:html';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/models/query_builder.dart';
import 'package:flutter_front/views/mylistings_pages/update_item.dart';
import 'package:flutter_front/views/mylistings_pages/view_item.dart';
import 'package:flutter_front/views/user_pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({ Key? key, }) : super(key: key);


  @override
  State<MyListingsPage>createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {

  List listings = [];

  Future <dynamic> fetchMyItems () async {
    final pref = await SharedPreferences.getInstance();

    Map user = convert.jsonDecode(pref.getString("user")!);

    var connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      List items = await QueryBuilder.instance.myListings(user['id']);
      return items;
    }

    List items = await Api.instance.fetchMyItems(user['id']);

    if (items.isEmpty) {
      return [];
    }

    // QueryBuilder.instance.truncateTable();

    return items;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: FutureBuilder(
          future: fetchMyItems(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.hasError) {
                return NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    const SliverAppBar(
                      title: Text("HomePage"),
                    )
                  ],
                  body: RefreshIndicator(
                      onRefresh: () async {
                        listings = await fetchMyItems();
                        setState(() {
                          listings;
                        });
                      },
                      child: Center(
                        child: SingleChildScrollView(
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
                      )
                  ),
                );
              }
              if(snapshot.hasData) {

                if(snapshot.data.isEmpty) {
                  return NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      const SliverAppBar(
                        title: Text("My Listings"),
                      )
                    ],
                    body: RefreshIndicator(
                        onRefresh: () async {
                          listings = await fetchMyItems();
                          setState(() {
                            listings;
                          });
                        },
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  child: Text("No Item in your Listings"),
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                  );
                }
                else {

                  listings.isEmpty? listings = snapshot.data! : null;

                  return NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      const SliverAppBar(
                        title: Text("My Listings"),
                      )
                    ],
                    body: RefreshIndicator(
                      onRefresh: () async {
                        listings = await fetchMyItems();
                        setState(() {
                          listings;
                        });
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: listings.length,
                        itemBuilder: (context, index) {

                          final item = listings[index];



                          return Card(
                            child: ListTile(
                              title: Text(item.name),
                              subtitle: Text(item.sold),
                              trailing: PopupMenuButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                color: Colors.grey[300],
                                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                  PopupMenuItem(
                                    onTap: () async {
                                      Map sellerDetails;

                                      sellerDetails = await Api.instance.fetchItemSeller(item.userId);

                                      Navigator.push(context,
                                      MaterialPageRoute(builder: (context)
                                      => ViewItem(item: item, seller: sellerDetails)));
                                    },
                                    child: Text("View"),
                                  ),
                                  PopupMenuItem(
                                    onTap: () async {

                                      var updateItem = await item;

                                      Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => UpdateItem(item: updateItem)));
                                    },
                                    child: Text("Update"),
                                  ),
                                  PopupMenuItem(
                                    onTap: () async {
                                      await Api.instance.deleteItem(item);
                                      await QueryBuilder.instance.deleteItem(item.id);
                                      setState(() {
                                        listings.remove(item);
                                      });
                                    },
                                    child: Text("Remove"),

                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
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