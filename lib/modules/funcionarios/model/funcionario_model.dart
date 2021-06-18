import 'dart:convert';
import 'dart:typed_data';

class FuncionarioModel {
  final int idFuncionario;
  final String descricaoFuncionario;
  final int idSituacao;
  final String descricaoSituacao;
  final String email;
  final int idFranqueado;
  final String descricaoFranqueado;
  final String dataCadastro;
  String? image;

  FuncionarioModel({
    required this.idFuncionario,
    required this.descricaoFuncionario,
    required this.idSituacao,
    required this.descricaoSituacao,
    required this.email,
    required this.idFranqueado,
    required this.descricaoFranqueado,
    required this.dataCadastro,
    this.image,
  });

  factory FuncionarioModel.fromMap(Map<String, dynamic> map) {
    String dataCadastro = map['dataCadastro'];
    var regex = RegExp('([0-9]{4})[-]([0-9]{2})[-]([0-9]{2})');
    var match = regex.allMatches(dataCadastro).elementAt(0);
    String formatedData = '${match.group(3)}/${match.group(2)}/${match.group(1)}';

    return FuncionarioModel(
        idFuncionario: map['idFuncionario'],
        descricaoFuncionario: map['descricaoFuncionario'],
        idSituacao: map['idSituacao'],
        descricaoSituacao: map['descricaoSituacao'],
        email: map['email'],
        idFranqueado: map['idFranqueado'],
        descricaoFranqueado: map['descricaoFranqueado'],
        dataCadastro: formatedData,
        image: map['imagem']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idFuncionario'] = this.idFuncionario;
    data['descricaoFuncionario'] = this.descricaoFuncionario;
    data['idSituacao'] = this.idSituacao;
    data['descricaoSituacao'] = this.descricaoSituacao;
    data['email'] = this.email;
    data['idFranqueado'] = this.idFranqueado;
    data['descricaoFranqueado'] = this.descricaoFranqueado;
    data['dataCadastro'] = this.dataCadastro;
    return data;
  }
}
