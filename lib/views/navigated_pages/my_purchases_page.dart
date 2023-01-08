import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/models/query_builder.dart';
import 'package:flutter_front/views/mylistings_pages/view_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class MyPurchasesPage extends StatefulWidget {

  const MyPurchasesPage({Key? key}) : super(key: key);

  @override
  State<MyPurchasesPage> createState() => _MyPurchasesPageState();
}

class _MyPurchasesPageState extends State<MyPurchasesPage> {

  List myPurchases = [];

  Future <dynamic> fetchMyPurchases () async {
    final pref = await SharedPreferences.getInstance();

    Map user = convert.jsonDecode(pref.getString("user")!);

    var connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      List items = await QueryBuilder.instance.myPurchases(user['name']);
      return items.isEmpty ? [] : items;
    }

    List items = await Api.instance.fetchMyPurchases(user['name']);

    if (items.isEmpty) {
      return [];
    }

    return items;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchMyPurchases(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError) {
              return NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Image.asset('assets/appbar/MyPurchases.png',
                      alignment: Alignment.center,
                      width: 200,
                      fit: BoxFit.fitWidth,),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_outlined),
                        color: Colors.blueGrey,
                      )
                  )
                ],
                body: RefreshIndicator(
                    onRefresh: () async {
                      myPurchases = await fetchMyPurchases();
                      setState(() {
                        myPurchases;
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
                    SliverAppBar(
                      title: Image.asset('assets/appbar/MyPurchases.png',
                        alignment: Alignment.center,
                        width: 200,
                        fit: BoxFit.fitWidth,),
                      centerTitle: true,
                      backgroundColor: Colors.white,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_outlined),
                          color: Colors.blueGrey,
                        )
                    )
                  ],
                  body: RefreshIndicator(
                      onRefresh: () async {
                        myPurchases = await fetchMyPurchases();
                        setState(() {
                          myPurchases;
                        });
                      },
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                child: const Text("No Item in your Purchases",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18
                                )),
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                );
              }
              else {

                myPurchases.isEmpty? myPurchases = snapshot.data! : null;

                return NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      title: Image.asset('assets/appbar/MyPurchases.png',
                        alignment: Alignment.center,
                        width: 200,
                        fit: BoxFit.fitWidth,
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.white,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_outlined),
                          color: Colors.blueGrey,
                        )
                    )
                  ],
                  body: RefreshIndicator(
                    onRefresh: () async {
                      myPurchases = await fetchMyPurchases();
                      setState(() {
                        myPurchases;
                      });
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: myPurchases.length,
                      itemBuilder: (context, index) {

                        final item = myPurchases[index];

                        return Card(
                          child: ListTile(
                            title: Text(item.name),
                            subtitle: Text(item.sold),
                            onTap: () async {
                              Map sellerDetails;

                              sellerDetails = await Api.instance.fetchItemSeller(item.userId);

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)
                                  => ViewItem(item: item, seller: sellerDetails)));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            }
          }
          return NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Image.asset('assets/appbar/MyPurchases.png',
                  alignment: Alignment.center,
                  width: 200,
                  fit: BoxFit.fitWidth,),
                centerTitle: true,
                backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_outlined),
                    color: Colors.blueGrey,
                  )
              )
            ],
            body: RefreshIndicator(
                onRefresh: () async {
                  myPurchases = await fetchMyPurchases();
                  setState(() {
                    myPurchases;
                  });
                },
                child: const Center(
                  child: SingleChildScrollView(
                      child: CircularProgressIndicator()
                  ),
                )
            ),
          );
        },
      ),
    );
  }
}
