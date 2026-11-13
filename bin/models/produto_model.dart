class ProdutoModel {
   int? idproduto;
   String? nome;
   String? marca;
   String? tipo;
   int? estoque;
   double? preco;
   String? codigo;
   String? url;

   ProdutoModel();

  ProdutoModel.create(this.idproduto, this.nome, this.marca, this.tipo, this.estoque, this.preco, this.codigo, this.url);

  factory ProdutoModel.fromMap(Map<String, dynamic> map){
    return ProdutoModel.create(
    map['id_produto'].toInt() ?? 0,
    map['nome'] ?? '',
    map['marca'] ?? '',
    map['tipo'] ?? '',
    map['estoque'].toInt() ?? 0,
    map['preco'] ?? 0,
    map['codigo'] ?? '',
    map['url'] ?? '');
    
  }

  factory ProdutoModel.fromRequest(Map map){
    return ProdutoModel()
    ..idproduto = map['id_produto']
    ..nome = map['nome']
    ..marca = map['marca']
    ..tipo = map['tipo']
    ..estoque = map['estoque']
    ..preco = map['preco']
    ..codigo = map['codigo']
    ..url = map['url'];
  }

    Map<String, dynamic> toMap() {
    return {
      'id_produto': idproduto,
      'nome': nome,
      'marca': marca,
      'tipo': tipo,
      'estoque': estoque,
      'preco': preco,
      'codigo': codigo,
      'url': url,
    };
  }

    Map toJson(){
    return{
      'id_produto': idproduto,
      'nome': nome,
      'marca': marca,
      'tipo': tipo,
      'estoque': estoque,
      'preco': preco,
      'codigo': codigo,
      'url': url,
    };
    }

  @override
  String toString() {
    return 'ProdutoModel(idproduto: $idproduto, nome: $nome, marca: $marca, tipo: $tipo, estoque: $estoque, preco: $preco, codigo: $codigo, url: $url)';
  }
}
