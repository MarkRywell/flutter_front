import 'package:flutter/material.dart';
import 'package:flutter_front/models/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  List itemList = [];

  late AnimationController animationController;
  // ignore: prefer_typing_uninitialized_variables
  late var colorTween;

  Future <dynamic> fetchOtherItems () async {

    final pref = await SharedPreferences.getInstance();

    Map user = convert.jsonDecode(pref.getString("user")!);

    print('WTFFFF ${user['id']}');

    return await Api.instance.fetchOtherItems(user['id']);
  }

  @override
  void initState(){
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page")
      ),
      body: FutureBuilder(
        future: fetchOtherItems(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError) {
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

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {

                  final item = itemList[index];

                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.sold),
                  );
                },
              );

            }
          }
          return Center(
              child: CircularProgressIndicator(
                valueColor: colorTween,
              )
          );
        },
      )
    );
  }
}
