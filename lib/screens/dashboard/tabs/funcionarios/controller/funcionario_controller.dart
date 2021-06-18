import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_button/menu_button.dart';
import 'package:select_form_field/select_form_field.dart';

import 'package:vlalmir_workana_screens/modules/funcionarios/funcionario_helper/funcionario_helper.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_model.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/pagination_model.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/controller/dashboard_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/screen/crudForm/crud_funcionario_screen.dart';

class FuncionarioController {
  static List<FuncionarioModel> funcionarios = [];
  static List<FuncionarioModel> funcionariosSearchResult = [];
  static final funcionarioController = StreamController<List<FuncionarioModel>>.broadcast();
  static final _paginationController = StreamController<Pagination>.broadcast();
  static final _loadingController = StreamController<bool>.broadcast();
  static bool direcao = true;
  static int _pageSize = 5;
  static int currentPage = 1;
  static String? situacao;
  static String? descricao;
  static int? id;
  static bool _inSearch = false;
  static bool _inCrud = false;
  static String orderby = 'descricaoFuncionario';

  static final navigatorKey = GlobalKey<NavigatorState>();
  static get funcionarioStream => funcionarioController.stream;
  static get paginationStream => _paginationController.stream;
  static get loadingStream => _loadingController.stream;

  static Pagination pagination =
      Pagination(pageSize: 0, totalResults: 0, totalPages: 0, page: 1, previous: '', next: '');

  static set addFuncionario(FuncionarioModel funcionarioModel) {
    funcionarios.add(funcionarioModel);
    funcionarioController.add(funcionarios);
  }

  static set deletfuncionario(int funcionarioId) {
    funcionarios.removeWhere((element) => element.idFuncionario == funcionarioId);
    funcionarioController.add(funcionarios);
  }

  static void getFuncionarios({
    bool increment = false,
    bool ordenate = false,
  }) async {
    if (ordenate) {
      direcao = !direcao;
    }
    //controla o induador de loading
    _loadingController.add(true);
    int totalResult = 0;
    if (increment) {
      currentPage = pagination.page + 1;
    }

    var result = await FuncionarioHelper.getFuncionarios(
        page: currentPage,
        ordernar: orderby,
        direcao: direcao ? 'asc' : 'desc',
        pageSize: _pageSize,
        id: id,
        descricao: descricao,
        situacao: situacao);
    _loadingController.add(false);
    if (result != null) {
      pagination = result.pagination;
      funcionarios = result.collection;

      funcionarioController.add(result.collection);
      _paginationController.add(result.pagination);
    }
  }

  static void closeStreams() {
    funcionarioController.close();
    _paginationController.close();
    _loadingController.close();
  }

  static openFormAddFuncionario({FuncionarioModel? funcionarioModel}) {
    DashBoardController.pageStream.listen((event) {
      if (_inCrud) {
        navigatorKey.currentState!.pop();
        _inCrud = false;
      }
    });
    DashBoardController.currentPage = -2;
    navigatorKey.currentState!
        .push(MaterialPageRoute(
            builder: (context) => CrudFuncionarioScreen(
                  funcionarioModel: funcionarioModel,
                )))
        .then((value) {
      _inCrud = false;
      if (DashBoardController.currentPageIndex == -2) {
        DashBoardController.currentPage = 2;
      }
    });
    Future.delayed(Duration(seconds: 1)).then((value) {
      _inCrud = true;
    });
  }

  static void funcionarioSearch(BuildContext context) {
    var situacaoController = TextEditingController();
    switch (situacao) {
      case '1':
        situacaoController.text = 'Ativo';
        break;
      case '2':
        situacaoController.text = 'Inativo';
        break;
      default:
        {
          situacaoController.text = 'Todos';
        }
    }
    var idController = TextEditingController(text: id != null ? id.toString() : '');
    var descricaoController = TextEditingController(text: descricao ?? '');

    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: OrientationBuilder(builder: (context, orientation) {
          double width = 0;
          if (orientation == Orientation.landscape) {
            width = 600;
          } else {
            width = 320;
          }

          return AlertDialog(
            insetPadding: EdgeInsets.all(24),
            title: Text(
              'Busca Avançada',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: width,
              child: Column(
                children: [
                  Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        if (event.scrollDelta.direction < 0) {
                          int counter = id == null ? 0 : id!;
                          counter++;
                          id = counter;
                          idController.text = '$id';
                        } else {
                          int counter = id == null ? 0 : id!;
                          counter--;
                          if (counter < 0) counter = 0;
                          id = counter;
                          idController.text = '$id';
                        }
                      }
                    },
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: idController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      decoration: InputDecoration(
                          labelText: 'Id',
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  onTap: () {
                                    int counter = id == null ? 0 : id!;
                                    counter++;
                                    id = counter;
                                    idController.text = '$id';
                                  },
                                  child: Icon(Icons.arrow_drop_up_outlined)),
                              InkWell(
                                  onTap: () {
                                    int counter = id == null ? 0 : id!;
                                    counter--;
                                    if (counter < 0) counter = 0;
                                    id = counter;
                                    idController.text = '$id';
                                  },
                                  child: Icon(Icons.arrow_drop_down_outlined)),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: descricaoController,
                    decoration: InputDecoration(labelText: 'Descrição'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  MenuButton<String?>(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              child: Expanded(
                                  child: TextField(
                            enabled: false,
                            readOnly: true,
                            controller: situacaoController,
                            decoration: InputDecoration(labelText: 'Situação'),
                          ))),
                          const SizedBox(
                            width: 12,
                            height: 17,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    items: ['Todos', 'Ativo', 'Inativo'],
                    itemBuilder: (value) => Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
                      child: Text(value ?? 'Todos'),
                    ),
                    onItemSelected: (value) {
                      switch (value) {
                        case 'Ativo':
                          situacao = '1';
                          situacaoController.text = value!;
                          break;
                        case 'Inativo':
                          situacao = '2';
                          situacaoController.text = value!;
                          break;
                        case 'Todos':
                          situacao = null;
                          situacaoController.text = 'Todos';
                          break;

                        default:
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Beamer.of(context).popRoute(), child: Text('Cancelar')),
              SizedBox(
                width: 20,
              ),
              TextButton(
                  onPressed: () {
                    if (descricaoController.text.isEmpty) {
                      descricao = null;
                    } else {
                      descricao = descricaoController.text;
                    }
                    if (idController.text.isEmpty) {
                      id = null;
                    } else {
                      id = int.parse(idController.text);
                    }
                    _inSearch = true;

                    currentPage = 1;
                    getFuncionarios();

                    Beamer.of(context).popRoute();
                  },
                  child: Text('Pesquisar')),
            ],
          );
        }),
      ),
    );
  }

