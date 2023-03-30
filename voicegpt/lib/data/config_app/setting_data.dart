import 'package:voicegpt/model/models_model.dart';

class SettingData {
  static final SettingData _instance = SettingData._internal();

  factory SettingData() {
    return _instance;
  }

  SettingData._internal() {
    listModelsModel = [];
    currentModel = _defaultModelsModel;

  }

  late List<ModelsModel> listModelsModel;
  late ModelsModel currentModel;
}

ModelsModel _defaultModelsModel = ModelsModel({
  'id': 'text-davinci-003',
  'created': 1669599635,
  'root': 'text-davinci-003',
});