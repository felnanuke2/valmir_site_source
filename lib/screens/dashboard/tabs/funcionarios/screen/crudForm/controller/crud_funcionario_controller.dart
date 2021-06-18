import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/error/funcionario_error.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/funcionario_helper/funcionario_helper.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_model.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/controller/funcionario_controller.dart';

class CrudFuncionarioController {
  var _butonSaveValidateStream = StreamController<bool>.broadcast();
  Uint8List? image;
  String? imageString;

  final _imageController = StreamController<Uint8List>.broadcast();
  get imageStream => _imageController.stream;
  Stream<bool> get buttonValidateStream => _butonSaveValidateStream.stream;
  Stream<bool> get loadingStream => _loadingController.stream;
  set buttonValidateSet(bool validate) => _butonSaveValidateStream.add(validate);
  var _loadingController = StreamController<bool>.broadcast();
  String? errorMessage;

  int idFranqueado = 1;

  Future<bool> createFuncionario(
      {int? id,
      required String descricaoFuncionario,
      required int idSituacao,
      required String email,
      required String password}) async {
    _loadingController.add(true);
    var funcionario = FuncionarioModel(
        idFuncionario: id ?? 0,
        descricaoFuncionario: descricaoFuncionario,
        idSituacao: idSituacao,
        descricaoSituacao: '',
        email: email,
        idFranqueado: idFranqueado,
        descricaoFranqueado: '',
        dataCadastro: DateTime.now().toString());
    var result = await FuncionarioHelper.createFuncionario(
        funcionario, password, imageString != null ? imageString : null);
    _loadingController.add(false);
    return result.fold((l) {
      if (l is CreateFuncionarioError) {
        errorMessage = l.message;
      }
      return false;
    }, (r) {
      FuncionarioController.funcionarios.clear();
      FuncionarioController.currentPage = 1;
      FuncionarioController.addFuncionario = r.collection.first;
      return true;
    });
  }

  Future<String?> getPassword(int idFuncionario, {int idFranqueado = 1}) async {
    var result = await FuncionarioHelper.getfuncionarioPassword(idFuncionario, idFranqueado);
    return result;
  }

  void pickImage(BuildContext context) async {
    var imageResult = await ImagePicker().getImage(source: ImageSource.gallery);
    if (imageResult != null) {
      var byte = await imageResult.readAsBytes();
      if (byte.lengthInBytes > 300000) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 10),
            backgroundColor: Colors.white,
            content: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'A imagem que você escolheu tem um tamanho superior a 300 kb..',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Escolha uma imagem com tamanho  de 300kb ou menos'),
            )));
      } else {
        image = byte;
        _imageController.add(byte);
        imageString = _encodeImageByte(image!);
      }
    }
  }

  String _encodeImageByte(Uint8List image) {
    return base64Encode(image);
  }

  setImage(String base64Image) {
    image = base64Decode(base64Image);
    imageString = base64Image;
    _imageController.add(image!);
  }
}
