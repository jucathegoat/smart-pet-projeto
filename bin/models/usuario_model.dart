class UsuarioModel {
   String? cpf;
   String? nome;
   String? telefone;
   String? endereco;
   String? email;
   String? usuario;
   String? senha;
   String? status_conta;

   UsuarioModel();

  UsuarioModel.create(this.cpf, this.email, this.nome, this.endereco, this.usuario, this.telefone,this.status_conta);

  factory UsuarioModel.fromMap(Map<String, dynamic> map){
    return UsuarioModel.create(
    map['cpf']?? '',
    map['email'] ?? '',
    map['nome'] ?? '',
    map['endereco'] ?? '',
    map['usuario'] ?? '',
    map['status_conta'] ?? '',
    map['telefone']??'',)
    ;

    
  }

  factory UsuarioModel.fromRequest(Map map){
    return UsuarioModel()
    ..cpf = map['cpf']
    ..email = map['email']
    ..endereco = map['endereco']
    ..nome = map['nome']
    ..usuario = map['usuario']
    ..senha = map['senha']
    ..telefone = map['telefone']
    ..status_conta = map['status_conta'];
  }

    Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'email': email,
      'nome': nome,
      'endereco': endereco,
      'usuario': usuario,
      'senha': senha,
      'telefone': telefone,
      'status_conta':status_conta
    };
  }

    Map toJson(){
    return{
      'cpf': cpf,
      'email': email,
      'nome': nome,
      'telefone':telefone,
      'endereco': endereco,
      'usuario': usuario,
      'senha': senha,
      'status_conta':status_conta
    };
    }

  @override
  String toString() {
    return 'UsuarioModel(cpf: $cpf, email:$email, nome: $nome, endereço: $endereco, usuario: $usuario)';
  }
}
