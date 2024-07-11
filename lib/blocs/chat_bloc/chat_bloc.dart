import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/domain/interfaces/chatbot_interface.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatbotState> {

  final getIt = GetIt.instance;

  ChatBloc() : super(ChatInitial()) {
    
    on<GetChatResponseEvent>((event, emit) async {
      emit(ChatResponseState(BlocStateType.loading));

      String? response = await getIt<ChatBotInterface>()
          .getResponse(event.message);

      if(response != null){
        emit(ChatResponseState(BlocStateType.success, response: response));
      } else {
        emit(ChatResponseState(BlocStateType.error));
      }
      
    });
  }
}
