import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/tag_bloc/tag_bloc.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/data/models/tag.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/presentation/dialogs/new_edit_todo_dialog.dart';
import 'package:todo_app/presentation/views/navbar.dart';
import 'package:todo_app/presentation/views/tags_row.dart';
import 'package:todo_app/presentation/views/todo_widget.dart';
import 'package:todo_app/core/routes.dart' as routes;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Map<String, Tag> allTags = {};
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        title: const Text("TODO"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.pushNamed(context, routes.chatRoute);
            }
          ),
        ]
      ),
      body: getBody(context),
      floatingActionButton: 
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){

            showNewTodoDialog(context);

          }),
    );
  }

  Future showNewTodoDialog(BuildContext context) async{
    showDialog(
      context: context, 
      builder: (context) {
        return NewEditTodoDialog(
          isEdit: false,
          onConfirmPressed: newTodoCreated);
      }
    );
  }

  getBody(BuildContext context){

    return BlocListener<TagBloc, TagState>(
      listener: (context, state) {
        
        if(state is ReadAllTagsState && state.blocStateType == BlocStateType.success){
          
          allTags = {};
          for (var tag in state.tags!) {
            allTags[tag.uuid] = tag;
          }

          setState(() {
            
          });
        }

      },
      child: BlocConsumer<TodoBloc, TodoState>(
          listener: (context, state) {
          },
          buildWhen: (previous, current) => current is ReadAllTodosState,
          builder: (context, state) {
    
            if(state is TodoInitial){
              BlocProvider.of<TodoBloc>(context).add(
                ReadAllTodosEvent()
              );  
            }
    
            if(state is ReadAllTodosState && state.blocStateType == BlocStateType.success){
    
              //List todos
              return getTodosListWidget(context, state.todos!);
    
            } else if (state is ReadAllTodosState && state.blocStateType == BlocStateType.loading){
    
              //Loading circle
              return getLoadingWidget(context);
    
    
            } else if(state is ReadAllTodosState && state.blocStateType == BlocStateType.error){
    
              //Error Text
              return getErrorMessage(context);
            }
    
            return Container();
    
          }),
    );

  }

  void newTodoCreated({
    required String name, 
    DateTime? dueDate, 
    int? todoPriority,
    List<String>? tags}){
    
    BlocProvider.of<TodoBloc>(context).add(
      CreateTodoEvent(
        Todo(name, DateTime.now(), 
        dateDue: dueDate,
        priority: todoPriority,
        tag: tags)
      )
    );                  
      
  }

  getTodosListWidget(BuildContext context, List<Todo> todos){

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TagsRow(
            onlySelect: false, 
            onTagSelected: onTagSelected,
            selectedTags: { for (var tag in selectedTags) tag: true }),
        ),

        Expanded(
          child: ListView(
            children: getFilteredAndSortedTodoWidgets(todos),
          ),
        ),
      ],
    );

  }

  getLoadingWidget(BuildContext context){
    return const Center(
      child:  CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
    );
  }

  getErrorMessage(BuildContext context){
    return const Center(
      child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.red, // Farbe des Fehler-Icons
              size: 60.0, // Größe des Fehler-Icons
            ),
            SizedBox(height: 10.0), // Ein kleiner Abstand zwischen Icon und Text
            Text(
              'Fehler',
              style: TextStyle(
                color: Colors.red, // Farbe des Fehlertexts
                fontSize: 18.0, // Größe des Fehlertexts
              ),
            ),]),
    );
  }

  List<Widget> getFilteredAndSortedTodoWidgets(List<Todo> todos){
    
    todos = todos.where((todo) => selectedTags.isEmpty || todo.tag!.any((tag) => selectedTags.contains(tag))).toList();

    List<Todo> todosWithDate = todos.where((todo) => todo.dateDue != null).toList();
    todosWithDate.sort((a, b) => a.dateDue!.compareTo(b.dateDue!));

    // Filtern der Todos ohne Datum
    List<Todo> todosWithoutDate = todos.where((todo) => todo.dateDue == null).toList();

    // Erstellen der Widget-Liste mit den sortierten Todos
    List<Widget> todoWidgets = [];

    // Hinzufügen der Todos mit Datum zu der Widget-Liste
    todoWidgets.addAll(todosWithDate.map((todo) => 
      TodoWidget(todo: todo, tags: allTags.values.where((tag) 
          => todo.tag!.contains(tag.uuid)).toList(),)));

    // Hinzufügen der Todos ohne Datum zu der Widget-Liste
    todoWidgets.addAll(todosWithoutDate.map((todo) => 
      TodoWidget(todo: todo, tags: allTags.values.where((tag) 
          => todo.tag!.contains(tag.uuid)).toList(),)));

    return todoWidgets;
  }

  void onTagSelected(bool select, Tag tag) {

    if(select){
      if(!selectedTags.contains(tag.uuid)) selectedTags.add(tag.uuid);
    } else {
      if(selectedTags.contains(tag.uuid)) selectedTags.remove(tag.uuid);
    }
     
    setState(() {
      
    });

  }

}