import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_front/views/main_page.dart';
import 'package:image_picker/image_picker.dart';
import '../models/item.dart';

class AddItem extends StatefulWidget {

  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  List<Item> itemList = [];
  File? image;

  Future<void> addItem() async {
    if(formKey.currentState!.validate()) {

      Item newItem = Item(
        name: nameController.text,
        details: detailsController.text,
        id: null,
        userId: null,
        sold: '',
        picture: '',
      );

      setState(() {
        itemList.add(newItem);
      }
      );

      nameController.clear();
      detailsController.clear();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 200,
          maxHeight: 200
      );

      if(image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Image.asset('assets/OnlySells.png'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Card(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: SingleChildScrollView(child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  style: BorderStyle.solid, color: Colors.blue)),
                          hintText: 'NAME',
                        ),
                        validator: (value) {
                          return (value == '') ? "Please input a name" : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: detailsController,
                        decoration: InputDecoration(
                            hintText: 'Details',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.blue))),
                        validator: (value) {
                          return (value == '') ? "Please input details" : null;
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
                                      pickImage();
                                    },
                                    icon: const Icon(Icons.upload),
                                    iconSize: 40,
                                    color: Colors.blue
                                ),
                                const Padding(
                                    padding:
                                    EdgeInsetsDirectional.only(top: 5)),
                                const Text(
                                  "Upload Photo",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            )
                        )
                    ),
                    const SizedBox(
                      height: 15,
                      width: 20,
                    ),
                    image != null ?
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Image.file(image!), height: 200, width: 200,):
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black)
                      ),
                      child: Center(
                          child: const Text("No image selected")),
                      height: 200,
                      width: 200,),
                    const SizedBox(height: 50),
                    ClipRRect(borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 40,
                        width: size.width * 0.6,
                        child: ElevatedButton(
                            onPressed: addItem,
                            child: const Text("ADD ITEM")
                        ),
                      ),
                    )
                  ],
                )
            )),
        ),
      ),
    );
  }
}