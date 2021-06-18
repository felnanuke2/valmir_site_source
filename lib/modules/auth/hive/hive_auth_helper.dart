import 'package:beamer/beamer.dart';
import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vlalmir_workana_screens/constants/constant_values.dart';

class HiveAuthHelper {
  HiveAuthHelper._();
  static late Box<String> _authBox;
  static String? acessToken;
  static String? username;
  static Future<void> init() async {
    await Hive.initFlutter();
    await _verifyToken();
    return;
  }

  static _verifyToken() async {
    _authBox = await Hive.openBox(AUTH_BOX);
    var expireDate = _authBox.get(TOKEN_EXPITE_AT);
    if (!compareTime(expireDate)) return;
    acessToken = _authBox.get(ACCESS_TOKEN);
    username = _authBox.get(USER_NAME);
  }

  static bool compareTime(String? timeString) {
    if (timeString == null) {
      clearCurrentUser();
      return false;
    }
    var isValid =
        DateTime.now().compareTo(DateTime.fromMillisecondsSinceEpoch(int.parse(timeString)));
    if (isValid < 0) return true;
    clearCurrentUser();
    return false;
  }

  static setAcessToken(String token, String name) {
    acessToken = token;
    username = name;
    //this create a expire time
    var expireAt = DateTime.now().millisecondsSinceEpoch + Duration(minutes: 30).inMilliseconds;
    _authBox.put(ACCESS_TOKEN, acessToken!);
    _authBox.put(USER_NAME, username!);
    _authBox.put(TOKEN_EXPITE_AT, expireAt.toString());
  }

  static clearCurrentUser() async {
    await _authBox.clear();
    acessToken = null;
    username = null;
  }
}
