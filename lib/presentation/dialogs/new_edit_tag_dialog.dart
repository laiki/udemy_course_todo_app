// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todo_app/presentation/views/color_picker.dart';

class NewEditTagDialog extends StatelessWidget {
  final bool isEdit;
  final Function({required String name, int? color}) onConfirmPressed;
  final Function()? onDeletePressed;

  String? tagName;
  int? tagColor;

  NewEditTagDialog({
    super.key, 
    required this.isEdit, 
    required this.onConfirmPressed,
    this.tagName,
    this.tagColor,
    this.onDeletePressed});

  
  final TextEditingController tagNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    if (isEdit) {
      tagNameController.text = tagName ?? "";

      // if (dueDate != null) {
      //   dateController.text = DateFormat('dd.MM.yyyy').format(dueDate!);
      // }
    }

    return AlertDialog(
      title: Text(translate(isEdit ? "edittag_dialog_title" : "newtag_dialog_title")),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tagNameController,
              decoration: InputDecoration(
                labelText: translate("newtag_dialog_name_label"),
                hintText: translate("newtag_dialog_name_label"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            ColorPickerView(
              pickerColor: tagColor == null ? Colors.white : Color(tagColor!),
              onConfirmPressed: (colorValue) {
                tagColor = colorValue;
              },),
          ],
        ),
      ),
      actions: [
        if(isEdit)
          IconButton(onPressed: () {
            onDeletePressed!();
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.delete)
          ) ,
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(translate("newtag_dialog_cancel")),
        ),
        TextButton(
          onPressed: () {
            onConfirmPressed(
              name: tagNameController.text,
              color: tagColor,
              );
            Navigator.pop(context);
          },
          child: Text(translate("newtag_dialog_confirm")),
        ),
      ],
    );
  }
}