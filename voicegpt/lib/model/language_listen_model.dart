import 'package:voicegpt/data/methods.dart';
import 'package:voicegpt/model/base_model.dart';

class LanguageListenModel extends BaseModel {
  LanguageListenModel(super.data);

  String get name => Methods.getString(data, 'name');
  String get locale => Methods.getString(data, 'locale');
  String get displayName => Methods.getString(data, 'displayName');

  @override
  bool operator ==(Object other) => identical(this, other) || other is LanguageListenModel && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

extension CovertModelData on LanguageListenModel {
  Map<String, String> toNewData() {
    Map<String, String> temp = {...data};
    temp.removeWhere((key, value) => key == 'displayName');
    return temp;
  }
}