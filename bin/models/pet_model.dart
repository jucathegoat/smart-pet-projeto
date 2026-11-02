class PetModel {
  int? codigoPet;
  String? raca;
  String? porte;
  String? especie;
  String? nome;
  int? idade;
  double? peso;
  String? nDocumento;

  PetModel();

  PetModel.create(
    this.codigoPet,
    this.especie,
    this.nome,
    this.idade,
    this.peso,
    this.porte,
    this.raca,
    this.nDocumento,
  );

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel.create(
      map['codigoPet']?.toInt() ?? 0,
      map['especie'] ?? '',
      map['raca'] ?? '',
      map['porte'] ?? '',
      map['nome'] ?? '',
      map['peso']?.toDouble() ?? 0,
      map['n_documento'] ?? '',
      map['idade']?.toInt() ?? 0,
    );
  }

  factory PetModel.fromRequest(Map<String, dynamic> map) {
    return PetModel()
      ..codigoPet = map['codigoPet'] == null
          ? null
          : int.tryParse(map['codigoPet'].toString())
      ..especie = map['especie']?.toString() ?? ''
      ..nome = map['nome']?.toString() ?? ''
      ..raca = map['raca']?.toString() ?? ''
      ..porte = map['porte']?.toString() ?? ''
      ..nDocumento = map['n_documento']?.toString() ?? ''
      ..peso = map['peso'] == null || map['peso'].toString().isEmpty
          ? null
          : double.tryParse(map['peso'].toString())
      ..idade = map['idade'] == null || map['idade'].toString().isEmpty
          ? null
          : int.tryParse(map['idade'].toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'codigoPet': codigoPet,
      'especie': especie,
      'raca': raca,
      'porte': porte,
      'peso': peso,
      'nome': nome,
      'idade': idade,
      'n_documento':nDocumento
    };
  }

  @override
  String toString() {
    return 'PetModel(codigoPet:$codigoPet, especie: $especie, nome: $nome, idade: $idade)';
  }
}
