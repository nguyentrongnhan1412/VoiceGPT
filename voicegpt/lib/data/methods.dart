extension Find<K, V, R> on Map<K, V>{

  R find(String key, R Function(String value) cast, {Object? defaultValue}){
    try{
      final value = this[key];
      if (value != null) {
        return cast(value.toString());
      }
      else {
        if (defaultValue != null) {
          return cast(defaultValue.toString());
        }
      }
    }
    catch(_){
      return cast(defaultValue.toString());
    }
    return cast(defaultValue.toString());
  }

  R findData<T>(String key, R Function(T value) cast, {Object? defaultValue}) {
    R defaultTemp = cast(defaultValue as T);
    try {
      final value = this[key];
      if (value != null && value is T) {
        return cast(value as T);
      } else {
        if (defaultValue != null) {
          return defaultTemp;
        }
      }
    } catch (_) {
      return defaultTemp;
    }
    return defaultTemp;
  }
}

class Methods {
  Methods._();

  static double getDouble(Map data, String fieldName, {double defaultValue = 0.0}) {
    return data.find(fieldName, (value) => double.parse(value), defaultValue: defaultValue);
  }

  static int getInt(Map data, String fieldName, {int defaultValue = 0}) {
    return data.find(fieldName, (value) => double.parse(value).toInt(), defaultValue: defaultValue);
  }

  static int getIntRound(Map data, String fieldName, {int defaultValue = 0}) {
    return data.find(fieldName, (value) => double.parse(value).round(), defaultValue: defaultValue);
  }

  static String getString(Map data, String fieldName, {String defaultValue = ''}) {
    return data.find(fieldName, (value) => value, defaultValue: defaultValue);
  }

  static bool getBool(Map data, String fieldName, {bool defaultValue = false}) {
    return data.find(fieldName, (value) {
      if (value == 'true' || value == '1') {
        return true;
      }
      return false;
    });
  }

  static List getDynamic(Map data, String fieldName) {
    return data.findData(fieldName, (value) => value, defaultValue: []);
  }

  static int convertToInt(Map data, String fieldName) {
    return data.find(fieldName, (value) => value.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  static Map<String, Object?> getMap(Map data, String fieldName) {
    return data.findData(fieldName, (value) => value, defaultValue: Map<String, Object?>.from({}));
  }

  static List<Map<String, Object?>> getList(Map data, String fieldName) {
    List<Map<String, Object?>> lst = [];
    try {
      if (data.containsKey(fieldName)) {
        List<dynamic> lstObj = data[fieldName] as List<dynamic>;
        if (lstObj.isNotEmpty) {
          for (int index = 0; index < lstObj.length; index++) {
            Map<String, Object?> map = lstObj[index];
            lst.add(map);
          }
        }
        return lst;
      }
      return lst;
    }
    catch (e) {
      return lst;
    }
  }

  static String getFileName(String fullPath) {
    String fileName = fullPath;
    if (fullPath.contains('/')) {
      var arr = fullPath.split('/');
      fileName = arr[arr.length - 1];
    }
    return fileName;
  }


  static String preparePhone(String phone) {
    String phoneNumber = phone;
    if (phone.startsWith('0')) {
      phoneNumber = '+84${phone.substring(1)}';
    } else if (phone.startsWith('84')) {
      phoneNumber = '+$phone';
    } else if (!phone.startsWith('+84')) {
      phoneNumber = '+84$phone';
    }
    return phoneNumber;
  }

  static List<int> getListInt(Map? data, String key) {
    List<int> lst = [];
    if (data == null) return lst;
    try {
      var arrKeys = key.split('.');
      if (arrKeys.length == 2) {
        if (data.containsKey(arrKeys[0])) {
          List<dynamic> lstObj = data[arrKeys[0]] as List<dynamic>;
          if (lstObj.isNotEmpty) {
            for (int index = 0; index < lstObj.length; index++) {
              Map map = lstObj[index];
              lst.add(getInt(map, arrKeys[1], defaultValue: 0));
            }
          }
          return lst;
        }
      }
      else {
        List<dynamic> lstObj = data[key] as List<dynamic>;
        if (lstObj.isNotEmpty) {
          for (int index = 0; index < lstObj.length; index++) {
            lst.add(toInt(lstObj[index].toString()));
          }
        }
      }
      return lst;
    }
    catch (e) {
      return lst;
    }
  }

  static int toInt(String? s, {bool isFloor = true, int defaultValue = 0}) {
    if (s == null) return defaultValue;
    try {
      if (s == '' || s == 'null') {
        return defaultValue;
      }
      double d = toDouble(s);
      if (isFloor) {
        return d.floor();
      } else {
        return int.parse(s);
      }
    }
    catch (e) {
      return defaultValue;
    }
  }

  static double toDouble(String? s, {double defaultValue = 0}) {
    if (s == null) return defaultValue;
    try {
      if (s == '' || s == 'null') {
        return defaultValue;
      }
      double d = double.parse(s);
      return d;
    }
    catch (e) {
      return defaultValue;
    }
  }

}