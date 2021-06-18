import 'dart:html';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:vlalmir_workana_screens/modules/auth/hive/hive_auth_helper.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/controller/dashboard_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/dashboard_screen.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/controller/funcionario_controller.dart';
import 'package:vlalmir_workana_screens/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveAuthHelper.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (DashBoardController.currentPageIndex == -1) {
          FuncionarioController.navigatorKey.currentState!.pop();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: MaterialApp.router(
        title: 'Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routeInformationParser: BeamerParser(),
        routerDelegate: BeamerDelegate(
            initialPath: HiveAuthHelper.acessToken == null ? '/login' : '/dashboard',
            locationBuilder: SimpleLocationBuilder(routes: {
              '/login': (_, __) => LoginScreen(),
              '/dashboard': (_, __) => DashBoardScreen(),
              '/dashboard/:tab': (_, state) {
                String? tab = state.pathParameters['tab'];

                if (tab == null) return null;
                var regExp = RegExp('[0-9]');
                if (regExp.allMatches(tab).toString().isEmpty) return null;
                int index = int.parse(tab);
                return DashBoardScreen(
                  index: index,
                );
              }
            }),
            guards: [
              BeamGuard(
                pathBlueprints: ['/dashboard'] + dashBoardListIndex,
                check: (context, location) {
                  return HiveAuthHelper.acessToken != null;
                },
                beamToNamed: '/login',
              )
            ]),
      ),
    );
  }

  List<String> dashBoardListIndex = List.generate(8, (index) => '/dashboard/$index');
}
