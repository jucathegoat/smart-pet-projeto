class PetModel {
  int? codigoPet;
   String? especie;
   String? nome;
   int? idade;

   PetModel();

  PetModel.create(this.codigoPet, this.especie, this.nome, this.idade);

  factory PetModel.fromMap(Map<String, dynamic> map){
    return PetModel.create(
    map['codigoPet'] ?.toInt()??0,
    map['especie'] ?? '',
    map['nome'] ?? '',
    map['idade']?.toInt()?? 0);
    
  }

  factory PetModel.fromRequest(Map map){
    return PetModel()
    ..codigoPet = map['especie']
    ..especie = map['especie']
    ..nome = map['nome']
    ..idade = map['idade'];
  }

    Map<String, dynamic> toMap() {
    return {
      'codigoPet':codigoPet,
      'especie': especie,
      'nome': nome,
      'idade': idade,
    };
  }

  @override
  String toString() {
    return 'PetModel(codigoPet:$codigoPet, especie: $especie, nome: $nome, idade: $idade)';
  }
}
