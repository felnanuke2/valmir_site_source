import 'dart:async';
import 'package:vlalmir_workana_screens/modules/auth/login/login_helper.dart';

class LoginController {
  final passworStream = StreamController<bool>.broadcast();
  final userStream = StreamController<bool>.broadcast();
  final _errorStream = StreamController<String?>.broadcast();
  Stream<String?> get errorStream => _errorStream.stream.asyncMap((event) {
        //os eventos são o que o stream controller recebe do submitedField
        // o motivo de usar streams com async é que quando você recebe mensagens de erros você pode trata-las de maneira asíncrona
        //explico: Caso o banco de dados envie erros usando códigos você pode tratar os erros aqui e mostrar de maneira mais eficiente pro usuário

        // return 'E-mail ou Senha inválidos';

        return event;
      });

  set errorSink(String? string) => _errorStream.sink.add(string);

  void closeStreams() {
    passworStream.close();
    userStream.close();
    _errorStream.close();
  }

  Future<bool> tryLogin(String user, String password) async {
    return await LoginHelper.tryLogin(user, password, _errorStream);
  }
}
