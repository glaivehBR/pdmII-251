import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Abrir ou criar banco de dados local (arquivo)
  final db = sqlite3.open('alunos.db');

  // Criar tabela TB_ALUNO se não existir
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome VARCHAR(50) NOT NULL
    );
  ''');

  // Inserir dados iniciais caso a tabela esteja vazia
  inserirDadosIniciais(db);

  print('==== Sistema de Cadastro de Alunos ====');

  bool running = true;
  while (running) {
    print('\nEscolha uma opção:');
    print('1 - Inserir novo aluno');
    print('2 - Listar alunos');
    print('0 - Sair');
    stdout.write('Opção: ');
    String? option = stdin.readLineSync();

    switch (option) {
      case '1':
        inserirAluno(db);
        break;
      case '2':
        listarAlunos(db);
        break;
      case '0':
        running = false;
        break;
      default:
        print('Opção inválida. Tente novamente.');
    }
  }

  db.dispose();
  print('Programa finalizado.');
}

void inserirDadosIniciais(Database db) {
  final countResult = db.select('SELECT COUNT(*) AS count FROM TB_ALUNO;');
  final count = countResult.first['count'] as int;
  if (count == 0) {
    // Tabela vazia, inserir dados iniciais
    final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?);');
    List<String> nomesIniciais = [
      'Maria Silva',
      'João Pereira',
      'Ana Oliveira',
      'Carlos Souza',
      'Beatriz Santos'
    ];
    for (var nome in nomesIniciais) {
      stmt.execute([nome]);
    }
    stmt.dispose();
    print('Dados iniciais inseridos na tabela TB_ALUNO.');
  }
}

void inserirAluno(Database db) {
  stdout.write('Digite o nome do aluno (até 50 caracteres): ');
  String? nome = stdin.readLineSync();

  if (nome == null || nome.trim().isEmpty) {
    print('Nome inválido. Operação cancelada.');
    return;
  }
  nome = nome.trim();
  if (nome.length > 50) {
    print('Nome muito longo. Deve ter no máximo 50 caracteres.');
    return;
  }

  final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?);');
  stmt.execute([nome]);
  stmt.dispose();

  print('Aluno "$nome" inserido com sucesso.');
}

void listarAlunos(Database db) {
  final ResultSet resultSet = db.select('SELECT id, nome FROM TB_ALUNO ORDER BY id;');
  if (resultSet.isEmpty) {
    print('Nenhum aluno cadastrado.');
  } else {
    print('\nLista de alunos cadastrados:');
    for (final row in resultSet) {
      print('ID: ${row['id']}, Nome: ${row['nome']}');
    }
  }
}