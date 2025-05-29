import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path/path.dart' as p;

void main() async {
  // ✅ JSON de exemplo (troca pelos seus dados)
  Map<String, dynamic> pedidoJson = {
    "codigo": "PV001",
    "data": "2024-05-29",
    "cliente": {
      "codigo": "C001",
      "nome": "Glaive Helles",
      "tipoCliente": "Pessoa Física"
    },
    "vendedor": {
      "codigo": "V001",
      "nome": "Taveira",
      "comissao": 0.1
    },
    "veiculo": {
      "codigo": "VE001",
      "descricao": "Carro Elétrico",
      "valor": 45000.0
    },
    "items": [
      {
        "sequencial": 1,
        "descricao": "Revisão 500",
        "quantidade": 1,
        "valor": 5000.0
      }
    ],
    "valorPedido": 50000.0
  };

  String jsonString = jsonEncode(pedidoJson);

  // 🔑 Dados do seu e-mail
  String username = 'glaivearrebatador@gmail.com';
  String password = 'osoo sxfl chfy vfag'; // senha de app

  // 🔗 Configura SMTP
  final smtpServer = gmail(username, password);

  // 📝 Cria arquivo temporário com JSON
  final jsonFile = await _generateJsonFile(jsonString);

  // ✉️ Cria a mensagem
  final message = Message()
    ..from = Address(username, 'Glaive Helles')
    ..recipients.add('taveira@ifce.edu.br')
    ..subject = 'PROVA PRATICA-DART'
    ..text = 'Olá professor, segue o JSON da prova prática em anexo.'
    ..attachments = [
      FileAttachment(jsonFile)
        ..fileName = 'pedido.json'
    ];

  try {
    final sendReport = await send(message, smtpServer);
    print('✅ E-mail enviado com sucesso: $sendReport');
  } on MailerException catch (e) {
    print('❌ Erro ao enviar e-mail.');
    for (var p in e.problems) {
      print('Problema: ${p.code}: ${p.msg}');
    }
  }
}

// 🗂️ Função para gerar arquivo JSON temporário
Future<File> _generateJsonFile(String content) async {
  final directory = Directory.systemTemp;
  final file = File(p.join(directory.path, 'pedido.json'));
  return file.writeAsString(content);
}
