import 'package:beamer/beamer.dart';
import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vlalmir_workana_screens/constants/constant_values.dart';

class HiveAuthHelper {
  HiveAuthHelper._();
  static late Box<String> _authBox;
  static String? acessToken;
  static String? username;
  static String? idFranqueado;
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
    idFranqueado = _authBox.get(ID_FRANQUEADO);
    print(idFranqueado);
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

  static setAcessToken(
      String token,
      String name,
      String idFuncionario,
      String descricaoFuncionario,
      String email,
      String idFranqueado,
      String descricaoFranqueado,
      String nbf,
      String exp,
      String iat) {
    acessToken = token;
    username = name;
    idFranqueado = idFranqueado;
    //this create a expire time
    var expireAt = DateTime.now().millisecondsSinceEpoch + Duration(minutes: 30).inMilliseconds;
    _authBox.put(ACCESS_TOKEN, acessToken!);
    _authBox.put(USER_NAME, username!);
    _authBox.put(TOKEN_EXPITE_AT, expireAt.toString());
    _authBox.put(ID_FUNCIONARIO, idFuncionario);
    _authBox.put(DESCRICAO_FUNCIONARIO, descricaoFuncionario);
    _authBox.put(EMAIL, email);
    _authBox.put(ID_FRANQUEADO, idFranqueado);
    _authBox.put(DESCRICAO_FRANQUEADO, descricaoFranqueado);
    _authBox.put(NBF, nbf);
    _authBox.put(EXP, exp);
    _authBox.put(IAT, iat);
  }

  static clearCurrentUser() async {
    await _authBox.clear();
    acessToken = null;
    username = null;
  }
}
