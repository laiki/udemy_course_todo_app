// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final TextEditingController textEditingController;
  final String labelText;
  bool? hidden = false;
  IconData? iconData;
  String? Function(String?)? validator;
  
  InputField({
    super.key, 
    required this.textEditingController, 
    required this.labelText,
    this.validator,
    this.hidden = false,
    this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(3,8)
            )
          ]
        ),
        child: TextFormField(
          validator: validator ?? (value) => null,
          controller: textEditingController,
          obscureText: hidden ?? false,
          decoration: InputDecoration(
            prefixIcon: getIcon(),
            labelText: labelText,
            border: const OutlineInputBorder()
          ),
        ),
      ),
    );
  }

  Widget? getIcon(){
    if(iconData != null){
      return Icon(iconData);
    }

    return null;
  }
}