import 'package:todo_app/data/models/todo.dart';

abstract class TodoDBInterface {
  
  Future<bool> createTodo(Todo todo);

  Stream<List<Todo>> getAllTodos();

  Future<bool> changeTodoStatus(Todo todo, bool newStatus);

  Future<bool> updateTodo(Todo todo);

  Future<bool> deleteTodo(String id);

}