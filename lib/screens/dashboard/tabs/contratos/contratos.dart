import 'package:flutter/material.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/contratos/controller/contratos_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/contratos/tabs/assinatura_tab.dart';

class ContratosTab extends StatefulWidget {
  @override
  _ContratosTabState createState() => _ContratosTabState();
}

class _ContratosTabState extends State<ContratosTab> with TickerProviderStateMixin {
  List<String> tabNames = ['Pacote', 'Cliente', 'Veículo', 'Contrato', 'Assinatura', 'Reimpressão'];
  var _contratoController = ContratosController();

  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelPadding: EdgeInsets.all(15),
                tabs: tabNames
                    .map((e) => Text(
                          e,
                          style: TextStyle(color: Colors.black),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                  AssinaturaTab(
                    contratosController: _contratoController,
                    orientation: orientation,
                  ),
                  Container(),
                ])),
          ],
        ),
      );
    });
  }
}
