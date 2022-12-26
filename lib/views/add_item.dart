import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
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
                        return (value == '') ? "Please input your name" : null;
                      },
                    ),
                    const Padding(padding: EdgeInsetsDirectional.only(top: 10)),
                    TextFormField(
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
                   const Padding(padding: EdgeInsetsDirectional.only(top: 10)),
                    SizedBox(
                        height: 50,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.upload),
                                    iconSize: 40,
                                    color: Colors.blue),
                                const Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(top: 5)),
                                const Text(
                                  "Upload Photo",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ))),
                    const Spacer(),
                    SizedBox(
                      height: 20,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("ADD ITEM")),
                    )
                  ],
                ))),
      ),
    );
  }
}