  static Future<String?> selectSituacao(BuildContext context, bool? inCrud,
      TextEditingController controller, String? situacao) async {
    return await showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          content: Column(
            children: [
              if (inCrud == false)
                RadioListTile<String?>(
                  value: null,
                  title: Text('Todos'),
                  groupValue: situacao,
                  onChanged: (value) {
                    situacao = value;
                    controller.text = 'Todos';
                    Navigator.of(context).pop(value);
                  },
                ),
              RadioListTile<String?>(
                value: '1',
                title: Text('Ativo'),
                groupValue: situacao,
                onChanged: (value) {
                  situacao = value;
                  controller.text = 'Ativo';
                  Navigator.of(context).pop(value);
                },
              ),
              RadioListTile<String?>(
                value: '2',
                title: Text('Inativo'),
                groupValue: situacao,
                onChanged: (value) {
                  situacao = value;
                  controller.text = 'Inativo';
                  Navigator.of(context).pop(value);
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(situacao), child: Text('Fechar'))
          ],
        ),
      ),
    );
  }

  static Future<bool> requestConfirmation(
      BuildContext context, FuncionarioModel funcionarioModel) async {
    var loadingController = StreamController<bool>.broadcast();
    return await showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: OrientationBuilder(builder: (context, orientation) {
          double width = 0.0;
          if (orientation == Orientation.landscape) {
            width = 700;
          } else {
            width = 320;
          }

          return AlertDialog(
            title: Center(
              child: Text(
                'Excluir?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            content: Container(
              width: width,
              child: Column(
                children: [
                  Text(
                    'Você deseja excuir esse registro?',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      StreamBuilder<bool>(
                          stream: loadingController.stream,
                          initialData: false,
                          builder: (context, snapshotLoading) {
                            bool isLoading = snapshotLoading.data!;
                            return Container(
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (isLoading) return;
                                    loadingController.add(true);
                                    await _deletFuncionario(funcionarioModel, context);
                                    loadingController.add(false);
                                    Navigator.of(context).pop(true);
                                  },
                                  child: isLoading
                                      ? Center(
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation(Colors.white),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Sim, delete-o!',
                                          style: TextStyle(fontSize: 18),
                                        )),
                            );
                          }),
                      Container(
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Não, mantenha-o!', style: TextStyle(fontSize: 18))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  static _deletFuncionario(FuncionarioModel funcionarioModel, BuildContext context) async {
    var response = await FuncionarioHelper.deletFuncionario(funcionarioModel.idFuncionario);
    if (response == true) {
      deletfuncionario = funcionarioModel.idFuncionario;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Funcionario ${funcionarioModel.descricaoFuncionario} removido com sucesso',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          )));
    }
  }

  static sortID() {
    funcionarios.sort((a, b) {
      if (direcao) {
        return a.idFuncionario.compareTo(b.idFuncionario);
      } else {
        return b.idFuncionario.compareTo(a.idFuncionario);
      }
    });
  }

  static sortdescricaoFuncionario() {
    funcionarios.sort((a, b) {
      if (direcao) {
        return a.descricaoFuncionario.compareTo(b.descricaoFuncionario);
      } else {
        return b.descricaoFuncionario.compareTo(a.descricaoFuncionario);
      }
    });
  }

  static sortSituacao() {
    funcionarios.sort((a, b) {
      if (direcao) {
        return a.idSituacao.compareTo(b.idSituacao);
      } else {
        return b.idSituacao.compareTo(a.idSituacao);
      }
    });
  }

  static sortEmail() {
    funcionarios.sort((a, b) {
      if (direcao) {
        return a.email.compareTo(b.email);
      } else {
        return b.email.compareTo(a.email);
      }
    });
  }

  static sortdescFranqueado() {
    funcionarios.sort((a, b) {
      if (direcao) {
        return a.descricaoFranqueado.compareTo(b.descricaoFranqueado);
      } else {
        return b.descricaoFranqueado.compareTo(a.descricaoFranqueado);
      }
    });
  }

  static sortDataCadastro() {
    funcionarios.sort((a, b) {
      var splitedStringA = a.dataCadastro.split('/');
      var splitedStringB = b.dataCadastro.split('/');
      var aDay = int.parse(splitedStringA[0]);
      var aMonth = int.parse(splitedStringA[1]);
      var aYear = int.parse(splitedStringA[2]);
      var bDay = int.parse(splitedStringB[0]);
      var bMonth = int.parse(splitedStringB[1]);
      var bYear = int.parse(splitedStringB[2]);
      var dateA = DateTime(aYear, aMonth, aDay);
      var dateB = DateTime(bYear, bMonth, bDay);

      if (direcao) {
        return dateA.compareTo(dateB);
      } else {
        return dateB.compareTo(dateA);
      }
    });
  }
}
