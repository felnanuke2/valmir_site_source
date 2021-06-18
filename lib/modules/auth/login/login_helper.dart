import 'dart:async';
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:vlalmir_workana_screens/constants/constant_values.dart';
import 'package:vlalmir_workana_screens/modules/auth/hive/hive_auth_helper.dart';

class LoginHelper {
  static Future<bool> tryLogin(
      String user, String password, StreamController<String?> errorController) async {
    //Base_URL foi provém do  arquivo lib/constants/constant_values.dart
    final String url = '$BASE_API_URL/back/api/account/login';
    //aqui começa a requisição para o servidor

    final request = await http.post(Uri.parse(url),
        headers: {'content-type': APPLIICATION_JSON},
        body: jsonEncode({
          USER_LOGIN: user,
          PASSWORD_LOGIN: password,
        }));
    if (request.statusCode == 200) {
      // o codigo for 200 o token é armazenado e o usuario é direcionado para a tela dashboard
      var map = jsonDecode(request.body);
      String token = map[SERVER_ACCESS_TOKEN];
      await HiveAuthHelper.setAcessToken(token, user);
      //deve retornar true para redirecionar a pagina
      return true;
    }
    // caso seja diferente de 200 a mensagem de erro deve ser passada no stream que vai mostrar o erro para o cliente
    errorController.sink.add('E-mail ou senha inválidos');
    //deve retornar falso
    return false;
  }

  static logOut(BuildContext context) {
    //limpa toda a box de autenticação
    HiveAuthHelper.clearCurrentUser();
    //retorna o usuario para a pagina de login
    Beamer.of(context).beamToNamed(
      '/login',
      replaceCurrent: true,
    );
  }
}
