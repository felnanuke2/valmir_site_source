// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:vlalmir_workana_screens/screens/login/controller/login_controller.dart';

void main() {
  late LoginController loginController;
  setUp(() {
    loginController = LoginController();
  });
  test('Deve retornar false quando o usuário não for autenticado', () async {
    var response = await loginController.tryLogin('apia123', 'apia123');
    expect(response, false);
  });

  test('Deve retornar true quando o usuário  for autenticado com sucesso', () async {
    var response = await loginController.tryLogin('apia', 'apia');
    expect(response, true);
  });
}
