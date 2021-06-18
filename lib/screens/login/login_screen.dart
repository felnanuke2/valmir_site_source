import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:vlalmir_workana_screens/constants/constant_values.dart';
import 'package:vlalmir_workana_screens/screens/login/controller/login_controller.dart';
import 'package:vlalmir_workana_screens/screens/login/widgets/error_field_login.dart';
import 'package:vlalmir_workana_screens/screens/login/widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _userController = TextEditingController();

  var _passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool _userValid = false;

  bool _passwordValid = false;

  StreamController<bool> loginStreamController = StreamController<bool>.broadcast();

  LoginController _loginController = LoginController();
  @override
  void dispose() {
    _loginController.closeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(maxWidth: 360),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //TODO MUDAR PARA IMAGE.NETWORK QUANTO FOR COLOCAR NO SEU DOMINIO
                      // Image.network(LOGO_IMAGE)
                      AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(
                            'assets/logo.jpeg',
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text('ACESSE A SUA CONTA',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 20)),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _userController,
                        buildCounter: _countTextField,
                        maxLength: 100,
                        validator: _validUsername,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(labelText: 'Usuário*'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        maxLength: 50,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: _submitFields,
                        validator: _validPassword,
                        buildCounter: _countTextField,
                        decoration: InputDecoration(labelText: 'Senha*'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ErrorFieldLogin(
                        errorStream: _loginController.errorStream,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      LoginButton(
                        function: () => _submitFields(null),
                        passwordController: _loginController.passworStream.stream,
                        userController: _loginController.userStream.stream,
                        loginController: loginStreamController.stream,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _countTextField(BuildContext context,
      {required int currentLength, required bool isFocused, required int? maxLength}) {
    return Text(
      '$currentLength/$maxLength',
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  String? _validPassword(String? text) {
    //por padrão define que o o campo a ser validado é false e se não houver nenhuma ocorrencia na validação é setado como true no final;
    _passwordValid = false;
    _loginController.passworStream.add(_passwordValid);
    if (text!.isEmpty) return 'Digite uma senha válida';

    //valida o campo de texto como valido e adiciona ao stream controller para liberar o onClick do Botão
    _passwordValid = true;
    _loginController.passworStream.add(_passwordValid);
    return null;
  }

  String? _validUsername(String? text) {
    //por padrão define que o o campo a ser validado é false e se não houver nenhuma ocorrencia na validação é setado como true no final;
    _userValid = false;
    _loginController.userStream.add(_userValid);
    if (text!.isEmpty) return 'Digite uma senha válida';

    //valida o campo de texto como valido e adiciona ao stream controller para liberar o onClick do Botão
    _userValid = true;
    _loginController.userStream.add(_userValid);
    return null;
  }

  Future<bool> _submitFields(String? value) async {
    if (!_formKey.currentState!.validate()) return false;
    loginStreamController.add(true);
//inicia a requisição ao servido para obter o token
    //se contem erro ao tentar logar enive a mensagem para o _errorSink para ele mostrar para o usuário o motivo do erro
    var result = await _loginController.tryLogin(_userController.text, _passwordController.text);

    loginStreamController.add(false);
    if (result) {
      Beamer.of(context).beamToNamed('/dashboard', replaceCurrent: true);
    }
    return result;
  }
}
