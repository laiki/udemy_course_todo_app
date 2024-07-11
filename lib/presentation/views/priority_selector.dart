// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PrioritySelector extends StatefulWidget {

  int? todoPriority;
  Function(int?) onPriorityChanged;
  PrioritySelector({super.key, this.todoPriority, required this.onPriorityChanged});

  @override
  State<PrioritySelector> createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State<PrioritySelector> {

  List<String> list = [
    translate('todo_priority_high'), 
    translate('todo_priority_medium'), 
    translate('todo_priority_low'),
    translate('todo_priority_none')];

  @override
  Widget build(BuildContext context) {
    
    widget.todoPriority ??= 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Text(translate('newtodo_dialog_priority_label')),

        DropdownButton<String>(
          value: list[widget.todoPriority!],
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            if(value == null) return;

            int? priority;

            if(list.indexOf(value) < 3){
              priority = list.indexOf(value);
            }

            widget.onPriorityChanged(priority);

            setState(() {
              widget.todoPriority = list.indexOf(value);
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ]
    );
  }
}