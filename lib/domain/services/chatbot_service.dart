import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/core/openai_key.dart';
import 'package:todo_app/data/models/chat_request.dart';
import 'package:todo_app/data/models/chat_response.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/domain/interfaces/authentication_interface.dart';
import 'package:todo_app/domain/interfaces/chatbot_interface.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/domain/interfaces/todo_db_interface.dart';
import 'package:todo_app/domain/services/langchain_service.dart';

class ChatbotService implements ChatBotInterface{
  
  static final Uri completionsUrl = Uri.parse('https://api.openai.com/v1/chat/completions');

  static final Uri embeddingsUrl = Uri.parse('https://api.openai.com/v1/embeddings');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json' ,
    'Authorization': 'Bearer $OPENAI_KEY'
  };

  static const String behavior = "You are an intelligent todo app. You answer the user's questions based on their existing todos.\n. The relevant todos in json format for this query are:";

  final getIt = GetIt.instance;


  @override
  Future<String?> getResponse(String message) async {
    if(message.isEmpty) return null;

    try {
      
      final getIt = GetIt.instance;

      List<String> relevantIds = await getIt<LangchainService>()
        .getSimilarDocumentIds(message, getIt<AuthenticationInterface>().getUserEmail());

      List<Todo> todos = await getIt<TodoDBInterface>().getAllTodos().first;

      List<Todo> relevantTodos = todos.where((todo) => relevantIds.contains(todo.uuid)).toList();

      for( var todo in relevantTodos){
        if (kDebugMode) {
          print(todo.name);
        }
      }

      String content = "$behavior \n ${jsonEncode(relevantTodos)} \n $message";

      //print(content);
      
      ChatRequest request = ChatRequest(
        model: "gpt-3.5-turbo",
        maxTokens: 1000, 
        messages: [
          Message(
            role: "system",
            content: content
          ),
        ]);
      
      http.Response response = await http.post(
        completionsUrl,
        headers: headers,
        body: request.toJson()
      );
      
      ChatResponse chatResponse = ChatResponse.fromResponse(response);
      
      if (kDebugMode) {
        print(chatResponse.choices?[0].message?.content );
      }
      
      return chatResponse.choices?[0].message?.content;
    } on Exception catch (e) {
      
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
  
  @override
  Future<List<double>> getEmbeddings(Todo todo) async {
    
    return await getIt<LangchainService>().getEmbeddings(todo.toJson().toString());
    // EmbeddingRequest embeddingRequest = EmbeddingRequest(
    //   model: 'text-embedding-ada-002', 
    //   input: todo.toJson().toString()
    // );

    // http.Response response = await http.post(
    //   embeddingsUrl,
    //   headers: headers,
    //   body: jsonEncode(embeddingRequest)
    // );

    // String responseBody = utf8.decode(response.bodyBytes);
    // Map<String, dynamic> json = jsonDecode(responseBody);

    // List<double> embedding = List<double>.from(json['data'][0]['embedding']);

    // return embedding;

  }
}