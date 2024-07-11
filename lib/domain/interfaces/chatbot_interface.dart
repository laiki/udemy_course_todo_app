import 'package:todo_app/data/models/todo.dart';

abstract class ChatBotInterface {
  Future<String?> getResponse(String message);

  Future<List<double>> getEmbeddings(Todo todo);
}
