import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/domain/helpers/firestore_keys.dart';
import 'package:todo_app/domain/interfaces/todo_db_interface.dart';

class TodoFirestoreService implements TodoDBInterface {
  
  static final CollectionReference usersCollectionRef = FirebaseFirestore.instance.collection(USERS_COLLECTION_KEY);
  
  @override
  Future<bool> createTodo(Todo todo) async {
    final todosCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TODO_COLLECTION_KEY);

    final todoDocRef = todosCollectionRef.doc(todo.uuid);

    final data = todo.toJson();

    await todoDocRef.set(data);
    
    return true;

  }
  
  @override
  Stream<List<Todo>> getAllTodos() {
    final todosCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TODO_COLLECTION_KEY);

    return todosCollectionRef.snapshots().map((snapshot) {
      List<Todo> todos = [];
      for (var element in snapshot.docs) {
        Todo todo = Todo.fromJson(element.data());
        todos.add(todo);
      }
      return todos;
    });

  }
  
  @override
  Future<bool> changeTodoStatus(Todo todo, bool newStatus) async {
    final todosCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TODO_COLLECTION_KEY);

    final todoDocRef = todosCollectionRef.doc(todo.uuid);

    await todoDocRef.update({
      'status': newStatus
    });

    return true;

  }
  
  @override
  Future<bool> deleteTodo(String id) async {
    
    final todosCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TODO_COLLECTION_KEY);

    final todoDocRef = todosCollectionRef.doc(id);

    await todoDocRef.delete();

    return true;

  }
  
  @override
  Future<bool> updateTodo(Todo todo) async {
        final todosCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TODO_COLLECTION_KEY);

    final todoDocRef = todosCollectionRef.doc(todo.uuid);

    final data = todo.toJson();

    await todoDocRef.update(data);
    
    return true;
  }
  
}