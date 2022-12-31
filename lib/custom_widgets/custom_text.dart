import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  final Icon icon;
  final String textTitle;
  final String textData;

  const CustomText({
    required this.icon,
    required this.textTitle,
    required this.textData,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return SizedBox(
        height: 50,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.2,
              child: Text(textTitle,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.5,
              child: Text(': $textData',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        )
    );
  }
}
