import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

void main() async {
  // Configurações SMTP
  String username = 'glaivearrebatador@gmail.com';
  String senhaApp = 'ntya drty azok mdqh';

  final smtpServer = gmail(username, senhaApp);

  // Mensagem
  final message = Message()
    ..from = Address(username, 'Glaive')
    ..recipients.add('mateus.almeida@aluno.ifce.edu.br')
    ..subject = 'Teste testando'
    ..text = 'Salve!.';

  try {
    final sendReport = await send(message, smtpServer);
    print('✅ E-mail enviado com sucesso: ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('❌ Erro ao enviar e-mail: $e');
    for (var p in e.problems) {
      print('Problema: ${p.code}: ${p.msg}');
    }
  }
}