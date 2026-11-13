class ServicoModel {
   int? codigoServico;
   String? nome;
   double? preco;
   String? categoria;

   ServicoModel();

  ServicoModel.create(this.codigoServico, this.nome, this.preco, this.categoria);

  factory ServicoModel.fromMap(Map<String, dynamic> map){
    return ServicoModel.create(
    map['codigo_servico'].toInt() ?? 0,
    map['nome'] ?? '',
    map['preco'] ?? 0,
    map['categoria'] ?? '');
    
  }

  factory ServicoModel.fromRequest(Map map){
    return ServicoModel()
    ..codigoServico = map['codigoServico']
    ..nome = map['nome']
    ..preco = map['preco']
    ..categoria = map['categoria'];
  }

    Map<String, dynamic> toMap() {
    return {
      'codigoServico': codigoServico,
      'nome': nome,
      'preco': preco,
      'categoria': categoria,
    };
  }

    Map toJson(){
    return{
      'codigoServico': codigoServico,
      'nome': nome,
      'preco': preco,
      'categoria': categoria,
    };
    }

  @override
  String toString() {
    return 'ServicoModel(codigoServico: $codigoServico, nome:$nome, preco: $preco, categoria: $categoria)';
  }
}
