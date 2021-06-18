import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_model.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/pagination_model.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/controller/funcionario_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/widgets/funcionario_item_tile_ladscape.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/widgets/funcionario_item_tile_portrait.dart';

class FuncionariosTab extends StatefulWidget {
  @override
  _FuncionariosTabState createState() => _FuncionariosTabState();
}

class _FuncionariosTabState extends State<FuncionariosTab> {
  final List<int> weightList = [
    1,
    3,
    1,
    3,
    2,
    1,
    1,
    1,
    2, //ignore this
  ];

  final List<String> nameParams = [
    'image',
    'ID',
    'Descrição',
    'Situação',
    'Email',
    'Empresa',
    'Data Cadastro',
    'Actions'
  ];

  @override
  void initState() {
    FuncionarioController.getFuncionarios();
    super.initState();
  }

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return OrientationBuilder(builder: (context, orientation) {
      bool isPortrait = MediaQuery.of(context).size.width <= 1200;
      return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Funcionários',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Visibility(
                    visible: isPortrait,
                    child: StreamBuilder<bool>(
                        stream: FuncionarioController.loadingStream,
                        initialData: true,
                        builder: (context, snapshotLoading) {
                          if (snapshotLoading.data == true)
                            return Container(
                                width: 20, height: 20, child: CircularProgressIndicator());
                          return Container();
                        }),
                  ),
                ],
              ),
            ),
            if (!isPortrait)
              Card(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Visibility(
                        visible: !isPortrait,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: List.generate(nameParams.length, (index) {
                              if (index == 0)
                                return Container(
                                  width: 60,
                                );

                              if (nameParams[index] == nameParams.last)
                                return Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        alignment: Alignment.center,
                                        child: StreamBuilder<bool>(
                                            stream: FuncionarioController.loadingStream,
                                            initialData: true,
                                            builder: (context, snapshotLoading) {
                                              return Visibility(
                                                visible: snapshotLoading.data!,
                                                child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                                                ),
                                              );
                                            }),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                  flex: weightList[index - 1],
                                );
                              return Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: InkWell(
                                      onTap: () => _processClick(index),
                                      child: Text(
                                        nameParams[index],
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: weightList[index - 1],
                              );
                            }),
                          ),
                        ),
                      ),
                      Divider(
                        height: 12,
                      ),
                      StreamBuilder<List<FuncionarioModel>>(
                          stream: FuncionarioController.funcionarioStream,
                          initialData: FuncionarioController.funcionarios,
                          builder: (context, snapshotFuncionarios) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var funcionarioItem = FuncionarioController.funcionarios[index];
                                if (isPortrait)
                                  return FuncionarioItemTilePortrait(
                                      funcionarioItem: funcionarioItem, weightList: weightList);
                                return FuncionarioItemTileLandScape(
                                    funcionarioItem: funcionarioItem, weightList: weightList);
                              },
                              itemCount: FuncionarioController.funcionarios.length,
                            );
                          }),
                      if (!isPortrait) _buildPagination(),
                    ],
                  ),
                ),
              ),
            if (isPortrait)
              Expanded(
                child: StreamBuilder<List<FuncionarioModel>>(
                    stream: FuncionarioController.funcionarioStream,
                    initialData: FuncionarioController.funcionarios,
                    builder: (context, snapshotFuncionarios) {
                      return SingleChildScrollView(
                        child: Wrap(
                          children:
                              List.generate(FuncionarioController.funcionarios.length, (index) {
                            var funcionarioItem = FuncionarioController.funcionarios[index];
                            return Container(
                              width: 300,
                              child: FuncionarioItemTilePortrait(
                                  funcionarioItem: funcionarioItem, weightList: weightList),
                            );
                          }),
                        ),
                      );
                    }),
              ),
            if (isPortrait) Card(child: _buildPagination())
          ],
        ),
      );
    });
  }

  Container _buildPagination({bool isPortrait = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: StreamBuilder<Pagination>(
          stream: FuncionarioController.paginationStream,
          initialData: FuncionarioController.pagination,
          builder: (context, snapshotPagination) {
            var pagination = snapshotPagination.data!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Builder(builder: (context) {
                    var initialIndex = (FuncionarioController.pagination.page *
                            FuncionarioController.pagination.pageSize) -
                        4;
                    var lastIndex = FuncionarioController.pagination.page *
                        FuncionarioController.pagination.pageSize;
                    if (lastIndex > FuncionarioController.pagination.totalResults)
                      lastIndex = FuncionarioController.pagination.totalResults;
                    if (initialIndex < 0) initialIndex = 0;
                    return Text(
                      '$initialIndex - $lastIndex de ${pagination.totalResults}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  }),
                ),
                IconButton(
                    onPressed: FuncionarioController.currentPage > 1
                        ? () {
                            FuncionarioController.currentPage = 1;
                            FuncionarioController.getFuncionarios();
                          }
                        : null,
                    icon: Icon(Icons.first_page_rounded)),
                IconButton(
                    iconSize: 16,
                    onPressed: FuncionarioController.currentPage > 1
                        ? () {
                            FuncionarioController.currentPage -= 1;
                            FuncionarioController.getFuncionarios();
                          }
                        : null,
                    icon: Icon(Icons.arrow_back_ios)),
                IconButton(
                    iconSize: 16,
                    onPressed: FuncionarioController.currentPage <
                            FuncionarioController.pagination.totalPages
                        ? () {
                            FuncionarioController.getFuncionarios(increment: true);
                          }
                        : null,
                    icon: Icon(Icons.arrow_forward_ios_rounded)),
                IconButton(
                    onPressed: FuncionarioController.currentPage <
                            FuncionarioController.pagination.totalPages
                        ? () {
                            FuncionarioController.currentPage =
                                FuncionarioController.pagination.totalPages;
                            FuncionarioController.getFuncionarios();
                          }
                        : null,
                    icon: Icon(Icons.last_page))
              ],
            );
          }),
    );
  }

  _processClick(int index) {
    String order = '';
    switch (index - 1) {
      case 0:
        {
          order = 'idFuncionario';
          break;
        }
      case 1:
        {
          order = 'descricaoFuncionario';
          break;
        }
      case 2:
        {
          order = 'descricaoSituacao';
          break;
        }
      case 3:
        {
          order = 'email';
          break;
        }
      case 4:
        {
          order = 'descricaoFranqueado';
          break;
        }
      case 5:
        {
          order = 'dataCadastro';
          break;
        }
      default:
    }
    FuncionarioController.orderby = order;
    FuncionarioController.getFuncionarios(ordenate: true);
  }

  int getAxisCount(BuildContext context) {
    num tabSize = MediaQuery.of(context).size.width - 60;
    if (tabSize >= 860) return 3;
    if (tabSize >= 580) return 2;
    return 1;
  }

  double getAspectRatio(BuildContext context) {
    num tabSize = MediaQuery.of(context).size.width - 50;
    if (tabSize <= 320) return 3 / 6;
    return 2 / 3;
  }
}
