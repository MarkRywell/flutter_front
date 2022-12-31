import 'package:flutter/material.dart';

class CustomText1 extends StatelessWidget {

  final String textTitle;
  final String textData;

  const CustomText1({
    required this.textTitle,
    required this.textData,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 100,
              child: Text(textTitle,
              style: TextStyle(
               fontSize: 16,
              )),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              child: Text(textData,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              )),
            ),
          )
        ],
      ),
    );
  }
}
