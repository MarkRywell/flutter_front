import 'package:flutter/material.dart';

class UpdateItem extends StatefulWidget {

  const UpdateItem({Key? key}) : super(key: key);

  @override
  State<UpdateItem> createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {

  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                          icon: const Icon(Icons.edit),
                          iconSize: 40,
                          color: Colors.blue,
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.only(top: 5),
                        ),
                        const Text(
                          'Update Photo',
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
                  constraints: BoxConstraints(
                    minHeight: 150,
                    maxWidth: 150
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                  ),
                  child: Image.file(image!), height: 200, width: 200,
                ):
                    Container()
              ],
            )
        ),
      ),
    );
  }
}
