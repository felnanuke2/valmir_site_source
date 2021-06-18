import 'package:flutter/material.dart';
import 'package:vlalmir_workana_screens/modules/auth/login/login_helper.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/controller/dashboard_controller.dart';

class MewnuDrawerTileItem extends StatelessWidget {
  final IconData icons;
  final int index;
  final String title;
  final double width;
  double? height;
  bool? padding;

  late num fontSize;
  late BuildContext _context;
  late Orientation _orientation;

  MewnuDrawerTileItem(
      {Key? key,
      required this.icons,
      required this.index,
      required this.title,
      required this.width,
      this.height,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    fontSize = width / 12;
    return OrientationBuilder(builder: (context, orientation) {
      _orientation = orientation;
      return Center(
        child: InkWell(
          //todo implements pageviewhere
          onTap: _movePage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: StreamBuilder<int>(
                stream: DashBoardController.pageStream,
                initialData: DashBoardController.currentPageIndex,
                builder: (context, snapshotCurrentPage) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    color: snapshotCurrentPage.data! == index ? Colors.blue.withOpacity(0.4) : null,
                    margin: EdgeInsets.only(left: padding == true ? _getPadding(25, width) : 0),
                    height: height != null ? height : 50,
                    width: width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: title,
                          child: Icon(
                            icons,
                            color: Colors.grey.shade600,
                            size: height != null ? height! / 2.083333333 : null,
                          ),
                        ),
                        if (width > 100)
                          SizedBox(
                            width: 12,
                          ),
                        if (width > 100)
                          Expanded(
                              child: Text(
                            title,
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: fontSize.toDouble()),
                          ))
                      ],
                    ),
                  );
                }),
          ),
        ),
      );
    });
  }

  _getPadding(double maxValue, current) {
    if (current < 70) return 0;
    if (current >= maxValue) return maxValue;
    return current;
  }

  void _movePage() {
    if (title == 'Sair') {
      LoginHelper.logOut(_context);
      return;
    }
    if (_orientation == Orientation.portrait) {
      if (DashBoardController.animationController.isCompleted) {
        DashBoardController.animationController.reverse();
      }
    }
    DashBoardController.currentPage = index;
    DashBoardController.pageController.jumpToPage(
      index,
    );
  }
}
