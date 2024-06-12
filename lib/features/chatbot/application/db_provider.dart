import 'dart:developer';

import 'package:gemini_api_challenge/core/utils/database.dart';
import 'package:gemini_api_challenge/features/chatbot/data/chat_data.dart';
import 'package:sembast/sembast.dart';

class DbProvider {
  final _mainStore = StoreRef.main();

  final String _chatHistory = 'chat_history';

  Future<Database> get _db async => await AppDatabase.instance.database;

  void storeHistory(List<ChatModel> chatHistory) async {
    List<Map<String, dynamic>> data = [];
    for (var element in chatHistory) {
      data.add(element.toJson());
    }
    _mainStore.record(_chatHistory).put(await _db, {'chat_history': data});
  }

  Future<List<ChatModel>?> fetchHistory() async {
    try {
      final record = await _mainStore.record(_chatHistory).get(await _db)
          as Map<String, dynamic>?;
      if (record != null && record.isNotEmpty) {
        List<ChatModel> chats = [];
        for (var element in record['chat_history']) {
          chats.add(ChatModel.fromJson(element));
        }
        return chats;
      }
    } catch (e) {
      log('error', error: e);
    }
    return null;
  }

  void deleteHistory() async {
    _mainStore.record(_chatHistory).delete(await _db);
  }
}
