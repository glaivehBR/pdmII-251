class Vendedor {
  int codigo;
  String nome;
  double comissao;

  Vendedor({required this.codigo, required this.nome, required this.comissao});

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nome': nome,
      'comissao': comissao,
    };
  }
}
