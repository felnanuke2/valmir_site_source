import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/controller/funcionario_controller.dart';

class DashBoardController {
  DashBoardController._();
  static late AnimationController animationController;
  static PageController pageController = PageController();
  static final _pageStream = StreamController<int>.broadcast();
  static int currentPageIndex = 0;
  static List<int> validSeachIndex = [2];
  static List<int> validAddIndex = [2];

  static Stream<int> get pageStream => _pageStream.stream;
  static set currentPage(int index) {
    currentPageIndex = index;
    _pageStream.add(currentPageIndex);
  }

  static void delegateSearch(BuildContext context) {
    switch (currentPageIndex) {
      case 2:
        {
          FuncionarioController.funcionarioSearch(context);
          break;
        }

      default:
    }
  }

  static void delegateAddButton() {
    switch (currentPageIndex) {
      case 2:
        {
          FuncionarioController.openFormAddFuncionario();
          break;
        }

      default:
    }
  }
}
