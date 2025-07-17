import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

/// Modelo para a piada
class Joke {
  final String id;
  final String joke;

  Joke({required this.id, required this.joke});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'] ?? '',
      joke: json['joke'] ?? '',
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piadas do Papai',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const JokePage(),
    );
  }
}

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  final List<Joke> _jokes = [];
  bool _loading = false;

  Future<void> _getJoke() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final uri = Uri.https('icanhazdadjoke.com', '/');
      final resp = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'flutter-class-demo',
        },
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final joke = Joke.fromJson(data);
        setState(() => _jokes.add(joke));
      } else {
        _showError('Erro ${resp.statusCode} ao buscar piada');
      }
    } catch (e) {
      _showError('Falha: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _clearList() {
    setState(() => _jokes.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piadas do Papai'),
        centerTitle: true,
        actions: [
          if (_jokes.isNotEmpty)
            IconButton(
              onPressed: _clearList,
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Limpar lista',
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loading ? null : _getJoke,
            icon: _loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.emoji_emotions),
            label: Text(_loading ? 'Carregando...' : 'Gerar Piada'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _jokes.isEmpty
                ? const Center(
                    child: Text(
                      'Clique no botão para gerar a primeira piada!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _jokes.length,
                    itemBuilder: (context, index) {
                      final joke = _jokes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.sentiment_satisfied),
                          title: Text(
                            joke.joke,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text('ID: ${joke.id}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
