import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/core/helpers/ui_helper.dart';
import 'package:todo_app/data/models/tag.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/presentation/dialogs/delete_todo_dialog.dart';
import 'package:todo_app/presentation/dialogs/new_edit_todo_dialog.dart';
import 'package:intl/intl.dart';

class TodoWidget extends StatefulWidget {

  final Todo todo;
  final List<Tag> tags;

  const TodoWidget({super.key, required this.todo, required this.tags});

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {

  @override
  Widget build(BuildContext context) {
    return 
      BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          
          if(state is TodoStatusChangedState && state.blocStateType == BlocStateType.success){
            setState(() {
              
            });
          }
  
        },
      child: GestureDetector(
        onLongPress: () {showEditTodoDialog(context);},
        child: Dismissible(
          key: Key(widget.todo.name),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.delete, color: Colors.white,),
          ),
          confirmDismiss: (direction) async {
            return await showDeleteDialog(context);
          },
          child: CheckboxListTile(
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.todo.name),
                    if(widget.todo.dateDue != null) Text(
                      '${translate("todo_duedate")}: ${DateFormat('dd.MM.yyyy').format(widget.todo.dateDue!)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                const Spacer(),
                if(widget.todo.priority != null && widget.todo.priority! < 2)
                  Icon(
                    widget.todo.priority! == 0 ? Icons.warning : Icons.priority_high, 
                    color: widget.todo.priority! == 0 ? Colors.red : Colors.orange,),

                  for(var tag in widget.tags)
                    Transform.scale(
                      scale: 0.8,
                      child: RawChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        label: Text(
                          tag.name,
                          style: TextStyle(color: UIHelper.getTextColorFromBackgroundColor(Color(tag.color))),),
                        backgroundColor: Color(tag.color).withOpacity(0.8),
                      ),
                    ),
                    
              ],
            ),
          value: widget.todo.status, 
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (value) {
        
            widget.todo.status = value!;
            BlocProvider.of<TodoBloc>(context).add(
              UpdateTodoStatusEvent(widget.todo)
            );
          }),
        ),
      ),
    );
  }

  FutureOr<bool> showDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return DeleteTodoDialog(widget: widget);
      });
  }

  Future showEditTodoDialog(BuildContext context) async{
    showDialog(
      context: context, 
      builder: (context) {
        return NewEditTodoDialog(
          isEdit: true,
          todoName: widget.todo.name,
          dueDate: widget.todo.dateDue,
          todoPriority: widget.todo.priority,
          tags: widget.todo.tag,
          onConfirmPressed: todoEdited);
      }
    );
  }

  void todoEdited({
    required String name, 
    DateTime? dueDate, 
    int? todoPriority,
    List<String>? tags}){
    
    widget.todo.name = name;
    widget.todo.dateDue = dueDate;
    widget.todo.priority = todoPriority;
    widget.todo.tag = tags;

    BlocProvider.of<TodoBloc>(context).add(
      UpdateTodoEvent(widget.todo)
    );                  
  }
}
