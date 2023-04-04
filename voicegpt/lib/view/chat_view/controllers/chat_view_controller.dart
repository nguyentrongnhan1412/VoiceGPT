import 'dart:developer';
import 'package:voicegpt/data/api_service.dart';
import 'package:voicegpt/data/config_app/setting_data.dart';
import 'package:voicegpt/data/config_app/config_audio.dart';
import 'package:voicegpt/data/prefs/data_local.dart';
import 'package:voicegpt/model/chat_model.dart';
import 'package:voicegpt/model/models_model.dart';
import 'package:flutter/cupertino.dart';


abstract class ChatViewControllerInput {
  Future<void> send({required String msg, void Function()? onInput});
  Future<List<ModelsModel>> loadModelsModel();
  Future<List<ChatModel>> loadLocalChat();
  Future<void> clearChat();
}

abstract class ChatViewControllerOutput {
  List<ChatModel> get chatList;
  List<ModelsModel> get modelsList;
}

class ChatViewController with ChangeNotifier, ChatViewControllerInput, ChatViewControllerOutput {
  final List<ChatModel> _chatList = [];
  ValueNotifier<bool> isTyping = ValueNotifier<bool>(false);
  final SettingData _setting = SettingData();
  final ConfigAudio _configAudio = ConfigAudio();
  final ApiServiceIpml _api = ApiServiceIpml();
  final DataLocalIpml _localPrefs = DataLocalIpml();

  set chatList(List<ChatModel> list) {
    _chatList.addAll(list);
    notifyListeners();
  }

  set listModelsModel(List<ModelsModel> list) {
    _setting.listModelsModel = list;
  }

  Future<void> speak(String msg) async {
    await _configAudio.speak(msg);
  }

  void stop() async {
    await _configAudio.stop();
  }

  @override
  List<ChatModel> get chatList => _chatList;

  @override
  Future<void> clearChat() async {
    _localPrefs.clearDataChat();
    _chatList.clear();
    if (_configAudio.statusAudio != StatusAudio.stopped) {
      stop();
    }
    notifyListeners();
  }

  @override
  Future<List<ChatModel>> loadLocalChat() {
    return _localPrefs.listChat();
  }

  @override
  Future<List<ModelsModel>> loadModelsModel() async => await _api.getModels();

  @override
  List<ModelsModel> get modelsList => _setting.listModelsModel;

  @override
  Future<void> send({required String msg, void Function()? onInput}) async {
    log(_configAudio.currentLanguageListen.data.toString());
    _chatList.add(ChatModel({'msg': msg, 'chatIndex': 0}));
    onInput?.call();
    isTyping.value = true;
    notifyListeners();
    ChatModel gptReponse = await _api.sendMessage(message: msg,);
    _chatList.add(gptReponse);
    isTyping.value = false;
    await _localPrefs.saveChat(_chatList);
    if (_configAudio.isAutoReponse) {
      speak(gptReponse.msg);
    }
    notifyListeners();
  }
}