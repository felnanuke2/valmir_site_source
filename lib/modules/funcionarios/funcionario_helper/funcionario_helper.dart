import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:vlalmir_workana_screens/constants/constant_values.dart';
import 'package:vlalmir_workana_screens/modules/auth/hive/hive_auth_helper.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/error/funcionario_error.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_model.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_query_model.dart';
import 'package:http/http.dart' as http;

class FuncionarioHelper {
  FuncionarioHelper._();

  /// faz um get na table de funcionarios
  /// é usado tambem ao pesquisar e ao reordenar
  static Future<FuncionarioQueryModel?> getFuncionarios({
    int pageSize = 5,
    required int page,
    String ordernar = 'descricaoFuncionario',
    String direcao = 'asc',
    int? id,
    String? descricao,
    String? situacao,
  }) async {
    var idFranqueado = int.parse(HiveAuthHelper.idFranqueado!);
    //url da requisição é setada aqui com os parametros definidos na chamada da função
    String url =
        '$BASE_API_URL/back/api/funcionario/pesquisar?page=$page&pageSize=$pageSize${_searchParams(id, descricao, situacao)}'
        '&idFranqueado=$idFranqueado&ordenar=$ordernar&direcao=$direcao';
//inicia o [get] na api
    var request = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${HiveAuthHelper.acessToken}',
    });
    // se o status code for 200 restora no query  que contem o pagination e o collection de funcionarios
    if (request.statusCode == 200) {
      var map = jsonDecode(request.body);
      return FuncionarioQueryModel.fromMap(map);
    }
    //caso contrario retorna null e o controller da view faz o filtro
    else {
      return null;
    }
  }

  /// cria um funcionario na table funcionarios
  static Future<Either<FuncionarioErro, FuncionarioQueryModel>> createFuncionario(
      FuncionarioModel funcionario, String password, String? image) async {
    String url = '$BASE_API_URL/back/api/funcionario/detalhe';
//por padrão o datetime que vem do flutter não é comparivel com  o do flutter
//então foi necessario um regex para fazer a adaptação para o seu banco de dados
    var regex = RegExp('([0-9]{4})[-]([0-9]{2})[-]([0-9]{2})');
    var match = regex.allMatches(funcionario.dataCadastro).elementAt(0);
    //essa já o datetime correto para ser usado no seu banco de dados
    String formatedData = '${match.group(1)}-${match.group(2)}-${match.group(3)}';
    var idFranqueado = int.parse(HiveAuthHelper.idFranqueado!);
    var data = {
      "idFuncionario": idFranqueado,
      "idFranqueado": 1,
      "idSituacao": funcionario.idSituacao,
      "dataCadastro": formatedData,
      "descricaoFuncionario": funcionario.descricaoFuncionario,
      "senha": password,
      "email": funcionario.email,
      "imagem": image,
      "idfranqueado": 1
    };
//inicia o post na api
//content-type é necessario caso contrario a api entende que é um text/plain e retorna um midiatype unsuported
// é necessario usar o jsonEncode() para converter um map em string para o http
    var result = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Authorization': 'Bearer ${HiveAuthHelper.acessToken}',
      'content-type': APPLIICATION_JSON
    });
    if (result.statusCode == 200) {
      // a resposta vem como uma string tambem então é necessario converter para map usando o jsonDecode()
      var map = jsonDecode(result.body);
      var funcionarioId = map;
      //faz um get no usuario alterado e se tudo der certo retorna un Right()
      var request = await getFuncionarios(page: 1, id: funcionarioId);
      if (request != null) {
        //right significa que foi retornado o que queriamos essa class vem da biblioteca do flutter chamada de dartz
        //é muito usada para tratamento de erros
        return Right(request);
      }
    }
    // se alguma das exigências não forem atendidas a função ira retornar um Left()
    //nesse caso left contem uma classe de erro e essa classe de erro contem uma mensagem.
    //essa mensagem é a que sera mostrada ao usuario
    var map = jsonDecode(result.body);
    return left(CreateFuncionarioError(message: map['notificacoes'].toString()));
  }

  ///obtem a senha de um usuario
  static Future<String?> getfuncionarioPassword(int idFuncionario) async {
    var idFranqueado = int.parse(HiveAuthHelper.idFranqueado!);
    String url =
        '$BASE_API_URL//back/api/funcionario/obter?id=$idFuncionario&idFranqueado=$idFranqueado';

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${HiveAuthHelper.acessToken}',
    });

    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      return map['senha'];
    }
    return null;
  }

  /// deleta o funcionario na tabela funcionarios
  static Future<bool> deletFuncionario(int funcionarioId) async {
    var idFranqueado = int.parse(HiveAuthHelper.idFranqueado!);
    var url =
        '$BASE_API_URL/back/api/funcionario/excluir?id=$funcionarioId&idFranqueado=$idFranqueado';

    var request = await http.delete(
        Uri.parse(
          url,
        ),
        headers: {
          'Authorization': 'Bearer ${HiveAuthHelper.acessToken}',
        });
    if (request.statusCode == 200) {
      var map = jsonDecode(request.body);
      if (map == funcionarioId) return true;
    }
    return false;
  }

  static String _searchParams(int? id, String? descricao, String? situacao) {
    var idSearch = id != null ? '&idFuncionario=$id' : '';
    var descricaoSearch = descricao != null ? '&descricaoFuncionario=$descricao' : '';
    var situacaoSearch = situacao != null ? '&idSituacao=$situacao' : '';
    return idSearch + descricaoSearch + situacaoSearch;
  }
}
