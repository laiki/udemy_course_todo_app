part of 'todo_bloc.dart';

sealed class TodoState {

  final BlocStateType blocStateType;

  TodoState(this.blocStateType);

}

final class TodoInitial extends TodoState {
  TodoInitial() : super(BlocStateType.success);

}

final class TodoCreatedState extends TodoState {
  TodoCreatedState(super.blocStateType);
}

final class ReadAllTodosState extends TodoState {
  final List<Todo>? todos;

  ReadAllTodosState(super.blocStateType, {this.todos});

}

final class TodoStatusChangedState extends TodoState {
  TodoStatusChangedState(super.blocStateType);
}

final class TodoDeletedState extends TodoState {
  TodoDeletedState(super.blocStateType);
}

final class TodoUpdatedState extends TodoState {
  TodoUpdatedState(super.blocStateType);
}
