import 'item_pedido.dart';
import 'cliente.dart';
import 'vendedor.dart';
import 'veiculo.dart';

class PedidoVenda {
  String codigo;
  DateTime data;
  Cliente cliente;
  Vendedor vendedor;
  Veiculo veiculo;
  List<ItemPedido> items;
  double valorPedido;

  PedidoVenda({
    required this.codigo,
    required this.data,
    required this.cliente,
    required this.vendedor,
    required this.veiculo,
    required this.items,
    this.valorPedido = 0,
  });

  double calcularPedido() {
    double totalItens = items.fold(0, (sum, item) => sum + (item.valor * item.quantidade));
    valorPedido = veiculo.valor + totalItens;
    return valorPedido;
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'data': data.toIso8601String(),
      'cliente': {
        'codigo': cliente.codigo,
        'nome': cliente.nome,
        'tipoCliente': cliente.tipoCliente,
      },
      'vendedor': {
        'codigo': vendedor.codigo,
        'nome': vendedor.nome,
        'comissao': vendedor.comissao,
      },
      'veiculo': {
        'codigo': veiculo.codigo,
        'descricao': veiculo.descricao,
        'valor': veiculo.valor,
      },
      'items': items.map((item) => {
            'sequencial': item.sequencial,
            'descricao': item.descricao,
            'quantidade': item.quantidade,
            'valor': item.valor,
          }).toList(),
      'valorPedido': valorPedido,
    };
  }
}
