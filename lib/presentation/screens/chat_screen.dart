import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:todo_app/blocs/chat_bloc/chat_bloc.dart';
import 'package:todo_app/core/bloc_state_type.dart';

import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  
  final List<types.Message> _messages = [];

  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  final _chatbot = const types.User(
    id: '12391001-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: 'Chatbot',
  );


  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatbotState>(
      listener: (context, state) {
        
        if(state is ChatResponseState && state.blocStateType == BlocStateType.success){
          
          final reply = types.TextMessage(
            author: _chatbot,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: state.response!,
          );

          _addMessage(reply);
        }

      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
          ),
          body: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: _user,
              theme: const DefaultChatTheme(
                inputTextDecoration: InputDecoration(
                  filled: false,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                seenIcon: Text(
                  'read',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
            ),
        ),
    );
  }


  @override
  void initState() {
    super.initState();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }


  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    BlocProvider.of<ChatBloc>(context)
    .add(GetChatResponseEvent(message.text));

  }


}