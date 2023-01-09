import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/custom_widgets/custom_text.dart';
import 'package:flutter_front/custom_widgets/custom_text1.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/models/item.dart';
import 'package:flutter_front/views/navigated_pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class DetailsPage extends StatefulWidget {

  final Item item;
  final Map seller;

  const DetailsPage({
    required this.item,
    required this.seller,
    Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {

  late TabController tabController;

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

  purchase(String buyerName) async {

    Item item = Item(id: widget.item.id, name: widget.item.name,
        details: widget.item.details, price: widget.item.price,
        userId: widget.item.userId, sold: "Sold", soldTo: buyerName,
        picture: widget.item.picture);

    var response = await Api.instance.purchase(item);

    if(response.runtimeType != List<Object>){
      if(response.statusCode == 500){
        showStatus(color: Colors.red, text: response.body);
        return;
      }
    }

    showStatus(color: Colors.greenAccent, text: "Item Purchased");
    return response;
  }

  buyForm (var item) async {

    final pref = await SharedPreferences.getInstance();
    final prefData = convert.jsonDecode(pref.getString("user")!);
    final buyerName = prefData['name'];


    var formKey = GlobalKey<FormState>();
    TextEditingController buyerController = TextEditingController(text: buyerName);


    return showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: false,
        builder: (BuildContext context) {

          Size size = MediaQuery.of(context).size;

          return AlertDialog(
            title: const Center(child: Text("Purchase Form",
            style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins"))),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            content: Container(
              height: size.height * 0.5,
              width: size.width * 0.8,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomText1(textTitle: "Item Name:", textData: item.name),
                    CustomText1(textTitle: "Price:", textData: "₱ ${item.price.toString()}"),
                    TextFormField(
                      readOnly: true,
                      controller: buyerController,
                      decoration: InputDecoration(
                        labelText: "Buyer's Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      validator: (value) {
                        return value == null || value.isEmpty ?
                        "Customer Name is required" : null;
                      },
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: size.width * 0.3,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if(formKey.currentState!.validate()) {
                                    purchase(buyerController.text);
                                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => MainPage()));
                                  }
                                },
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)
                                ),
                                child: const Text("PURCHASE",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                  width: size.width * 0.3,
                                  height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)
                                ),
                                child: const Text("CANCEL",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    )
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
                color: Colors.grey
            ),
            child: const Icon(Icons.arrow_back,
              color: Colors.white,
          ),),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height * 0.4,
                child: Image.network('${dotenv.env['API_URL']}/picture/${widget.item.picture}',
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
                        fontWeight: FontWeight.bold
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
                          CustomText(icon: const Icon(Icons.person), textTitle: 'Name', textData: widget.seller['name']),
                          CustomText(icon: const Icon(Icons.place), textTitle: 'Address', textData: widget.seller['address'])
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
        onTap:() async {
          var response = await buyForm(widget.item);
          if(response != null) {
            Navigator.pop(context);
          }
        },
        child: Container(
          height: 60,
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Purchase Item",
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
