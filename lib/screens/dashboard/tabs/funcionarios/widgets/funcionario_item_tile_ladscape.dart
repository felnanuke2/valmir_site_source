import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_model.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/controller/funcionario_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/screen/crudForm/crud_funcionario_screen.dart';

class FuncionarioItemTileLandScape extends StatelessWidget {
  FuncionarioItemTileLandScape({
    Key? key,
    required this.funcionarioItem,
    required this.weightList,
  }) : super(key: key);

  final FuncionarioModel funcionarioItem;
  final List<int> weightList;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      child: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                    width: 60,
                    height: 60,
                    child: funcionarioItem.image != null
                        ? Image.memory(
                            _decodeImage(funcionarioItem.image!),
                          )
                        : SizedBox()),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      funcionarioItem.idFuncionario.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  flex: weightList[0],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      funcionarioItem.descricaoFuncionario,
                      maxLines: 2,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  flex: weightList[1],
                ),
                Expanded(
                  child: Container(
                    child: SelectableText(
                      funcionarioItem.descricaoSituacao,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  flex: weightList[2],
                ),
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => launch('mailto:${funcionarioItem.email}'),
                        child: Icon(
                          Icons.mail,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          funcionarioItem.email,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  flex: weightList[3],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      funcionarioItem.descricaoFranqueado,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  flex: weightList[4],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      funcionarioItem.dataCadastro,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  flex: weightList[5],
                ),
                Expanded(
                  flex: weightList[6],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: 'Editar Funcionário',
                          child: ElevatedButton(
                            onPressed: () => FuncionarioController.openFormAddFuncionario(
                                funcionarioModel: funcionarioItem),
                            child: Icon(Icons.edit, size: 15),
                            style: ElevatedButton.styleFrom(shape: CircleBorder()),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Tooltip(
                          message: 'Deletar funcionário',
                          child: ElevatedButton(
                            onPressed: () => _deletFuncionario(funcionarioItem),
                            child: Icon(
                              Icons.delete,
                              size: 15,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: CircleBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  editFuncionario(FuncionarioModel funcionarioModel) {
    Navigator.of(_context).push(MaterialPageRoute(
        builder: (context) => CrudFuncionarioScreen(
              funcionarioModel: funcionarioModel,
            )));
  }

  _deletFuncionario(FuncionarioModel funcionarioModel) async {
    var result = await FuncionarioController.requestConfirmation(_context, funcionarioModel);
    if (result == true) {}
  }

  void copyToClipBoard() {
    Clipboard.setData(ClipboardData(text: funcionarioItem.email));
  }
}

Uint8List _decodeImage(String base64Image) {
  return base64Decode(base64Image);
}
