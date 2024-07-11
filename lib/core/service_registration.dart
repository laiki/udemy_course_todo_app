import 'package:get_it/get_it.dart';
import 'package:todo_app/domain/interfaces/chatbot_interface.dart';
import 'package:todo_app/domain/interfaces/tag_db_interface.dart';
import 'package:todo_app/domain/interfaces/todo_db_interface.dart';
import 'package:todo_app/domain/interfaces/vector_db_interface.dart';
import 'package:todo_app/domain/services/chatbot_service.dart';
import 'package:todo_app/domain/services/langchain_service.dart';
import 'package:todo_app/domain/services/tag_firestore_service.dart';
import 'package:todo_app/domain/services/todo_firestore_service.dart';
import 'package:todo_app/domain/services/vector_db_service.dart';

import '../domain/interfaces/authentication_interface.dart';
import '../domain/services/firebase_auth_service.dart';

final getIt = GetIt.instance;

Future init() async{

  getIt.registerSingleton<AuthenticationInterface>(FirebaseAuthService());
  
  getIt.registerLazySingleton<TodoDBInterface>(() => TodoFirestoreService());
  getIt.registerLazySingleton<TagDBInterface>(() => TagFirestoreService());
  
  getIt.registerLazySingleton(() => LangchainService());
  getIt.registerLazySingleton<VectorDBInterface>(() => VectorDBService());
  getIt.registerLazySingleton<ChatBotInterface>(() => ChatbotService());


}