import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/views/navigated_pages/main_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/item.dart';

class AddItem extends StatefulWidget {

  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  File? image;
  String? filePath;

  Future addItem(Item newItem) async {

    var data = newItem.toMap();

    var response = await Api.instance.addItem(data);

    if(response.runtimeType != List<Object>){
      if(response.statusCode == 500){
        showStatus(color: Colors.red, text: response.body);
        return;
      }
    }
    showStatus(color: Colors.greenAccent, text: "Item Added");
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MainPage()));
  }

  Future <ImageSource?> chooseMedia() async {

    var source = await showDialog(
        context: context,
        builder: (BuildContext context) {

          Size size = MediaQuery.of(context).size;

          return AlertDialog(
            content: SizedBox(
              width: size.width * 0.7,
              height: 100,
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, ImageSource.camera);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera),
                        SizedBox(width: 20),
                        Text("Camera")
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await checkPermissions() == PermissionStatus.denied ? Navigator.pop(context, null) :
                      Navigator.pop(context, ImageSource.gallery);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.photo),
                        SizedBox(width: 20),
                        Text("Gallery")
                      ],
                    ),
                  )
                ],
              ),
            )
          );
        }
    );
    if(source == null) {
      return null;
    }
    pickImage(source);
    return null;
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source,
          maxWidth: 200,
          maxHeight: 200
      );

      if(image == null) return;

      final imagePerm = await saveImage(image.path);
      filePath = imagePerm.path;

      setState(() => this.image = imagePerm);

    } on PlatformException {
      showStatus(color: Colors.red, text: "Failed to pick image");
    }
  }

  Future <File> saveImage (String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
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

  checkPermissions() async {
    Map <Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    print(statuses);

    if (statuses[Permission.storage]!.isDenied) {
      return Permission.storage.isDenied;
    }
    else if (statuses[Permission.storage]!.isPermanentlyDenied) {
      openAppSettings();
    }
    else if(statuses[Permission.storage]!.isGranted) {
      return Permission.storage.isGranted;
    }

  }

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    nameController;
    detailsController;
    priceController;
    filePath;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset('assets/appbar/SellItem.png',
        alignment: Alignment.center,
        width: 150,
        fit: BoxFit.fitWidth,),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                                      style: BorderStyle.solid, color: Colors.blue)),
                              hintText: 'Name',
                            ),
                            validator: (value) {
                              return value == null || value.isEmpty ? "Please input a name" : null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: detailsController,
                            maxLines: 4,
                            decoration: InputDecoration(
                                hintText: 'Details',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.blue))),
                            validator: (value) {
                              return value == null || value.isEmpty ? "Please input details" : null;
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
                                hintText: 'Price',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.blue))),
                            validator: (value) {
                              return value == null || value.isEmpty ?  "Please input price" : null;
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
                                          chooseMedia();
                                        },
                                        icon: const Icon(Icons.upload),
                                        iconSize: 40,
                                        color: Colors.blue
                                    ),
                                    const Padding(
                                        padding: EdgeInsetsDirectional.only(top: 5)),
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
                          constraints: const BoxConstraints(
                            minHeight: 150,
                            maxWidth: 150
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)
                          ), height: 200, width: 200,
                          child: Image.file(image!),):
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black)
                          ),
                          height: 200,
                          width: 200,
                          child: const Center(
                              child: Text("No image selected")),
                        ),
                        const SizedBox(height: 50),
                        ClipRRect(borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: 40,
                            width: size.width * 0.6,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if(formKey.currentState!.validate()) {

                                    final pref = await SharedPreferences.getInstance();
                                    String data = pref.getString("user")!;
                                    var userData = convert.jsonDecode(data);

                                    var newItem = Item(
                                      id: null,
                                      name: nameController.text,
                                      details: detailsController.text,
                                      price: double.parse(priceController.text),
                                      userId: userData["id"],
                                      picture: filePath ?? "assets/OnlySells1.png",
                                      sold: "Available"
                                    );

                                    addItem(newItem);
                                  }
                                },
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