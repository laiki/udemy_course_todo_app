import 'package:get_it/get_it.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/domain/interfaces/vector_db_interface.dart';
import 'package:todo_app/domain/services/langchain_service.dart';

class VectorDBService implements VectorDBInterface {
  
  final getIt = GetIt.instance;

  @override
  Future<bool> createVector(List<double> embedding, Todo todo, String email) async{
    
    return await getIt.get<LangchainService>().addVector(
      embedding, 
      todo.uuid, 
      todo.name, 
      email
    );
    
  }

  @override
  Future<bool> deleteVector(String id) async{
    return await getIt.get<LangchainService>().deleteVector(id);
  }

  @override
  Future<bool> updateVector(List<double> embedding, Todo todo, String email) async {
    await deleteVector(todo.uuid);
    return await createVector(embedding, todo, email);
  }

}