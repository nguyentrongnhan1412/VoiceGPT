import 'dart:convert';

import 'package:voicegpt/model/language_speak_model.dart';
import 'package:voicegpt/model/language_listen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyPrefsVoiceListen = 'voiceListen';
const String _keyPrefsStatusReponse = 'statusReponse';
const String _keyPrefsVoiceSpeak = 'languageVoiceSpeak';

abstract class _SettingLocal {
  Future<bool?> get isAutoChatReponse;
  Future<void> saveIsAutoChatReponse(bool value);
  Future<LanguageSpeakModel?> get languageSpeak;
  Future<void> saveLanguageSpeak(LanguageSpeakModel voice);
  Future<LanguageListenModel?> get languageListen;
  Future<void> saveLanguageListen(LanguageListenModel voice);
}

class SettingLocal implements _SettingLocal {
  @override
  Future<bool?> get isAutoChatReponse async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPrefsStatusReponse);
  }

  @override
  Future<LanguageListenModel?> get languageListen async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_keyPrefsVoiceListen)) {
      String str = prefs.getString(_keyPrefsVoiceListen)!;
      Map<String, Object> data = jsonDecode(str);
      return LanguageListenModel(data);
    }
    return null;
  }

  @override
  Future<LanguageSpeakModel?> get languageSpeak async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_keyPrefsVoiceSpeak)) {
      String str = prefs.getString(_keyPrefsVoiceSpeak)!;
      Map<String, Object> data = jsonDecode(str);
      return LanguageSpeakModel(data);
    }
    return null;
  }

  @override
  Future<void> saveIsAutoChatReponse(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPrefsStatusReponse, value);
  }

  @override
  Future<void> saveLanguageListen(LanguageListenModel voice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listObjectEncode = jsonEncode(voice.data);
    await prefs.setString(_keyPrefsVoiceListen, listObjectEncode);
  }

  @override
  Future<void> saveLanguageSpeak(LanguageSpeakModel voice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listObjectEncode = jsonEncode(voice.data);
    await prefs.setString(_keyPrefsVoiceSpeak, listObjectEncode);
  }
  
}