class Veiculo {
  int codigo;
  String descricao;
  double valor;

  Veiculo({required this.codigo, required this.descricao, required this.valor});

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descricao': descricao,
      'valor': valor,
    };
  }
}
