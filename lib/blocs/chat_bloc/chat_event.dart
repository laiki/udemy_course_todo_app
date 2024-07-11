part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class GetChatResponseEvent implements ChatEvent {
  final String message;

  GetChatResponseEvent(this.message);
}
