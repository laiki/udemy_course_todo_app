part of 'chat_bloc.dart';

sealed class ChatbotState {
  final BlocStateType blocStateType;

  ChatbotState(this.blocStateType);
}

final class ChatInitial extends ChatbotState {
  ChatInitial() : super(BlocStateType.success);
}

final class ChatResponseState extends ChatbotState {
  final String? response;

  ChatResponseState(super.blocStateType, {this.response});
}
