import 'package:flutter/material.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/controller/dashboard_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/clientes.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/contratos/contratos.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/filiais_tab.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/screen/funcionario_navigator_screens.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/home_tab.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/parametro_tab.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/pe%C3%A7as_tab.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/tprs_tab.dart';

class PageViewDashBoard extends StatefulWidget {
  PageViewDashBoard({Key? key, this.index}) : super(key: key);
  int? index;

  @override
  _PageViewDashBoardState createState() => _PageViewDashBoardState();
}

class _PageViewDashBoardState extends State<PageViewDashBoard> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: DashBoardController.pageController =
          PageController(initialPage: widget.index ?? 0),
      children: [
        HomeTab(),
        FiliaisTab(),
        FuncionarioNavigatorScreen(),
        TPRSTab(),
        PecasTab(),
        ClientesTab(),
        ContratosTab(),
        ParametroTab(),
      ],
    );
  }
}
