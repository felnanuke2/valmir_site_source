import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/controller/dashboard_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/widget/menu_drawer_tile_item.dart';

class MenuDrawerTileFilial extends StatefulWidget {
  final String title;
  final double width;

  MenuDrawerTileFilial({
    Key? key,
    required this.title,
    required this.width,
  }) : super(key: key);

  @override
  _MenuDrawerTileFilialState createState() => _MenuDrawerTileFilialState();
}

class _MenuDrawerTileFilialState extends State<MenuDrawerTileFilial> with TickerProviderStateMixin {
  late num fontSize;
  late Animation<double> _boxAnimation;
  late AnimationController _animationController;
  late Animation<double> _arrowAnimation;
  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _boxAnimation = Tween<double>(begin: 50, end: 150)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linearToEaseOut));
    _arrowAnimation = Tween<double>(begin: 0, end: 0.25)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linearToEaseOut));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fontSize = widget.width / 12;
    return AnimatedBuilder(
        animation: _boxAnimation,
        builder: (context, child) {
          return StreamBuilder<int>(
              stream: DashBoardController.pageStream,
              initialData: DashBoardController.currentPageIndex,
              builder: (context, snapshotIndex) {
                return Container(
                  color: _getIfSelected(snapshotIndex.data!) ? Colors.blue.withOpacity(0.4) : null,
                  width: widget.width,
                  height: _boxAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: _toggleExpandable,
                        child: Container(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Tooltip(
                                message: widget.title,
                                child: Icon(Icons.business, color: Colors.grey.shade600),
                              ),
                              if (widget.width > 100)
                                SizedBox(
                                  width: 12,
                                ),
                              if (widget.width > 100)
                                Expanded(
                                    child: Text(
                                  widget.title,
                                  style: TextStyle(
                                      color: Colors.grey.shade800, fontSize: fontSize.toDouble()),
                                )),
                              if (widget.width > 100)
                                RotationTransition(
                                  turns: _arrowAnimation,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      if (_boxAnimation.value > 50)
                        MewnuDrawerTileItem(
                          icons: FontAwesomeIcons.building,
                          index: 1,
                          title: 'Filiais',
                          width: widget.width,
                          height: _getHeight(50, _boxAnimation.value - 50),
                          padding: true,
                        ),
                      if (_boxAnimation.value > 100)
                        MewnuDrawerTileItem(
                          icons: Icons.group,
                          index: 2,
                          title: 'Funcionários',
                          width: widget.width,
                          height: _getHeight(50, _boxAnimation.value - 100),
                          padding: true,
                        ),
                    ],
                  ),
                );
              });
        });
  }

  _toggleExpandable() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  double _getHeight(double maxValue, double current) {
    if (current >= maxValue) return maxValue;
    return current;
  }

  bool _getIfSelected(int index) {
    if (index == 1 || index == 2) {
      if (_boxAnimation.isDismissed) {
        return true;
      }
    }
    return false;
  }
}
