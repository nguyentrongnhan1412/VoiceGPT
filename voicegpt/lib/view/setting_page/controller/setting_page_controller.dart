import 'package:voicegpt/data/config_app/setting_data.dart';
import 'package:voicegpt/data/config_app/config_audio.dart';
import 'package:voicegpt/data/prefs/data_local.dart';
import 'package:voicegpt/model/language_listen_model.dart';
import 'package:voicegpt/model/language_speak_model.dart';
import 'package:voicegpt/model/models_model.dart';
import 'package:flutter/cupertino.dart';

class SettingPageController extends ChangeNotifier {
  final SettingData _setting = SettingData();
  final ConfigAudio _configAudio = ConfigAudio();

  List<ModelsModel> get listModelsModel => _setting.listModelsModel;

  ModelsModel get currentModel => _setting.currentModel;

  set currentModel(ModelsModel newModel) {
    _setting.currentModel = newModel;
  }
  List<LanguageSpeakModel> get listLanguageSpeak => _configAudio.listLanguageSpeak;

  LanguageSpeakModel get currentLanguageSpeak => _configAudio.currentLanguageSpeak;

  set currentLanguageSpeak(LanguageSpeakModel newLanguage) {
    _configAudio.updateLanguageSpeak(newLanguage);
  }

  List<LanguageListenModel> get listLanguageListen => _configAudio.listLanguageListen;

  LanguageListenModel get currentLanguageListen => _configAudio.currentLanguageListen;

  set currentLanguageListen(LanguageListenModel newVoice) {
    _configAudio.updateLanguageListen(newVoice);
  }

  double get pitch => _configAudio.pitch;

  set pitch(double newValue) {
    _configAudio.updatePitch(newValue);
  }

  double get volumn => _configAudio.volumn;

  set volumn(double newValue) {
    _configAudio.updateVolumn(newValue);
  }

  double get rate => _configAudio.rate;

  set rate(double newValue) {
    _configAudio.updateRate(newValue);
  }

  bool get autoChatReponse => _configAudio.isAutoReponse;

  set autoChatReponse(bool newValue) {
    _configAudio.updateAutoReponse(newValue);
  }

  Future<void> logout() async {
    DataLocalIpml dataLocal = DataLocalIpml();
    if (_configAudio.statusAudio != StatusAudio.stopped) {
      await _configAudio.stop();
    }
    await dataLocal.clear();
  }
}