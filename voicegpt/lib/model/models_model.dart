import 'package:voicegpt/model/base_model.dart';
import 'package:voicegpt/data/methods.dart';

class ModelsModel extends BaseModel {
  ModelsModel(super.data);

  String get id => Methods.getString(data, 'id');
  int get created => Methods.getInt(data, 'created');
  String get root => Methods.getString(data, 'root');

  @override
  String toString() {
    return 'id: $id, created: $created, root: $root';
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ModelsModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}