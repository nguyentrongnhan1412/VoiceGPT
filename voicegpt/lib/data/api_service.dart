import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:voicegpt/data/api_consts.dart';
import 'package:voicegpt/data/config_app/setting_data.dart';
import 'package:voicegpt/data/methods.dart';
import 'package:voicegpt/data/prefs/data_local.dart';
import 'package:voicegpt/model/chat_model.dart';
import 'package:voicegpt/model/models_model.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  Future<List<ModelsModel>> getModels();
  Future<ChatModel> sendMessage({required String message});
  Future<bool> checkApiKeyValid(String key);
}

class ApiServiceIpml extends ApiService {
  final SettingData _dataSetting = SettingData();
  String? _apiKey;

  Future<String?> loadKey() {
    DataLocalIpml data = DataLocalIpml();
    return data.apiKey;
  }

  Future<Map> _reponseChat({required String message, String? newKey}) async {
    String keyReponse;

    if (newKey != null) {
      keyReponse = newKey;
    }
    else {
      keyReponse = _apiKey ?? '';
    }

    final response = await http.post(
      Uri.parse('$baseUrl/completions'),
      headers: {
        'Authorization': 'Bearer $keyReponse',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(
        {
          "model": _dataSetting.currentModel.id,
          "prompt": message,
          "max_tokens": newKey == null ? 600 : 5,
        },
      ),
    );
    return jsonDecode(response.body);
  }

  @override
  Future<bool> checkApiKeyValid(String key) async {
    Map json = await _reponseChat(newKey: key, message: 'Hello');
    bool isValid = Methods.getMap(json, 'error').isEmpty;
    log(isValid ? 'ApiKey is valid' : 'ApiKey is invalid');
    return isValid;
  }

  @override
  Future<List<ModelsModel>> getModels() async {
    _apiKey ??= await loadKey();
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/models"),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<Map<String, Object?>> data = Methods.getList(jsonResponse, 'data');

      return data.map((e) => ModelsModel(e)).toList();
    }
    catch (error) {
      log("error $error");
      rethrow;
    }
  }

  @override
  Future<ChatModel> sendMessage({required String message}) async {
    try {
      Map json = await _reponseChat(message: message);
      if (json['error'] != null) {
        throw HttpException(json['error']["message"]);
      }

      Map<String, Object?> data = Methods.getList(json, 'choices').first;
      String msg = Methods.getString(data, 'text');
      String msgUTF8 = utf8.decode(msg.runes.toList()).toString().trim();

      return ChatModel({'msg': msgUTF8, 'chatIndex': 1});
    }
    catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
