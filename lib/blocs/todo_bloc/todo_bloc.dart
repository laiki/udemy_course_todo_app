import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/domain/interfaces/authentication_interface.dart';
import 'package:todo_app/domain/interfaces/chatbot_interface.dart';
import 'package:todo_app/domain/interfaces/todo_db_interface.dart';
import 'package:todo_app/domain/interfaces/vector_db_interface.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {

    final getIt = GetIt.instance;

    on<CreateTodoEvent>((event, emit) async {
      emit(TodoCreatedState(BlocStateType.loading));

      bool todoCreated = await getIt<TodoDBInterface>().createTodo(event.todo);

      if(todoCreated){

        //Get todo as an embedding
        List<double> embedding = await getIt<ChatBotInterface>().getEmbeddings(event.todo);

        //Save the embedding in pinecone
        bool todoCreatedVectorDB = await getIt<VectorDBInterface>()
        .createVector(
          embedding, 
          event.todo, 
          getIt<AuthenticationInterface>().getUserEmail());

        if(todoCreatedVectorDB){
          emit(TodoCreatedState(BlocStateType.success));
          return;
        }

      }

      emit(TodoCreatedState(BlocStateType.error));

    });

    on<ReadAllTodosEvent>((event, emit) async {
      emit(ReadAllTodosState(BlocStateType.loading));

      try {
        
        await emit.forEach(
          getIt<TodoDBInterface>().getAllTodos(), 
          onData: (List<Todo> todos) => 
            ReadAllTodosState(BlocStateType.success, todos: todos));
      
      } catch (ex){

        emit(ReadAllTodosState(BlocStateType.error));

      }


    });

    on<UpdateTodoStatusEvent>((event, emit) async {
      emit(TodoStatusChangedState(BlocStateType.loading));

      bool todoStatusChanged = await getIt<TodoDBInterface>()
          .changeTodoStatus(event.todo, event.todo.status);

      if(todoStatusChanged){
        emit(TodoStatusChangedState(BlocStateType.success));

        List<double> embedding = await getIt<ChatBotInterface>().getEmbeddings(event.todo);

        bool todoUpdateVectorDB = await getIt<VectorDBInterface>()
        .updateVector(
          embedding, 
          event.todo, 
          getIt<AuthenticationInterface>().getUserEmail());

        if(todoUpdateVectorDB){
          emit(TodoStatusChangedState(BlocStateType.success));
          return;
        }

      }

      emit(TodoStatusChangedState(BlocStateType.error));

    });

    on<UpdateTodoEvent>((event, emit) async {
      emit(TodoUpdatedState(BlocStateType.loading));

      bool todoUpdated = await getIt<TodoDBInterface>()
          .updateTodo(event.todo);

      if(todoUpdated){
        emit(TodoUpdatedState(BlocStateType.success));

        List<double> embedding = await getIt<ChatBotInterface>().getEmbeddings(event.todo);

        bool todoUpdateVectorDB = await getIt<VectorDBInterface>()
        .updateVector(
          embedding, 
          event.todo, 
          getIt<AuthenticationInterface>().getUserEmail());

        if(todoUpdateVectorDB){
          emit(TodoUpdatedState(BlocStateType.success));
          return;
        }
      }

      emit(TodoUpdatedState(BlocStateType.error));

    });

    on<DeleteTodoEvent>((event, emit) async {
      emit(TodoDeletedState(BlocStateType.loading));

      bool todoDeleted = await getIt<TodoDBInterface>()
          .deleteTodo(event.id);

      if(todoDeleted){
        emit(TodoDeletedState(BlocStateType.success));


        bool todoDeleteVectorDB = await getIt<VectorDBInterface>()
        .deleteVector(
          event.id);

        if(todoDeleteVectorDB){
          emit(TodoDeletedState(BlocStateType.success));
          return;
        }

      }

      emit(TodoDeletedState(BlocStateType.error));

    });
  }
}
