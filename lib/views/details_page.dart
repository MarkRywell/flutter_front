import 'package:flutter/material.dart';
import 'package:flutter_front/custom_widgets/custom_text.dart';
import 'package:flutter_front/models/item.dart';

class DetailsPage extends StatefulWidget {

  final Item item;
  final String seller;

  const DetailsPage({
    required this.item,
    required this.seller,
    Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {

  late TabController tabController;

  buyForm (var item) async {



  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height * 0.4,
                child: Image.network(widget.item.picture,
                fit: BoxFit.fitWidth,),
              ),
              Row(
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 30, 0),
                      width: size.width,
                      height: 80,
                      child: Text(widget.item.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins"
                      ))
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                    width: 150,
                    height: 50,
                    child: Text("₱ ${widget.item.price.toString()}",
                    style: const TextStyle(
                      fontSize: 16
                    ),),
                  ),
                ],
              ),
              const Divider(height: 5, thickness: 10),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                      controller: tabController,
                      isScrollable: true,
                      labelColor: Colors.blue[900],
                      unselectedLabelColor: Colors.grey[600],
                      indicatorSize: TabBarIndicatorSize.tab,

                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.teal[100]
                      ),

                      tabs: const [
                        Tab(text: "Seller"),
                        Tab(text: "Item Details"),
                      ]
                  ),
                ),
              ),
              const Divider(thickness: 1),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: size.height * 0.3,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(icon: const Icon(Icons.person), textTitle: 'Name', textData: widget.seller)
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(20),
                              width: size.width * 0.9,
                              constraints: const BoxConstraints(
                                minHeight: 100
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blueAccent, width: 2)
                              ),
                              child: Text(widget.item.details),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap:() {

        },
        child: Container(
          height: 60,
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Buy Item",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.shopping_cart_sharp)
              ],
            )
        ),
      )
    );
  }
}
