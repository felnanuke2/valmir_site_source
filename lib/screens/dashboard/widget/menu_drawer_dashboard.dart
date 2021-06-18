import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:vlalmir_workana_screens/screens/dashboard/controller/dashboard_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/widget/menu_drawer_tile_filia_funcionarios.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/widget/menu_drawer_tile_item.dart';

class MenuDrawerDashBoard extends StatefulWidget {
  final Orientation orientation;
  const MenuDrawerDashBoard({
    Key? key,
    required this.orientation,
  }) : super(key: key);
  @override
  _MenuDrawerDashBoardState createState() => _MenuDrawerDashBoardState();
}

class _MenuDrawerDashBoardState extends State<MenuDrawerDashBoard> with TickerProviderStateMixin {
  late Animation<double> _boxAnimation;
  late Animation<double> _tileAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    DashBoardController.animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    _animationController = DashBoardController.animationController;
    _boxAnimation = Tween<double>(begin: 50, end: 250)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linearToEaseOut));
    _tileAnimation = Tween<double>(begin: 40, end: 200)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linearToEaseOut));
    //so expandira a drawer de inicio caso a orientação seja landscape
    if (widget.orientation == Orientation.landscape) {
      _animationController.forward();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _animationController.forward();
      },
      onExit: (event) {
        _animationController.reverse();
      },
      child: Card(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: AnimatedBuilder(
                animation: _boxAnimation,
                builder: (context, child) {
                  return Container(
                    width: _boxAnimation.value,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            MewnuDrawerTileItem(
                              icons: Icons.home,
                              index: 0,
                              title: 'Home',
                              width: _tileAnimation.value,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MenuDrawerTileFilial(
                              title: 'Filiais/Funcionários',
                              width: _tileAnimation.value,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MewnuDrawerTileItem(
                              icons: FontAwesomeIcons.car,
                              index: 3,
                              title: 'TPRs',
                              width: _tileAnimation.value,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MewnuDrawerTileItem(
                              icons: Icons.settings,
                              index: 4,
                              title: 'Peças',
                              width: _tileAnimation.value,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MewnuDrawerTileItem(
                              icons: FontAwesomeIcons.peopleCarry,
                              index: 5,
                              title: 'Clientes',
                              width: _tileAnimation.value,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MewnuDrawerTileItem(
                              icons: FontAwesomeIcons.fileContract,
                              index: 6,
                              title: 'Contratos',
                              width: _tileAnimation.value,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MewnuDrawerTileItem(
                              icons: FontAwesomeIcons.wrench,
                              index: 7,
                              title: 'Parâmetro',
                              width: _tileAnimation.value,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MewnuDrawerTileItem(
                              icons: FontAwesomeIcons.signOutAlt,
                              index: 8,
                              title: 'Sair',
                              width: _tileAnimation.value,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
