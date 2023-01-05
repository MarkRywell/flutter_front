import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateItem extends StatefulWidget {
  final Item item;
  const UpdateItem({
    required this.item,
    Key? key}) : super(key: key);

  @override
  State<UpdateItem> createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {

  late TextEditingController nameController =
  TextEditingController(text: widget.item.name);
  late TextEditingController detailsController =
  TextEditingController(text: widget.item.details);
  late TextEditingController priceController =
  TextEditingController(text: widget.item.price.toString());

  var formKey = GlobalKey<FormState>();
  File? image;
  String? filePath;

  updateItem(Item updatedItem) {

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Image.asset('assets/OnlySells1.png',
          alignment: Alignment.center,
          width: 200,
          fit: BoxFit.fitWidth,),
          centerTitle: true,
          backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40 , right: 40),
        child: SingleChildScrollView(
          child: Scrollbar(
            interactive: true,
            thickness: 8.0,
            radius: const Radius.circular(5),
            child: Form(
              key: formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              style: BorderStyle.solid, color: Colors.blue
                            )
                          ),
                          hintText: 'Name'
                        ),
                        validator: (value) {
                          return value == null || value.isEmpty ?
                          "Please input a name" : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: detailsController,
                        maxLines: 4,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    style: BorderStyle.solid, color: Colors.blue
                                )
                            ),
                            hintText: 'Details'
                        ),
                        validator: (value) {
                          return value == null || value.isEmpty ?
                          "Please input details" : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                            prefix: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text("₱")
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.blue
                                )
                            ),
                          hintText: 'Price',
                        ),
                        validator: (value) {
                          return value == null || value.isEmpty ?
                          "Please input price" : null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () async {

                                },
                              icon: const Icon(Icons.upload),
                              iconSize: 40,
                              color: Colors.blue,
                            ),
                            const Padding(
                              padding: EdgeInsetsDirectional.only(top: 5),
                            ),
                            const Text(
                              'Upload Photo',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                      width: 20,
                    ),
                    image != null ?
                    Container(
                      constraints: const BoxConstraints(
                          minHeight: 150,
                          maxWidth: 150
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Image.file(image!), height: 200, width: 200,):
                    Container(
                      constraints: const BoxConstraints(
                          minHeight: 150,
                          maxWidth: 150
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black)
                      ),
                      child: Image.network('${dotenv.env['API_URL']}/picture/${widget.item.picture}')),
                    const SizedBox(height: 50),
                    ClipRRect(borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 40,
                        width: size.width * 0.6,
                        child: ElevatedButton(
                            onPressed: () async {
                              if(formKey.currentState!.validate()) {

                                final pref = await SharedPreferences.getInstance();
                                String data = pref.getString("user")!;
                                var userData = convert.jsonDecode(data);

                                var updatedItem = Item(
                                    id: null,
                                    name: nameController.text,
                                    details: detailsController.text,
                                    price: double.parse(priceController.text),
                                    userId: userData["id"],
                                    picture: filePath ?? "assets/OnlySells1.png",
                                    sold: "Available"
                                );

                                updateItem(updatedItem);
                              }
                            },
                            child: const Text("UPDATE ITEM")
                        ),
                      ),
                    )
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
