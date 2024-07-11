// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/models/tag.dart';
import 'package:todo_app/presentation/views/priority_selector.dart';
import 'package:todo_app/presentation/views/tags_row.dart';

class NewEditTodoDialog extends StatelessWidget {
  final bool isEdit;
  
  final Function({
    required String name, 
    DateTime? dueDate, 
    int? todoPriority,
    List<String>? tags,  
  }) onConfirmPressed;
  
  String? todoName;
  DateTime? dueDate;
  int? todoPriority;
  List<String> tags;

  final TextEditingController todoNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  NewEditTodoDialog({
    Key? key,
    required this.isEdit,
    required this.onConfirmPressed,
    this.todoName,
    this.dueDate,
    this.todoPriority,
    List<String>? tags,
  }) : tags = tags ?? [], super(key: key);

  @override
  Widget build(BuildContext context) {
    
    if (isEdit) {
      todoNameController.text = todoName ?? "";

      if (dueDate != null) {
        dateController.text = DateFormat('dd.MM.yyyy').format(dueDate!);
      }
    }

    return AlertDialog(
      title: Text(translate(isEdit ? "edittodo_dialog_title" : "newtodo_dialog_title")),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: todoNameController,
              decoration: InputDecoration(
                labelText: translate("newtodo_dialog_name_label"),
                hintText: translate("newtodo_dialog_name_label"),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: translate("newtodo_dialog_duedate_label"),
                      hintText: translate("newtodo_dialog_duedate_label"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), 
      
                //Button to open date picker
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Runde Form
                    color: Colors.deepPurple.shade100, // Hintergrundsfarbe
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
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        dueDate = picked;
                        dateController.text = DateFormat('dd.MM.yyyy').format(picked);
                      }
                    },
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 20),
      
            PrioritySelector(todoPriority: todoPriority, onPriorityChanged: (priority) {
              todoPriority = priority;
            },),

            const SizedBox(height: 20),

            TagsRow(
              onlySelect: true, 
              onTagSelected: onTagSelected,
              selectedTags: { for (var tag in tags) tag: true },)
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(translate("newtodo_dialog_cancel")),
        ),
        TextButton(
          onPressed: () {
            onConfirmPressed(
              name: todoNameController.text, 
              dueDate: dueDate,
              todoPriority: todoPriority,
              tags: tags);
            Navigator.pop(context);
          },
          child: Text(translate("newtodo_dialog_confirm")),
        ),
      ],
    );
  }

  void onTagSelected(bool select, Tag tag) {
    if(select){
      //Add tag uuid to selected list
      if(!tags.contains(tag.uuid)){
        tags.add(tag.uuid);
      }

    } else {
      //Remove tag uuid from selected list
      if(tags.contains(tag.uuid)){
        tags.remove(tag.uuid);
      }

    }
  }
}
