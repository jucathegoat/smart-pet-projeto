class UsuarioModel {
   String? cpf;
   String? email;
   String? nome;
   String? endereco;
   String? usuario;
   String? senha;

   UsuarioModel();

  UsuarioModel.create(this.cpf, this.email, this.nome, this.endereco, this.usuario);

  factory UsuarioModel.fromMap(Map<String, dynamic> map){
    return UsuarioModel.create(
    map['cpf']?? '',
    map['email'] ?? '',
    map['nome'] ?? '',
    map['endereco'] ?? '',
    map['usuario'] ?? '');
    
  }

  factory UsuarioModel.fromRequest(Map map){
    return UsuarioModel()
    ..cpf = map['cpf']
    ..email = map['email']
    ..endereco = map['endereco']
    ..nome = map['nome']
    ..usuario = map['usuario']
    ..senha = map['senha'];
  }

    Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'email': email,
      'nome': nome,
      'endereco': endereco,
      'usuario': usuario,
      'senha': senha,
    };
  }

    Map toJson(){
    return{
      'cpf': cpf,
      'email': email,
      'nome': nome,
      'endereco': endereco,
      'usuario': usuario,
      'senha': senha,
    };
    }

  @override
  String toString() {
    return 'UsuarioModel(cpf: $cpf, email:$email, nome: $nome, endereço: $endereco, usuario: $usuario)';
  }
}
