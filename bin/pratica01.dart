import 'dart:convert';
import 'package:pratica01/models/cliente.dart';
import 'package:pratica01/models/vendedor.dart';
import 'package:pratica01/models/veiculo.dart';
import 'package:pratica01/models/item_pedido.dart';
import 'package:pratica01/models/pedido_venda.dart';



void main() {
  var cliente = Cliente(codigo: 1, nome: "Glaive", tipoCliente: 2);
  var vendedor = Vendedor(codigo: 1, nome: "Taveira", comissao: 0.08);
  var veiculo = Veiculo(codigo: 101, descricao: "Tesla Cybertruck", valor: 120000000);

  var itens = [
    ItemPedido(sequencial: 1, descricao: "Revisão", quantidade: 1, valor: 500),
    ItemPedido(sequencial: 2, descricao: "Placa", quantidade: 1, valor: 300),
    ItemPedido(sequencial: 3, descricao: "Conjunto extra de pneus", quantidade: 1, valor: 1000),
    ItemPedido(sequencial: 4, descricao: "Um balde",quantidade: 1, valor: 4000000000),
  ];

  var pedido = PedidoVenda(
    codigo: "PV001",
    data: DateTime.now(),
    cliente: cliente,
    vendedor: vendedor,
    veiculo: veiculo,
    items: itens,
  );

  var jsonPedido = jsonEncode(pedido.toJson());

  print(jsonPedido);
}
