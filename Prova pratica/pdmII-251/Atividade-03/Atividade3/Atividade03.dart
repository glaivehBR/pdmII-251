import 'dart:io';
import 'dart:async';
import 'dart:isolate';

void main() async {
  print("Glaive Helles");

  
  final receivePort = ReceivePort();
  await Isolate.spawn(doAsyncOperation, receivePort.sendPort);

 
  print('Fazendo outra tarefa...');
  await Future.delayed(Duration(seconds: 1));
  print('Continuando outra tarefa...');

  
  final result = await receivePort.first;
  print('Resultado: $result');
}

void doAsyncOperation(SendPort sendPort) async {
  
  final result = await File('arquivo.txt').readAsString();
  sendPort.send(result);
}
