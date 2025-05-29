class ItemPedido {
  int sequencial;
  String descricao;
  int quantidade;
  double valor;

  ItemPedido({
    required this.sequencial,
    required this.descricao,
    required this.quantidade,
    required this.valor,
  });

  double get total => quantidade * valor;

  Map<String, dynamic> toJson() {
    return {
      'sequencial': sequencial,
      'descricao': descricao,
      'quantidade': quantidade,
      'valor': valor,
      'total': total,
    };
  }
}
