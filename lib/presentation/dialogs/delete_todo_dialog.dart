
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/presentation/views/todo_widget.dart';

class DeleteTodoDialog extends StatelessWidget {
  const DeleteTodoDialog({
    super.key,
    required this.widget,
  });

  final TodoWidget widget;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).pop(false);
        return false;
      },
      child: AlertDialog(
        title: Text(translate("deletetodo_dialog_title")),
        content: Text(translate("deletetodo_dialog_hint")),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              }, 
            child: Text(translate("deletetodo_dialog_cancel"))),
          
          TextButton(
            onPressed: () {
              
              BlocProvider.of<TodoBloc>(context).add(
                DeleteTodoEvent(widget.todo.uuid)
              );
    
              Navigator.of(context).pop(true);
            }, 
            child: Text(translate("deletetodo_dialog_confirm"))),
            

        ],
      ),
    );
  }
}