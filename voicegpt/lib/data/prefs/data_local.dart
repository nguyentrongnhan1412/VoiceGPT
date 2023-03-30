import 'dart:convert';
import 'package:voicegpt/model/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyPrefsApiKey = 'ApiKey';
const String _keyPrefsListVoice = 'listVoice';
const String _keyPrefsChat = 'chat';

abstract class _DataLocal {
  Future<List<String>> get listVoice;
  Future<void> saveListVoice(List<String> list);
  Future<String?> get apiKey;
  Future<void> saveApiKey(String apiKey);
  Future<void> clear();
  Future<List<ChatModel>?> listChat();
  Future<void> saveChat(List<ChatModel> list);
  Future<void> clearDataChat();
}

class DataLocalIpml implements _DataLocal{
  @override
  Future<String?> get apiKey async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPrefsApiKey);
  }

  @override
  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Future<void> clearDataChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyPrefsChat);
  }

  @override
  Future<List<ChatModel>> listChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_keyPrefsChat) != null) {
      List<dynamic> list = jsonDecode(prefs.getString(_keyPrefsChat)!);
      return list.map((e) => ChatModel(e)).toList();
    }
    return [];
  }

  @override
  Future<List<String>> get listVoice async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyPrefsListVoice) ?? [];
  }

  @override
  Future<void> saveApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyPrefsApiKey, apiKey);
  }

  @override
  Future<void> saveChat(List<ChatModel> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, Object?>> listObject = list.map((e) => e.data).toList();
    String listObjectEncode = jsonEncode(listObject);
    await prefs.setString(_keyPrefsChat, listObjectEncode);
  }

  @override
  Future<void> saveListVoice(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_keyPrefsListVoice, list);
  }
  
}