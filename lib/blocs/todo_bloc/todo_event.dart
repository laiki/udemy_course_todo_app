part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class CreateTodoEvent implements TodoEvent {

  final Todo todo;

  CreateTodoEvent(this.todo);

}

class ReadAllTodosEvent implements TodoEvent {}

class UpdateTodoStatusEvent implements TodoEvent {

  final Todo todo;

  UpdateTodoStatusEvent(this.todo);


}

class DeleteTodoEvent implements TodoEvent {

  final String id;

  DeleteTodoEvent(this.id);

}

class UpdateTodoEvent implements TodoEvent {

  final Todo todo;

  UpdateTodoEvent(this.todo);

}