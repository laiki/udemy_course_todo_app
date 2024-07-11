import 'package:todo_app/data/models/todo.dart';

abstract class VectorDBInterface {

  Future<bool> createVector(List<double> embedding, Todo todo, String email);
  
  Future<bool> updateVector(List<double> embedding, Todo todo, String email);
  
  Future<bool> deleteVector(String id);


}