import 'package:flutter/material.dart';
import 'package:vlalmir_workana_screens/modules/auth/hive/hive_auth_helper.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/controller/dashboard_controller.dart';

import 'package:vlalmir_workana_screens/screens/dashboard/widget/dashBoard_pageView.dart';

import 'package:vlalmir_workana_screens/screens/dashboard/widget/menu_drawer_dashboard.dart';

class DashBoardScreen extends StatefulWidget {
  int? index;
  DashBoardScreen({this.index});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String userName = HiveAuthHelper.username!;
  var pageViewUiqueKey = UniqueKey();
  late BuildContext _context;
  @override
  void initState() {
    if (widget.index != null) {
      DashBoardController.currentPage = widget.index!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return OrientationBuilder(builder: (context, orientation) {
      bool isPortrait = MediaQuery.of(context).size.width < 1200;
      return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              StreamBuilder<int>(
                  stream: DashBoardController.pageStream,
                  initialData: DashBoardController.currentPageIndex,
                  builder: (context, snapshotCurrentPage) {
                    return AppBar(
                      actions: [
                        if (DashBoardController.validSeachIndex.contains(snapshotCurrentPage.data!))
                          IconButton(
                              onPressed: () => DashBoardController.delegateSearch(context),
                              icon: Icon(Icons.search)),
                        SizedBox(
                          width: 15,
                        ),
                        if (DashBoardController.validAddIndex.contains(snapshotCurrentPage.data!))
                          IconButton(
                              onPressed: () => DashBoardController.delegateAddButton(),
                              icon: Icon(Icons.add)),
                        SizedBox(
                          width: 12,
                        ),
                      ],
                      leading: IconButton(
                        onPressed: _toggleDrawer,
                        icon: Icon(Icons.menu),
                        tooltip: 'Menu',
                      ),
                      title: Text(
                        userName,
                      ),
                    );
                  }),
              Expanded(
                  child: Stack(children: [
                Positioned(
                    bottom: 0,
                    top: 0,
                    left: 50,
                    right: 0,
                    child: PageViewDashBoard(
                      index: widget.index,
                      key: pageViewUiqueKey,
                    )),
                Positioned(
                    bottom: 0,
                    top: 0,
                    left: 0,
                    child: MenuDrawerDashBoard(
                      orientation: orientation,
                    ))
              ]))
            ],
          ),
        ),
      );
    });
  }

  void _toggleDrawer() {
    if (DashBoardController.animationController.isCompleted) {
      DashBoardController.animationController.reverse();
    } else {
      DashBoardController.animationController.forward();
    }
  }
}
