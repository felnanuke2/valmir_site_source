import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:menu_button/menu_button.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:vlalmir_workana_screens/modules/funcionarios/model/funcionario_model.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/controller/funcionario_controller.dart';
import 'package:vlalmir_workana_screens/screens/dashboard/tabs/funcionarios/screen/crudForm/controller/crud_funcionario_controller.dart';
import 'package:string_validator/string_validator.dart' as validator;

class CrudFuncionarioScreen extends StatefulWidget {
  FuncionarioModel? funcionarioModel;
  CrudFuncionarioScreen({this.funcionarioModel});

  @override
  _CrudFuncionarioScreenState createState() => _CrudFuncionarioScreenState();
}

class _CrudFuncionarioScreenState extends State<CrudFuncionarioScreen> {
  var descricaoController = TextEditingController();

  var passwordController = TextEditingController();

  var emailController = TextEditingController();

  int? id;

  String? situacao;

  var situacaoFocus = FocusNode();

  var _crudController = CrudFuncionarioController();

  late BuildContext _context;
  var _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##', filter: {'#': RegExp('[0-9]')});
  var situacaoController = TextEditingController();

  @override
  void initState() {
    if (widget.funcionarioModel != null) {
      var model = widget.funcionarioModel!;
      descricaoController.text = model.descricaoFuncionario;
      id = model.idFuncionario;
      _crudController.getPassword(id!).then((value) {
        passwordController.text = value ?? '';
      });
      emailController.text = model.email;
      situacao = model.idSituacao.toString();
      if (widget.funcionarioModel!.image != null) {
        _crudController.setImage(widget.funcionarioModel!.image!);
      }
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
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => FuncionarioController.navigatorKey.currentState!.pop(),
                  child: Text(
                    'Funcionários',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${id != null ? 'Editar Funcionário' : 'Novo Funcionário'} de Funcionário',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(25),
                child: Form(
                  child: Column(
                    children: [
                      StreamBuilder<Uint8List>(
                          stream: _crudController.imageStream,
                          initialData: _crudController.image,
                          builder: (context, snapshotImag) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () async => _crudController.pickImage(context),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: snapshotImag.data == null
                                          ? Icon(
                                              Icons.person_add,
                                              color: Colors.white,
                                            )
                                          : null,
                                      backgroundImage: snapshotImag.data == null
                                          ? null
                                          : MemoryImage(snapshotImag.data!)),
                                ),
                              ),
                            );
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLength: 100,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          validateFields();
                          if (value!.isEmpty) return 'Insira uma Descrição';
                        },
                        controller: descricaoController,
                        decoration: InputDecoration(labelText: 'Descrição *'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          validateFields();
                          if (value!.isEmpty) return 'Insira uma Senha';
                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(labelText: 'Senha *'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) return 'Insira um Email';
                          if (!validator.isEmail(value)) return 'Email inválido';

                          validateFields();
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email *'),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [_cpfMask],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.length < _cpfMask.getMask()!.length) return 'Muito curto';
                        },
                        decoration: InputDecoration(labelText: 'Cpf *'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MenuButton<String>(
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
                                decoration: InputDecoration(labelText: 'Escolha uma situação'),
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
                        items: ['Ativo', 'Inativo'],
                        itemBuilder: (value) => Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
                          child: Text(value),
                        ),
                        onItemSelected: (value) {
                          switch (value) {
                            case 'Ativo':
                              situacao = '1';
                              situacaoController.text = value;
                              break;
                            case 'Inativo':
                              situacao = '2';
                              situacaoController.text = value;
                              break;
                            default:
                          }
                          validateFields();
                        },
                      )
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: SelectFormField(
                      //     type: SelectFormFieldType.dropdown, // or can be dialog
                      //     initialValue: situacao,
                      //     labelText: 'Situação',
                      //     expands: true,
                      //     validator: (value) {
                      //       if (situacao == null) return 'Escolha uma Situação';
                      //       return null;
                      //     },
                      //     autovalidate: true,
                      //     items: [
                      //       {'value': '1', 'label': 'Ativo', 'icon': Icon(Icons.check_box)},
                      //       {
                      //         'value': '2',
                      //         'label': 'Inativo',
                      //         'icon': Icon(Icons.disabled_by_default)
                      //       }
                      //     ],
                      //     onChanged: (val) {
                      //       situacao = val;
                      //       validateFields();
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () => FuncionarioController.navigatorKey.currentState!.pop(),
                      child: Container(
                        height: 38,
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Voltar')
                          ],
                        ),
                      )),
                  StreamBuilder<bool>(
                      stream: _crudController.buttonValidateStream,
                      initialData: validateFields(),
                      builder: (context, snapshotField) {
                        bool validate = snapshotField.data!;
                        return StreamBuilder<bool>(
                            stream: _crudController.loadingStream,
                            initialData: false,
                            builder: (context, snapshotLoading) {
                              return snapshotLoading.data!
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(primary: Colors.green),
                                      onPressed: () => null,
                                      child: Container(
                                          width: 25,
                                          height: 25,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation(Colors.white),
                                            ),
                                          )))
                                  : ElevatedButton(
                                      onPressed: validate ? _createFuncionario : null,
                                      style: ElevatedButton.styleFrom(primary: Colors.green),
                                      child: Container(
                                        height: 38,
                                        child: StreamBuilder<bool>(
                                            stream: _crudController.loadingStream,
                                            initialData: false,
                                            builder: (context, snapshotLoading) {
                                              return Row(
                                                children: [
                                                  Text(id == null ? 'Salvar' : 'Atualizar'),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Icon(Icons.arrow_forward_ios),
                                                ],
                                              );
                                            }),
                                      ));
                            });
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validateFields() {
    var result = descricaoController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        situacao != null &&
        validator.isEmail(emailController.text) &&
        emailController.text.isNotEmpty;
    _crudController.buttonValidateSet = result;
    return result;
  }

  _createFuncionario() async {
    var result = await _crudController.createFuncionario(
        descricaoFuncionario: descricaoController.text,
        idSituacao: int.parse(situacao!),
        email: emailController.text,
        id: id,
        password: passwordController.text);
    if (result) {
      ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Funcionario ${descricaoController.text} ${id == null ? 'Criado' : 'Atualizado'} com sucesso',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          )));
      Navigator.of(_context).pop();
    } else {
      ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
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
              'Erro Ao Criar Funcionário.',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Mensagem: ${_crudController.errorMessage}'),
          )));
    }
  }
}
