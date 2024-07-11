// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ColorPickerView extends StatefulWidget {

  Color pickerColor;
  final Function(int) onConfirmPressed;

  ColorPickerView({super.key, required this.pickerColor, required this.onConfirmPressed});

  @override
  State<ColorPickerView> createState() => _ColorPickerViewState();
}

class _ColorPickerViewState extends State<ColorPickerView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(translate('color_picker_label')),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Runde Form
            color: widget.pickerColor, // Hintergrundsfarbe
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6), // Schattenfarbe
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(2, 3), // Ändern Sie die Versatzwerte nach Bedarf
              ),
            ],
          ),
          child: IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(translate('color_picker_title')),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: widget.pickerColor,
                      onColorChanged: (color) {
                        setState(() {
                          widget.pickerColor = color;
                        });
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text(translate('color_picker_confirm')),
                      onPressed: () {
                        widget.onConfirmPressed(widget.pickerColor.value);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              );
            }, 
            icon: const Icon(Icons.color_lens),
            ),
        ),

    ],);
  }

  
}