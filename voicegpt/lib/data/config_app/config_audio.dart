import 'dart:math';

import 'package:voicegpt/data/prefs/setting_local.dart';
import 'package:voicegpt/model/language_listen_model.dart';
import 'package:voicegpt/model/language_speak_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum StatusAudio { playing, stopped, paused, continued }

LanguageListenModel _defaultLanguageListen = _defaultListLanguageListen[3];

List<LanguageListenModel> _defaultListLanguageListen = [
  {
    'name': 'vi-VN-language',
    'locale': 'vi-VN',
    'displayName': 'VN',
  },
  {
    'name': 'en-us-x-tpf-local',
    'locale': 'en-US',
    'displayName': 'EN-US',
  },
  {
    'name': 'en-us-x-sfg-network',
    'locale': 'en-US',
    'displayName': 'EN-US 2'
  },
  {
    'name': 'en-us-x-tpd-network',
    'locale': 'en-US',
    'displayName': 'EN-US 3'
  },
  {
    'name': 'en-us-x-tpc-network',
    'locale': 'en-US',
    'displayName': 'EN-US 4'
  },
  {
    'name': 'en-gb-x-gba-local',
    'locale': 'en-GB',
    'displayName': 'EN-EN'
  },
  {
    'name': 'en-gb-x-gbb-network',
    'locale': 'en-GB',
    'displayName': 'EN-EN 2'
  },
  {
    'name': 'en-gb-x-rjs-local',
    'locale': 'en-GB',
    'displayName': 'EN-EN 3'
  },
  {
    'name': 'en-gb-x-gbg-local',
    'locale': 'en-GB',
    'displayName': 'EN-EN 4'
  },
].map((e) => LanguageListenModel(e)).toList();

LanguageSpeakModel _defaulLanguageSpeak = _defaultListLanguageSpeak.first;

List<LanguageSpeakModel> _defaultListLanguageSpeak = [
  {
    'locale': 'en_US',
    'name': 'EN-US',
  },
  {
    'locale': 'vi_VN',
    'name': 'VN',
  },
  {
    'locale': 'en_GB',
    'name': 'EN-EN',
  }
].map((e) => LanguageSpeakModel(e)).toList();


class ConfigAudio {
  static final ConfigAudio _instance = ConfigAudio._internal();

  factory ConfigAudio() {
    return _instance;
  }

  late FlutterTts _flutterTts;
  late StatusAudio statusAudio;
  late bool isAutoReponse;
  late double volumn;
  late double pitch;
  late double rate;
  late List<LanguageListenModel> listLanguageListen;
  late LanguageListenModel currentLanguageListen;
  late LanguageSpeakModel currentLanguageSpeak;
  late List<LanguageSpeakModel> listLanguageSpeak;

  ConfigAudio._internal() {
    _flutterTts = FlutterTts();
    currentLanguageListen = _defaultLanguageListen;
    listLanguageListen = _defaultListLanguageListen;
    statusAudio = StatusAudio.stopped;
    isAutoReponse = true;
    volumn = 0.8;
    pitch = 0.8;
    rate = 0.5;
    listLanguageSpeak = _defaultListLanguageSpeak;
    currentLanguageSpeak = _defaulLanguageSpeak;
  }

  Future<void> initAudio() async {
    SettingLocal dataLocal = SettingLocal();
    isAutoReponse = await dataLocal.isAutoChatReponse ?? isAutoReponse;
    currentLanguageListen = await dataLocal.languageListen ?? currentLanguageListen;
    await _flutterTts.awaitSpeakCompletion(true);
    currentLanguageSpeak = await dataLocal.languageSpeak ?? currentLanguageSpeak;
  }

  Future<void> updateVolumn(double value) async {
    volumn = value;
    await _flutterTts.setVolume(volumn);
  }

  Future<void> updateLanguageListen(LanguageListenModel voice) async {
    SettingLocal save = SettingLocal();
    await save.saveLanguageListen(voice);
    currentLanguageListen = voice;
    await _flutterTts.setVoice(voice.toNewData());
  }

  Future<void> updateLanguageSpeak(LanguageSpeakModel speakModel) async {
    SettingLocal save = SettingLocal();
    await save.saveLanguageSpeak(speakModel);
    currentLanguageSpeak = speakModel;
  }

  Future<void> updateRate(double value) async {
    rate = value;
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> updatePitch(double value) async {
    double convertPitch = max(0.5, pitch / 2);
    await _flutterTts.setPitch(convertPitch);
  }

  Future<void> updateAutoReponse(bool value) async {
    SettingLocal save = SettingLocal();
    await save.saveIsAutoChatReponse(value);
    isAutoReponse = value;
  }

  Future<void> stop() async {
    statusAudio = StatusAudio.stopped;
    await _flutterTts.stop();
  }

  Future<void> speak(String voiceText) async {
    if (statusAudio != StatusAudio.stopped) {
      await stop();
    }
    else {
      statusAudio = StatusAudio.playing;
      await _flutterTts.speak(voiceText);
    }
  }

  Future<void> pause() async {
    statusAudio = StatusAudio.paused;
    await _flutterTts.pause();
  }
}
