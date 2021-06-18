import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/controller/funcionario_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/funcionarios_tab.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/screen/crudForm/crud_funcionario_screen.dart';

class FuncionarioNavigatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: FuncionarioController.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => FuncionariosTab(),
        );
      },
    );
  }
}
