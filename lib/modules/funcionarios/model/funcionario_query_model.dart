import 'dart:convert';

import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_model.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/pagination_model.dart';

class FuncionarioQueryModel {
  final List<FuncionarioModel> collection;
  final Pagination pagination;
  FuncionarioQueryModel({
    required this.collection,
    required this.pagination,
  });

  Map<String, dynamic> toMap() {
    return {
      'collection': collection.map((x) => x.toMap()).toList(),
      'pagination': pagination.toMap(),
    };
  }

  factory FuncionarioQueryModel.fromMap(Map<String, dynamic> map) {
    return FuncionarioQueryModel(
      collection:
          List<FuncionarioModel>.from(map['collection']?.map((x) => FuncionarioModel.fromMap(x))),
      pagination: Pagination.fromMap(map['pagination']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FuncionarioQueryModel.fromJson(String source) =>
      FuncionarioQueryModel.fromMap(json.decode(source));
}
