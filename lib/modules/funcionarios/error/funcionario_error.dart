abstract class FuncionarioErro {
  String? message;
}

class CreateFuncionarioError implements FuncionarioErro {
  @override
  String? message;
  CreateFuncionarioError({
    this.message,
  });
}
