import 'dart:async';

import 'package:gemini_api_challenge/core/data/bloc_interface.dart';
import 'package:gemini_api_challenge/features/chatbot/data/chat_data.dart';
import 'package:gemini_api_challenge/features/chatbot/data/chat_data_state.dart';

class ChatBloc implements BlocInterface {
  final StreamController<ChatDataState> _controller =
      StreamController.broadcast();

  Stream<ChatDataState> get chatStream => _controller.stream;

  final List<ChatModel> _chatHistory = [];

  void initialize() {
    _chatHistory.addAll([
      ChatModel(
        content:
            '1. This sunbird has an injury on its leg. It requires care from a hospital.',
        chatFrom: ChatFrom.bot,
      ),
      ChatModel(
        content:
            '2. This sunbird has an injury on its leg. It requires care from a hospital.',
        chatFrom: ChatFrom.user,
      ),
      ChatModel(
        content:
            '3. This sunbird has an injury on its leg. It requires care from a hospital.',
        chatFrom: ChatFrom.bot,
      )
    ]);
    _controller.sink.add(
        ChatDataState(status: ChatBotStatus.initial, history: _chatHistory));
  }

  void addEvent(String userPrompt) {
    _controller.sink.add(ChatDataState(
      history: _chatHistory
        ..add(ChatModel(content: userPrompt, chatFrom: ChatFrom.user)),
      status: ChatBotStatus.processing,
    ));
    _processRequest(userPrompt);
  }

  void _processRequest(String userPrompt) {
    //TODO: process gemini Api Response here
    var result = 'Bot Response';
    _controller.sink.add(ChatDataState(
      history: _chatHistory
        ..add(ChatModel(content: result, chatFrom: ChatFrom.bot)),
      status: ChatBotStatus.success,
    ));
  }

  @override
  void dispose() {
    _controller.close();
  }
}
