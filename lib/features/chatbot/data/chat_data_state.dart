import 'chat_data.dart';

enum ChatBotStatus { initial, processing, error, success }

class ChatDataState {
  final ChatBotStatus status;
  final List<ChatModel> history;

  const ChatDataState({
    required this.status,
    required this.history,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'history': history.map((e) => e.toJson()),
    };
  }

  factory ChatDataState.fromMap(Map<String, dynamic> map) {
    return ChatDataState(
      status: map['status'] as ChatBotStatus,
      history: map['history'] as List<ChatModel>,
    );
  }
}
