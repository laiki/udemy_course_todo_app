import 'package:flutter/material.dart';

class RegistrationOrLoginText extends StatelessWidget {

  final String text1;
  final String text2;
  final Function() onTap;
  
  const RegistrationOrLoginText({super.key, required this.onTap, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
          text1
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            text2,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline
            ),
          ),
        )
      ],),
    );
  }
}