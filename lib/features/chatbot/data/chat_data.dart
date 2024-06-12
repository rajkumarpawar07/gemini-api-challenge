enum ChatFrom { bot, user }

class ChatModel {
  final String content;
  final ChatFrom chatFrom;

  ChatModel({
    required this.content,
    required this.chatFrom,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'chatFrom': chatFrom.name,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      content: map['content'],
      chatFrom: ChatFrom.values.byName(map['chatFrom']),
    );
  }
}
