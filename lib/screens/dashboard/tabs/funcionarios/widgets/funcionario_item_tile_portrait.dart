import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_model.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/controller/funcionario_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/screen/crudForm/crud_funcionario_screen.dart';

class FuncionarioItemTilePortrait extends StatelessWidget {
  FuncionarioItemTilePortrait({
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

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: SelectableText(
                funcionarioItem.descricaoFuncionario,
                maxLines: 2,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Visibility(
                  child: Container(
                      width: 60,
                      height: 60,
                      child: funcionarioItem.image != null
                          ? Image.memory(
                              _decodeImage(funcionarioItem.image!),
                            )
                          : SizedBox())),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                        'ID',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      )),
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        funcionarioItem.idFuncionario.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text('Email',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => launch('mailto:${funcionarioItem.email}'),
                        child: Text(
                          funcionarioItem.email,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text('Situação',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        funcionarioItem.descricaoSituacao,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text('Empresa',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        funcionarioItem.descricaoFranqueado,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text('Data Cadastro',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        funcionarioItem.dataCadastro,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Tooltip(
                      message: 'Editar Funcionário',
                      child: ElevatedButton(
                        onPressed: () => FuncionarioController.openFormAddFuncionario(
                            funcionarioModel: funcionarioItem),
                        child: Icon(Icons.edit, size: 15),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), fixedSize: Size(20, 20)),
                      ),
                    ),
                  ),
                  Center(
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
                            primary: Colors.red, shape: CircleBorder(), fixedSize: Size(20, 20)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Uint8List _decodeImage(String base64Image) {
    return base64Decode(base64Image);
  }
}
